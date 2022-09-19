import 'package:face_auth/pages/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:face_auth/pages/home_page.dart';
import 'package:face_auth/locator.dart';

void main() {
  setupLocator();
  runApp(const FaceAuthApp());
}

class FaceAuthApp extends StatelessWidget {
  const FaceAuthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
