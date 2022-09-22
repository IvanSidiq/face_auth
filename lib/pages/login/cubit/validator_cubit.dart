import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

part 'validator_state.dart';

class ValidatorCubit extends Cubit<ValidatorState> {
  ValidatorCubit() : super(ValidatorInitial());

  bool obscureText = false;
  bool showEmailNotValid = false;
  Color borderColor = CustomColor.primary;
  Color textColor = CustomColor.onSurfaceVariant;

  void obscureChange() {
    emit(ObstructChanged());
  }

  void validateEmail(String email) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    emit(ValidateEmail(regex.hasMatch(email)));
  }

  void validateChangeState() {
    emit(ValidateChangeState());
  }
}
