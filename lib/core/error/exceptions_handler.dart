import 'dart:io';

import 'package:dio/dio.dart';

import '../model/data_handel.dart';
import 'app_error_state.dart';

class ExceptionsHandler {
  static PostDataHandle<T> onDioException<T>(DioException e) {
    String message;

    final code = e.response?.statusCode;

    ///unAuthorized error
    if (code == 401) {
      message = AppErrorState.unAuthorized;
    }

    ///validation error
    else if (code == 422 || code == 404) {
      message = e.response?.data['message'];
    }

    ///timeout error
    else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      message = AppErrorState.timeoutException;
    }

    ///socket error
    else if (e.error is SocketException) {
      message = AppErrorState.socketException;
    } else {
      message = AppErrorState.serverExceptions;
    }

    ///server error

    return PostDataHandle<T>(
      hasError: true,
      message: message,
      statusCode: code,
    );
  }
}
