part of 'school_profile_cubit.dart';

@immutable
abstract class SchoolProfileState {}

class SchoolProfileInitial extends SchoolProfileState {}

class GetSchoolProfileSuccess extends SchoolProfileState {
  final School school;
  GetSchoolProfileSuccess(this.school);
}

class GetSchoolProfileFailed extends SchoolProfileState {}

class GetSchoolProfileLoading extends SchoolProfileState {}
