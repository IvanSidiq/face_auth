import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../repositories/auth_repository.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  final _repo = AuthRepository();

  int clickedCounts = 0;

  void tryLogout() {
    emit(ClickedCounts());
  }

  Future<void> logout(String password) async {
    emit(AuthLogoutLoading());
    final response = await _repo.logout(password: password);

    if (response.statusCode == 200) {
      emit(AuthLogoutSuccess());
    } else {
      emit(AuthLogoutFailed());
    }
  }
}
