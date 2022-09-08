import 'package:camera/camera.dart';
import 'package:face_auth/locator.dart';
import 'package:face_auth/services/camera_service.dart';
import 'package:face_auth/services/image_service.dart';
import 'package:face_auth/services/ml_service.dart';
import 'package:face_auth/widgets/camera_widget.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImageService _imageService = locator<ImageService>();
  final CameraService _cameraService = locator<CameraService>();
  final MLService _mlService = locator<MLService>();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _mlService.dispose();
    super.dispose();
  }

  void _start() async {
    await _cameraService.initialize();
    _mlService.initialize();
    setState(() => _isInitialized = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FaceAuth'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 4 * MediaQuery.of(context).size.height / 8,
                  child: CameraWidget(
                    cameraService: _cameraService,
                    isCameraInitialized: _isInitialized,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  XFile? file = await _cameraService.takePicture();
                  String filePath = file != null ? file.path : '';
                  List<int> bbox = await _mlService.detectFaces(filePath);
                  String croppedPath = _imageService.drawRect(
                      filePath, bbox[0], bbox[1], bbox[2], bbox[3]);
                  if (mounted) {
                    Navigator.pop(context, [croppedPath, bbox.toString()]);
                  }
                },
                child: const Text('Take a picture'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
