import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final _repo = AuthRepository();

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    final response = await _repo.loginUserPass(email, password);

    if (response.statusCode == 200) {
      emit(LoginSuccess());
    } else {
      emit(LoginFailed());
    }
  }
}
