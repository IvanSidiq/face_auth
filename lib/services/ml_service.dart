import 'dart:typed_data';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'package:image/image.dart' as img;

class MLService {
  late FaceDetector _faceDetector;

  void initialize() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<List<int>> detectFaces(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final faces = await _faceDetector.processImage(inputImage);
    final detectedFace = faces[0];

    double x = detectedFace.boundingBox.left;
    double y = detectedFace.boundingBox.top;
    double h = detectedFace.boundingBox.height;
    double w = detectedFace.boundingBox.width;

    return [
      x.toInt(),
      y.toInt(),
      w.toInt(),
      h.toInt(),
    ];
  }

  Float32List imageToByteListFloat32(img.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (img.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (img.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  Future<void> dispose() async {
    await _faceDetector.close();
  }
}
