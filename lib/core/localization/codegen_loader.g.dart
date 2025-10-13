// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> _ar = {
    "unAuthorizedText": "انتهت صلاحية الجلسة",
    "tryAgain": "إعادة المحاولة",
    "serverText": "حدث خطأ ما اثناء معالجة طلبك",
    "socketText": "لايوجد اتصال بالانترنت",
    "timeoutText":
        "يبدو أن الخادم يستغرق وقتًا طويلاً للاستجابة، حاول مجدداً بعد فترة",
    "formatText": "تعذر إتمام العملية في الوقت الحالي.",
  };
  static const Map<String, dynamic> _en = {
    "unAuthorizedText": "Session expired",
    "tryAgain": "Try Again",
    "serverText": "An error occurred while processing your request",
    "socketText": "No internet connection",
    "timeoutText":
        "It seems the server is taking too long to respond. Please try again later",
    "formatText": "Unable to complete the operation at this time.",
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "ar": _ar,
    "en": _en,
  };
}
