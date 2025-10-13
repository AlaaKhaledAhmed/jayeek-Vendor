import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/app.dart';
import 'error_log.dart';
import 'error_screen.dart';

void initGlobalErrorHandling() {
  ///1. Handle Flutter UI Errors
  ErrorWidget.builder = (errorDetails) {
    return MediaQuery(
      data: MediaQuery.of(myNavigatorKey.currentContext!).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ), // This will ensure that the widget respects the screen size
      child: ErrorScreen(errorDetails),
    );
  };

  ///Todo: un comment this in release
  ///Handle framework-level Flutter errors
  //FlutterError.onError = (details) {
  //printInfo('${details.stack}', title: 'Flutter Error:', isError: true);

  ///send error to crashlytics when app is in release mode
  // errorLog(details, details.stack ?? StackTrace.current);
  //};

  /// Handle Platform/System Errors
  ///like Native platform errors
  ///Memory issues
  ///Hardware-related failures
  ///fatal means the error kill app and must have high priority
  PlatformDispatcher.instance.onError = (error, stack) {
    errorLog(error, stack, fatal: true);
    return true;
  };
}
