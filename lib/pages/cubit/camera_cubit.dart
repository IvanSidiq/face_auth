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

import '../../services/camera_service.dart';
import '../../services/image_service.dart';
import '../../services/ml_service.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  final ImageService imageService = GetIt.I<ImageService>();
  final CameraService cameraService = GetIt.I<CameraService>();
  final MLService mlService = GetIt.I<MLService>();

  Interpreter? interpreter;

  late FaceDetector faceDetector;
  Face? detectedFace;
  Size? imageSize;
  List? tfliteData;

  String? savedUser;
  List? userSavedFaceData;
  String? userSavedPath;

  bool isInitialized = false;
  String? imagePath;
  late Timer? timer;

  List<int> lastBBox = [];

  double currDist = 0.0;
  double similarity = 0.0;
  double minkowskiDist = 0.0;

  Future<void> initCamera() async {
    await cameraService.initialize();
    initializeFaceDetector();
    await streamFaceReader();
    await initializeInterpreter();
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
    await cameraService.dispose();
    await mlService.dispose();
    timer!.cancel();
  }

  Future<void> processImage() async {
    XFile? file = await cameraService.takePicture();
    imageSize = cameraService.getImageSize();
    String filePath = file != null ? file.path : '';
    final inputImage = InputImage.fromFilePath(filePath);
    final faces = await faceDetector.processImage(inputImage);
    detectedFace = faces[0];

    double x = detectedFace!.boundingBox.left - 10;
    double y = detectedFace!.boundingBox.top - 10;
    double h = detectedFace!.boundingBox.height + 10;
    double w = detectedFace!.boundingBox.width + 10;

    List<int> bbox = [
      x.toInt(),
      y.toInt(),
      w.toInt(),
      h.toInt(),
    ];
    lastBBox = bbox;

    String croppedPath =
        '${(await getTemporaryDirectory()).path}/cropped_face.jpg';

    croppedPath =
        imageService.drawRect(filePath, bbox[0], bbox[1], bbox[2], bbox[3]);

    await getTfliteData(croppedPath);
    emit(ImageProcessed(croppedPath));
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

  Future<void> saveData(List tfliteData, String user) async {
    userSavedFaceData = tfliteData;
    savedUser = user;
    String croppedPath =
        '${(await getTemporaryDirectory()).path}/cropped_face.jpg';
    String savedPath = '${(await getTemporaryDirectory()).path}/saved_face.jpg';
    userSavedPath = savedPath;
    await File(croppedPath).copy(savedPath);
    // DatabaseHelper databaseHelper = DatabaseHelper.instance;
    // List predictedData = List.from(tfliteData);
    // User userToSave = User(
    //   user: user,
    //   modelData: predictedData,
    // );
    // await databaseHelper.insert(userToSave);
    emit(DataSaved());
  }

  Future<void> calculateDist() async {
    // DatabaseHelper _dbHelper = DatabaseHelper.instance;

    // List<User> users = await _dbHelper.queryAllUsers();
    // double minDist = 999;
    // double threshold = 0.5;
    // User? predictedResult;

    double currDistC = _euclideanDistance(userSavedFaceData, tfliteData);
    currDistC = 1 / (1 + currDistC);
    final similarityC = _cosineSimilarity(userSavedFaceData, tfliteData);
    double minkowskiDistC =
        _minkowskiDistance(userSavedFaceData, tfliteData, 4);
    minkowskiDistC = 1 / (1 + minkowskiDistC);
    // print(currDist);
    // if (currDistC <= threshold && currDistC < minDist) {
    //   minDist = currDistC;
    // }

    emit(CalculateDistance(currDistC, similarityC, minkowskiDistC));

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
    if (a == null || b == null) throw Exception("Null argument");
    if (a.length != b.length) {
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
