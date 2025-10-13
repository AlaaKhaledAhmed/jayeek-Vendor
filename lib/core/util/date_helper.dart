import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateUtilsHelper {
  static String convertStringDateToStringFormat(
      {required String? dateString, required BuildContext context}) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      final DateTime dateTime = DateTime.parse(dateString);

      final locale = EasyLocalization.of(context)?.locale.toString() ?? 'ar';

      initializeDateFormatting(locale);

      String formattedDate = DateFormat(
        'dd MMMM yyyy',
        locale,
      ).format(dateTime);

      if (locale.startsWith('ar')) {
        formattedDate = _convertToArabicNumbers(formattedDate);
      }

      return formattedDate;
    } catch (e) {
      return ''; // في حالة وجود خطأ في التحويل
    }
  }

  static String _convertToArabicNumbers(String input) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < western.length; i++) {
      input = input.replaceAll(western[i], eastern[i]);
    }
    return input;
  }

  ///convert string to date==================================================
  static DateTime? convertStringToDate(
    BuildContext context,
    String dateString,
  ) {
    initializeDateFormatting(EasyLocalization.of(context)?.locale.toString());
    try {
      // Parse the string date into a DateTime object based on the specified locale
      final DateTime parsedDate = DateFormat.yMMMMd(
        EasyLocalization.of(context)?.locale.toString(),
      ).parse(dateString);

      return parsedDate;
    } catch (e) {
      //  printInfo('Error parsing date: $e');
      return null;
    }
  }

  ///convert date to string===========================================================================================
  static convertDateToString(
      {DateTime? dateTime, required BuildContext context, showTime = false}) {
    final locale = EasyLocalization.of(context)?.locale.toString() ?? 'en';
    initializeDateFormatting(locale);
    final format = showTime
        ? DateFormat(
            'EEEE، d MMMM y  hh : mm a', locale)
        : DateFormat('EEEE، d MMMM y', locale);

    return format.format(dateTime!);
  }

  static String getMonthName(int month) {
    const List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthNames[(month - 1).clamp(0, monthNames.length - 1)];
  }
}
