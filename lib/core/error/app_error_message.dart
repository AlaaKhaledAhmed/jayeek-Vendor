import 'package:easy_localization/easy_localization.dart';

import '../localization/locale_keys.g.dart';
import 'app_error_state.dart';

class AppErrorMessage {
  /// This static method returns a readable message for exceptions
  static String getMessage(String message) {
    switch (message) {
      case AppErrorState.serverExceptions:
        return LocaleKeys.serverText.tr();
      case AppErrorState.socketException:
        return LocaleKeys.socketText.tr();
      case AppErrorState.timeoutException:
        return LocaleKeys.timeoutText.tr();
      case AppErrorState.formatException:
        return LocaleKeys.formatText.tr();
      case AppErrorState.unAuthorized:
        return LocaleKeys.unAuthorizedText.tr();
      default:
        return message;
    }
  }
}
