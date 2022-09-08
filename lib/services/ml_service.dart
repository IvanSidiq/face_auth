import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

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

  dispose() {}
}
