part of 'button_cubit.dart';

@immutable
abstract class ButtonState {}

class ButtonInitial extends ButtonState {}

class ChangeButtonState extends ButtonState {
  final bool value;

  ChangeButtonState(this.value);
}
