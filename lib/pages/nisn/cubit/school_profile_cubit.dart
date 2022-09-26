import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../models/school.dart';
import '../../../repositories/school_repository.dart';

part 'school_profile_state.dart';

class SchoolProfileCubit extends Cubit<SchoolProfileState> {
  SchoolProfileCubit() : super(SchoolProfileInitial());

  final _repo = SchoolRepository();

  Future<void> getSchoolProfile() async {
    emit(GetSchoolProfileLoading());
    final response = await _repo.getSchoolProfile();

    if (response.statusCode == 200) {
      emit(GetSchoolProfileSuccess(response.data));
    } else {
      emit(GetSchoolProfileFailed());
    }
  }
}
