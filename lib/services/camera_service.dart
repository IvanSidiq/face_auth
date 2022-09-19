import 'package:camera/camera.dart';
import 'dart:ui';

class CameraService {
  CameraController? cameraController;

  String? imagePath;

  Future<void> initialize() async {
    if (cameraController != null) return;
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
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);
    await cameraController!.initialize();
  }

  Future<XFile?> takePicture() async {
    if (cameraController == null) return null;
    XFile? filePath = await cameraController?.takePicture();
    imagePath = filePath?.path;
    return filePath;
  }

  Size getImageSize() {
    if (cameraController == null) return Size.zero;
    if (cameraController!.value.previewSize == null) return Size.zero;
    return Size(
      cameraController!.value.previewSize!.width,
      cameraController!.value.previewSize!.height,
    );
  }

  dispose() async {
    await cameraController?.dispose();
    cameraController = null;
  }
}
