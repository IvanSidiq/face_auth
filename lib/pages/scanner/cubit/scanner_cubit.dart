import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit() : super(ScannerInitial());

  Future<void> processQrCode(String qrData) async {
    final regex = RegExp(
        r"^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$",
        caseSensitive: false);
    if (regex.hasMatch(qrData)) {
      emit(ScannerSuccess(qrData: qrData));
    } else {
      emit(ScannerFailed());
    }
  }
}
