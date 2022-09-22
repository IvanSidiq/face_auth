part of 'validator_cubit.dart';

@immutable
abstract class ValidatorState {}

class ValidatorInitial extends ValidatorState {}

class ObstructChanged extends ValidatorState {}

class ValidateChangeState extends ValidatorState {}

class ValidateEmail extends ValidatorState {
  final bool emailIsValid;

  ValidateEmail(this.emailIsValid);
}
