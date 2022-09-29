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
      // var scale =
      //     cameraService.cameraController!.value.aspectRatio * deviceRatio;
      // if (scale < 1) {
      //   scale = 1 / scale;
      // }
      // return Center(
      //   child: Transform.scale(
      //     scale: cameraService.cameraController!.value.aspectRatio / deviceRatio,
      //     child: AspectRatio(
      //       aspectRatio: cameraService.cameraController!.value.aspectRatio,
      //       child: CameraPreview(cameraService.cameraController!),
      //     ),
      //   ),
      // );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
