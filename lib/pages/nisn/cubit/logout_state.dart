part of 'logout_cubit.dart';

@immutable
abstract class LogoutState {}

class LogoutInitial extends LogoutState {}

class AuthLogoutLoading extends LogoutState {}

class AuthLogoutSuccess extends LogoutState {}

class AuthLogoutFailed extends LogoutState {}

class ClickedCounts extends LogoutState {}
