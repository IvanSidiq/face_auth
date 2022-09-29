part of 'camera_cubit.dart';

@immutable
abstract class CameraState {}

class CameraInitial extends CameraState {}

class CameraInitialized extends CameraState {}

class ImageProcessed extends CameraState {
  final String croppedPath;

  ImageProcessed(this.croppedPath);
}

class FaceDetected extends CameraState {
  final Face? face;

  FaceDetected(this.face);
}

class FaceDetectedBut extends CameraState {
  final String message;

  FaceDetectedBut({required this.message});
}

class NoFaceDetected extends CameraState {}

class TfliteError extends CameraState {}

class TfliteDataSuccess extends CameraState {
  final List data;

  TfliteDataSuccess(this.data);
}

class InitializeInterpreterSuccess extends CameraState {
  final Interpreter interpreter;

  InitializeInterpreterSuccess(this.interpreter);
}

class CalculateDistance extends CameraState {
  final double dist;
  final double similarity;
  final double minkowski;

  CalculateDistance(this.dist, this.similarity, this.minkowski);
}

class DataSaved extends CameraState {}
