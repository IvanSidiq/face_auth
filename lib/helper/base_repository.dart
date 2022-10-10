import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:retry/retry.dart';

import '../models/base_response.dart';
import 'exception_helper.dart';

class BaseRepository {
  final Dio dio = GetIt.I<Dio>();

  Future<BaseResponse> fetch(String api,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool activateToast = true}) async {
    try {
      final response = await retry(
        () => dio.get(
          api,
          queryParameters: queryParameters,
          options: Options(
            responseType: ResponseType.json,
            headers: headers,
          ),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return BaseResponse(
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioError catch (e) {
      return ExceptionHelper(e).catchException(activateToast: activateToast);
    }
  }

  Future<BaseResponse> post(
    String api, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await retry(
        () => dio.post(
          api,
          data: json.encode(data),
          options: Options(responseType: ResponseType.json, headers: headers),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return BaseResponse(
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioError catch (e) {
      return ExceptionHelper(e).catchException();
    }
  }

  Future<BaseResponse> patch(
    String api, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await retry(
        () => dio.patch(
          api,
          data: json.encode(data),
          options: Options(responseType: ResponseType.json, headers: headers),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return BaseResponse(
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioError catch (e) {
      return ExceptionHelper(e).catchException();
    }
  }

  Future<BaseResponse> put(String api, Map<String, dynamic>? headers,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await retry(
        () => dio.put(
          api,
          data: json.encode(data),
          queryParameters: queryParameters,
          options: Options(headers: headers),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return BaseResponse(
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioError catch (e) {
      return ExceptionHelper(e).catchException();
    }
  }

  Future<BaseResponse> putFile(String api, Map<String, dynamic>? headers,
      {required File data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await retry(
        () => dio.put(
          api,
          data: data.readAsBytesSync(),
          queryParameters: queryParameters,
          options: Options(headers: headers),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return BaseResponse(
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioError catch (e) {
      return ExceptionHelper(e).catchException();
    }
  }

  Future<BaseResponse> delete(String api, Map<String, dynamic>? headers,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await retry(
        () => dio.delete(
          api,
          data: json.encode(data),
          queryParameters: queryParameters,
          options: Options(headers: headers),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return BaseResponse(
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioError catch (e) {
      return ExceptionHelper(e).catchException();
    }
  }

  Future<BaseResponse> postFormData(
    String api, {
    Map<String, dynamic>? headers,
    FormData? data,
  }) async {
    try {
      final response = await retry(
        () => dio.post(
          api,
          data: data,
          options: Options(responseType: ResponseType.json, headers: headers),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return BaseResponse(
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioError catch (e) {
      return ExceptionHelper(e).catchException();
    }
  }

  Future<BaseResponse> login(
    String api, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await retry(
        () => dio.post(
          api,
          data: json.encode(data),
          queryParameters: queryParameters,
          options: Options(responseType: ResponseType.json),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return BaseResponse(
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioError catch (e) {
      return ExceptionHelper(e).catchException(activateToast: false);
    }
  }

  Future<BaseResponse> register(
    String api, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await retry(
        () => dio.post(
          api,
          data: json.encode(data),
          queryParameters: queryParameters,
          options: Options(responseType: ResponseType.json),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return BaseResponse(
        statusCode: response.statusCode,
        data: response.data,
      );
    } on DioError catch (e) {
      return ExceptionHelper(e).catchException();
    }
  }
}
