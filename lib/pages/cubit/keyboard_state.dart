part of 'keyboard_cubit.dart';

@immutable
abstract class KeyboardState {}

class KeyboardInitial extends KeyboardState {}

class AddNum extends KeyboardState {
  final String num;

  AddNum(this.num);
}

class ReduceNum extends KeyboardState {}

class ClearAll extends KeyboardState {}
