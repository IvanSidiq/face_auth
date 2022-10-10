import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../models/attendance.dart';
import '../../../models/attendance_face.dart';
import '../../../repositories/student_repository.dart';

part 'face_attendance_state.dart';

class FaceAttendanceCubit extends Cubit<FaceAttendanceState> {
  FaceAttendanceCubit() : super(FaceAttendanceInitial());

  final _repo = AttendanceRepository();
  String name = '';
  String nis = '';
  String attendanceId = '';
  String dateId = '';
  List<double> faceVector = [];

  Future<void> getAttendanceData(String userId) async {
    emit(GetAttendanceDataLoading());
    final response = await _repo.getAttendanceData(userId: userId);

    if (response.statusCode == 200) {
      emit(GetAttendanceDataSuccess(response.data));
    } else {
      emit(GetAttendanceDataFailed());
    }
  }

  Future<void> getAttendanceFace(String userId) async {
    emit(GetAttendanceFaceDataLoading());
    final response = await _repo.getAttendanceFaceData(userId: userId);

    if (response.statusCode == 200) {
      emit(GetAttendanceFaceDataSuccess(response.data));
    } else {
      emit(GetAttendanceFaceDataFailed());
    }
  }

  Future<void> attendingAttendance({
    required double similarityC,
    required String attendanceId,
    required String dateId,
    required File faceFile,
  }) async {
    emit(AttendingAttendanceLoading());
    final response = await _repo.postAttendanceAttend(
      similarityC: similarityC,
      attendanceId: attendanceId,
      dateId: dateId,
      faceFile: faceFile,
    );

    if (response.statusCode == 200) {
      emit(AttendingAttendanceSuccess());
    } else {
      emit(AttendingAttendanceFailed());
    }
  }
}
