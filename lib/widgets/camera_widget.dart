import 'package:face_auth/services/camera_service.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatelessWidget {
  const CameraWidget(
      {Key? key,
      required this.cameraService,
      required this.deviceRatio,
      required this.isCameraInitialized})
      : super(key: key);

  final CameraService cameraService;
  final bool isCameraInitialized;
  final double deviceRatio;

  @override
  Widget build(BuildContext context) {
    if (isCameraInitialized) {
      return CameraPreview(cameraService.cameraController!);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
