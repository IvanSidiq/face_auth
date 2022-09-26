import 'meta.dart';

class BaseResponse<T> {
  final int? statusCode;
  final dynamic message;
  final Meta? meta;
  final T? data;

  BaseResponse({
    this.message,
    this.meta,
    this.data,
    this.statusCode,
  });
}
