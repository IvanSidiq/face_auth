part of 'scanner_cubit.dart';

@immutable
abstract class ScannerState {}

class ScannerInitial extends ScannerState {}

class ScannerLoading extends ScannerState {}

class ScannerFailed extends ScannerState {}

class ScannerSuccess extends ScannerState {
  final String qrData;

  ScannerSuccess({required this.qrData});
}

class ScannerLauncUrl extends ScannerState {
  final String qrUrl;

  ScannerLauncUrl(this.qrUrl);
}
