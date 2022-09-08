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
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
