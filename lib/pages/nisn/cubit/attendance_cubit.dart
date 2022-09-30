import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/attendance.dart';
import '../../../repositories/student_repository.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  // ignore: prefer_const_literals_to_create_immutables
  AttendanceCubit() : super(AttendanceInitial(attendances: []));

  final _repo = AttendanceRepository();

  int _page = 0;
  int attendanceCount = 0;

  Future<void> loadMore({
    String? search,
    String? type,
    int? categoryIndex,
  }) async {
    int version = state.incrementVersion();

    emit(AttendanceSuccess(version, state.props[1] as List<Attendance>));

    await getListAttendance(_page + 1,
        search: search, categoryIndex: categoryIndex);
  }

  Future<void> initialLoad({
    String? search,
    bool onlyRecomended = false,
    int? categoryIndex,
  }) async {
    emit(AttendanceLoading(state));
    await getListAttendance(0, search: search, categoryIndex: categoryIndex);
  }

  Future<void> getListAttendance(
    int page, {
    String? search,
    int? categoryIndex,
  }) async {
    final response = await _repo.getAttendanceList(
      search: search ?? '',
      page: page,
    );

    if (response.statusCode == 200) {
      int version = state.incrementVersion();

      if (response.data.isNotEmpty) {
        _page = page;
      }
      final list = response.data;
      List<Attendance> currentList = state.props[1] as List<Attendance>;

      if (page == 0) {
        currentList = list;
      } else {
        currentList.addAll(list);
      }

      if (currentList.isEmpty) {
        if (response.meta!.currentPage < response.meta!.totalPage) {
          loadMore(search: search);
        } else {
          emit(AttendanceSuccess(version, currentList));
        }
      } else {
        emit(AttendanceSuccess(version, currentList));
      }
    } else if (response.statusCode == 404) {
      int version = state.incrementVersion();
      emit(AttendanceEmpty(
          version, response.message!, state.props[1] as List<Attendance>));
    } else {
      int version = state.incrementVersion();
      emit(AttendanceFailed(
          version, response.message!, state.props[1] as List<Attendance>));
    }
  }
}
