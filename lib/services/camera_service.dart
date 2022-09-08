import 'package:camera/camera.dart';
import 'dart:ui';

class CameraService {
  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  String? _imagePath;
  String? get imagePath => _imagePath;

  Future<void> initialize() async {
    if (_cameraController != null) return;
    CameraDescription cameraDescription = await _getCameraDescription();
    await _setupCameraController(cameraDescription: cameraDescription);
  }

  Future<CameraDescription> _getCameraDescription() async {
    List<CameraDescription> cameras = await availableCameras();
    return cameras[1];
  }

  Future<void> _setupCameraController({
    required CameraDescription cameraDescription,
  }) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.low,
    );
    await _cameraController!.initialize();
  }

  Future<XFile?> takePicture() async {
    if (_cameraController == null) return null;
    XFile? filePath = await _cameraController?.takePicture();
    _imagePath = filePath?.path;
    return filePath;
  }

  Size getImageSize() {
    if (_cameraController == null) return Size.zero;
    if (_cameraController!.value.previewSize == null) return Size.zero;
    return Size(
      _cameraController!.value.previewSize!.width,
      _cameraController!.value.previewSize!.height,
    );
  }

  dispose() async {
    await _cameraController?.dispose();
    _cameraController = null;
  }
}
