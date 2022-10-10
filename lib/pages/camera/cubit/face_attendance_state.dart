part of 'face_attendance_cubit.dart';

@immutable
abstract class FaceAttendanceState {}

class FaceAttendanceInitial extends FaceAttendanceState {}

class GetAttendanceDataSuccess extends FaceAttendanceState {
  final Attendance attendance;

  GetAttendanceDataSuccess(this.attendance);
}

class GetAttendanceDataLoading extends FaceAttendanceState {}

class GetAttendanceDataFailed extends FaceAttendanceState {}

class GetAttendanceFaceDataSuccess extends FaceAttendanceState {
  final AttendanceFace face;

  GetAttendanceFaceDataSuccess(this.face);
}

class GetAttendanceFaceDataLoading extends FaceAttendanceState {}

class GetAttendanceFaceDataFailed extends FaceAttendanceState {}

class AttendingAttendanceSuccess extends FaceAttendanceState {}

class AttendingAttendanceLoading extends FaceAttendanceState {}

class AttendingAttendanceFailed extends FaceAttendanceState {}
