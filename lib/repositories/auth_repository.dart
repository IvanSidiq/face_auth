import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../helper/base_repository.dart';
import '../models/base_response.dart';
import '../models/user.dart';
import '../services/navigation_service.dart';
import '../services/user_service.dart';
import '../utils/api.dart';
import '../utils/constant.dart';
import '../utils/customs/custom_toast.dart';

class AuthRepository extends BaseRepository {
  Future<BaseResponse> loginUserPass(String email, String password) async {
    final response =
        await login(kApiLogin, data: {'email': email, 'password': password});

    if (response.statusCode == 201) {
      final user = User.fromJson(response.data);
      GetIt.I<UserService>().setUser = user;
      GetIt.I<FlutterSecureStorage>()
          .write(key: '$faBpls-$faBplsUser', value: user.id);
      GetIt.I<NavigationServiceMain>().pushReplacementNamed('/choose_nisn');
      return BaseResponse(
        statusCode: response.statusCode,
        data: user,
      );
    }

    return response;
  }

  Future<BaseResponse> registerUserPass(
      String name, String email, String password) async {
    final response = await register(kApiRegister, data: {
      'name': name,
      'email': email,
      'password': password,
      'role': 3,
    });

    if (response.statusCode == 201) {
      final user = User.fromJson(response.data);
      GetIt.I<UserService>().setUser = user;
      GetIt.I<FlutterSecureStorage>()
          .write(key: '$faBpls-$faBplsUser', value: user.id);
      GetIt.I<NavigationServiceMain>().pushRemoveUntil('/root', args: {
        'showNewAlert': true,
        'showSuccessRegistAlert': false,
        'initPage': 0
      });

      return BaseResponse(
        statusCode: response.statusCode,
        data: user,
      );
    }

    return response;
  }

  Future<BaseResponse> logout() async {
    final response = await fetch(kApiLogout);

    if (response.statusCode == 200) {
      CustomToast.showToastSuccess('Logged out');
      GetIt.I<FlutterSecureStorage>().delete(key: '$faBpls-$faBplsUser');
      GetIt.I<NavigationServiceMain>().pushRemoveUntil('/login');
      return response;
    }

    return response;
  }
}
