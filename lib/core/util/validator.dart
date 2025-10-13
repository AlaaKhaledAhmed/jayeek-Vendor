import '../constants/app_string.dart';

class AppValidator {
  //valid empty data============================================================
  static String? validatorEmpty(v) {
    if (v == null || v.isEmpty) {
      return AppMessage.mandatoryTx;
    } else {
      return null;
    }
  }

  //valid Phone data============================================================
  static String? validatorPhone(phone) {
    final phoneRegExp = RegExp(r"^\s*\d{9}$");
    if (phone.trim().isEmpty) {
      return AppMessage.mandatoryTx;
    }
    if (phoneRegExp.hasMatch(phone) == false) {
      return AppMessage.invalidPhone;
    }
    return null;
  }
}
