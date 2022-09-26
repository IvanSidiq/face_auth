import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/base_response.dart';
import '../services/navigation_service.dart';
import '../utils/constant.dart';
import '../utils/customs/custom_toast.dart';

class ExceptionHelper<T> {
  final DioError e;
  ExceptionHelper(this.e);

  Future<BaseResponse<T>> catchException({bool activateToast = true}) async {
    String message = '';
    int statusCode = 0;

    await Sentry.captureException(e, stackTrace: e.stackTrace);

    switch (e.type) {
      case DioErrorType.connectTimeout:
        message = faBplsConnectionTimeout;
        statusCode = 500;
        break;
      case DioErrorType.sendTimeout:
        message = faBplsConnectionTimeout;
        statusCode = 500;

        break;
      case DioErrorType.receiveTimeout:
        message = faBplsConnectionTimeout;
        statusCode = 500;

        break;
      case DioErrorType.response:
        if (e.response == null) {
          return BaseResponse(
            message: faBplsErrorCantReachServer,
            statusCode: 0,
          );
        }
        final eResponse = e.response!;
        final statusCode = e.response!.statusCode;

        if (statusCode == 401) {
          if (eResponse is String) {
            message = eResponse as String;
          } else {
            message = '401 Error';
          }

          if (eResponse.requestOptions.path != '/users/login') {
            CustomToast.showToastError(
                'Sesi anda telah berakhir mohon login kembali');
            GetIt.I<NavigationServiceMain>().pushRemoveUntil('/login');
            // GetIt.I<PersistCookieJar>().deleteAll();
            GetIt.I<FlutterSecureStorage>().deleteAll();

            return BaseResponse(
              message: message,
              statusCode: statusCode,
              data: eResponse.data,
            );
          }
          break;
        }
        if (eResponse.data['message'] != null) {
          message = eResponse.data['message'] ?? faBplsErrorException;
        } else {
          message = eResponse.toString();
        }

        break;
      case DioErrorType.cancel:
        message = faBplsErrorException;
        statusCode = 500;

        break;
      case DioErrorType.other:
        if (e.error is SocketException) {
          message = faBplsNoInternetConnection;
        } else {
          message = e.message;
        }
        statusCode = 500;

        break;
    }

    activateToast ? CustomToast.showToastError(message) : {};
    // statusCode >= 500 ? CustomToast.showToastError(message) : {};
    return BaseResponse(
      message: message,
      statusCode: statusCode,
      data: e.response?.data['errors'],
    );
  }
}
