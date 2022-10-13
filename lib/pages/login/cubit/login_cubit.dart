import 'package:bloc/bloc.dart';
import 'package:face_auth/models/user.dart';
import 'package:meta/meta.dart';

import '../../../repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final _repo = AuthRepository();

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    final response = await _repo.loginUserPass(email, password);
    if (response.statusCode == 201) {
      final user = response.data as User;
      if (user.role != 99) {
        emit(LoginFailed());
        await _repo.logoutFromLogin(password: password);
      } else {
        emit(LoginSuccess());
      }
    } else {
      emit(LoginFailed());
    }
  }
}
