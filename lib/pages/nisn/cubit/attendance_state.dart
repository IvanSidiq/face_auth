part of 'attendance_cubit.dart';

abstract class AttendanceState extends Equatable {
  final dynamic page;
  final dynamic propss;

  const AttendanceState({
    this.propss,
    this.page = 1,
  });

  @override
  List<Object> get props => [...propss, page];

  int incrementVersion() {
    int currentVersion = propss[0];
    currentVersion++;
    return currentVersion;
  }
}

class AttendanceInitial extends AttendanceState {
  final int version;
  final List<Attendance>? attendances;

  AttendanceInitial({this.version = 0, this.attendances})
      : super(propss: [version, attendances]);
}

class AttendanceLoading extends AttendanceState {
  final AttendanceState state;

  AttendanceLoading(this.state)
      : super(propss: [state.props[0], state.props[1]]);
}

class AttendanceLoadingChange extends AttendanceState {
  final AttendanceState state;

  AttendanceLoadingChange(this.state)
      : super(propss: [state.props[0], state.props[1]]);
}

class AttendanceSuccess extends AttendanceState {
  final int version;
  final List<Attendance> attendances;
  AttendanceSuccess(this.version, this.attendances)
      : super(propss: [version, attendances]);
}

class AttendanceFailed extends AttendanceState {
  final int version;
  final String error;
  final List<Attendance> listAttendance;

  AttendanceFailed(this.version, this.error, this.listAttendance)
      : super(propss: [version, listAttendance, error]);
}

class AttendanceEmpty extends AttendanceState {
  final int version;
  final String error;
  final List<Attendance> listAttendance;

  AttendanceEmpty(this.version, this.error, this.listAttendance)
      : super(propss: [version, listAttendance, error]);
}
