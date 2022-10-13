import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../services/camera_service.dart';
import '../../../services/image_service.dart';
import '../../../services/ml_service.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  final ImageService imageService = GetIt.I<ImageService>();
  final CameraService cameraService = GetIt.I<CameraService>();
  final MLService mlService = GetIt.I<MLService>();

  Interpreter? interpreter;

  late FaceDetector faceDetector;
  Face? detectedFace;
  Face? detectedFacePaint;
  Size? imageSize;
  List? tfliteData;
  List<double>? faceVector;

  bool isInitialized = false;
  String? imagePath;
  late Timer? timer;
  late Timer? captTimer;
  double captValue = 0;

  late String croppedPath;

  List<int> lastBBox = [];

  double currDist = 0.0;
  double similarity = 0.0;
  double minkowskiDist = 0.0;

  int faceCounter = 0;

  String message = 'Wajah tidak ditemukan';
  String message2 =
      'Posisikan wajah anda agar dapat terpindai oleh kamera dan pastikan anda melepas masker';
  bool withErrorCircle = true;

  Future<void> initCamera() async {
    await cameraService.initialize();
    initializeFaceDetector();
    await streamFaceReader();
    await initializeInterpreter();
    croppedPath = '${(await getTemporaryDirectory()).path}/cropped_face.jpg';
    emit(CameraInitialized());
  }

  Future initializeInterpreter() async {
    late Delegate delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
            inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
            inferencePriority1: TfLiteGpuInferencePriority.minLatency,
            inferencePriority2: TfLiteGpuInferencePriority.auto,
            inferencePriority3: TfLiteGpuInferencePriority.auto,
          ),
        );
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
              allowPrecisionLoss: true,
              waitType: TFLGpuDelegateWaitType.active),
        );
      }
      var interpreterOptions = InterpreterOptions()..addDelegate(delegate);

      final interpreterC = await Interpreter.fromAsset('mobilefacenet.tflite',
          options: interpreterOptions);
      emit(InitializeInterpreterSuccess(interpreterC));
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  void initializeFaceDetector() {
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<void> dispose() async {
    if (timer != null) timer!.cancel();
    await cameraService.dispose();
  }

  Future<void> processImage({bool realProcess = false}) async {
    XFile? file = await cameraService.takePicture();
    imageSize = cameraService.getImageSize();
    String filePath = file != null ? file.path : '';
    final inputImage = InputImage.fromFilePath(filePath);
    final faces = await faceDetector.processImage(inputImage);
    if (faces.isEmpty) {
      emit(NoFaceDetected());
    } else {
      detectedFace = faces[0];

      double x = detectedFace!.boundingBox.left - 10;
      double y = detectedFace!.boundingBox.top - 10;
      double h = detectedFace!.boundingBox.height + 10;
      double w = detectedFace!.boundingBox.width + 10;

      if (!((y < 200 && y > 95) && (x < 160 && x > 60))) {
        // face detected but not inside the circle
        emit(FaceDetectedBut(
            message: 'Mohon letakkan wajah di dalam lingkaran',
            message2:
                'Posisikan wajah anda agar dapat terpindai oleh kamera dan pastikan anda melepas masker'));
      } else if (h < 270 || w < 210) {
        // face detected but not close enough
        emit(FaceDetectedBut(
            message: 'Wajah terlalu jauh',
            message2:
                'Posisikan wajah anda agar dapat terpindai oleh kamera dan pastikan anda melepas masker'));
      } else {
        List<int> bbox = [
          x.toInt(),
          y.toInt(),
          w.toInt(),
          h.toInt(),
        ];
        lastBBox = bbox;

        croppedPath =
            imageService.drawRect(filePath, bbox[0], bbox[1], bbox[2], bbox[3]);

        if (realProcess) {
          await getTfliteData(croppedPath);
        } else {
          startCaptTimer();
        }

        emit(ImageProcessed(croppedPath));
      }
    }
  }

  Future<void> getTfliteData(String path) async {
    if (interpreter == null) {
      print('TfliteError');
      emit(TfliteError());
    } else {
      final bytes = await File(path).readAsBytes();
      final img.Image? image = img.decodeImage(bytes);

      img.Image resizedImage = img.copyResizeCropSquare(image!, 112);

      Float32List imageAsList = mlService.imageToByteListFloat32(resizedImage);

      final input = imageAsList.reshape([1, 112, 112, 3]);
      List output = List.generate(1, (index) => List.filled(192, 0));

      interpreter?.run(input, output);
      output = output.reshape([192]);

      emit(TfliteDataSuccess(List.from(output)));
    }
  }

  Future<void> startCaptTimer() async {
    timer!.cancel();
    captTimer = Timer.periodic(const Duration(milliseconds: 40), (time) async {
      emit(ChangeCaptTimerValue(captValue + 0.02));
    });
  }

  Future<void> calculateDist() async {
    // DatabaseHelper _dbHelper = DatabaseHelper.instance;

    // List<User> users = await _dbHelper.queryAllUsers();
    // double minDist = 999;
    // double threshold = 0.5;
    // User? predictedResult;

    double euclC = _euclideanDistance(faceVector, tfliteData) * 100;
    euclC = 1 / (1 + euclC);
    final similarityC = _cosineSimilarity(faceVector, tfliteData) * 100;
    double minkowskiDistC = _minkowskiDistance(faceVector, tfliteData, 4) * 100;
    minkowskiDistC = 1 / (1 + minkowskiDistC);

    // print(currDist);
    // if (currDistC <= threshold && currDistC < minDist) {
    //   minDist = currDistC;
    // }

    emit(CalculateDistance(euclC, similarityC, minkowskiDistC));

    // for (User u in users) {
    //   currDist = _euclideanDistance(u.modelData, predictedData);
    //   if (currDist <= 0.5 && currDist < minDist) {
    //     //TODO: treshold to remote config
    //     minDist = currDist;
    //     predictedResult = u;
    //   }
    // }
    // return predictedResult;
  }

  // double _euclideanDistance(List? e1, List? e2) {
  //   if (e1 == null || e2 == null) throw Exception("Null argument");

  //   double sum = 0.0;
  //   for (int i = 0; i < e1.length; i++) {
  //     sum += pow((e1[i] - e2[i]), 2);
  //   }
  //   return sqrt(sum);
  // }

  double _cosineSimilarity(List? a, List? b) {
    if (a == null || b == null) {
      emit(CalculateDistanceError());
      throw Exception("Null argument");
    }
    if (a.length != b.length) {
      emit(CalculateDistanceError());
      throw Exception('Vectors must be of the same length');
    }
    double dotProduct = 0.0;
    double aLength = 0.0;
    double bLength = 0.0;
    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      aLength += a[i] * a[i];
      bLength += b[i] * b[i];
    }
    return dotProduct / (sqrt(aLength) * sqrt(bLength));
  }

  double _minkowskiDistance(List? a, List? b, double p) {
    if (a == null || b == null) throw Exception("Null argument");
    if (a.length != b.length) {
      throw Exception('Vectors must be of the same length');
    }
    double sum = 0.0;
    for (int i = 0; i < a.length; i++) {
      sum += pow((a[i] - b[i]).abs(), p);
    }
    return pow(sum, 1 / p).toDouble();
  }

  // euclidean distance
  // https://en.wikipedia.org/wiki/Euclidean_distance
  double _euclideanDistance(List? a, List? b) {
    return _minkowskiDistance(a, b, 2);
  }

  Future<void> streamFaceReader() async {
    timer = Timer.periodic(const Duration(seconds: 2), (time) async {
      await processImage();
    });
  }
}
