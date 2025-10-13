import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import '../../app/app.dart';

import '../constants/app_string.dart';
import '../widgets/app_text.dart';

enum ToastType { info, success, warning, error }

class AppSnackBar {
  AppSnackBar._();

  static void show({
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 10),
    double bottomPadding = 20.0,
  }) {
    final context = myNavigatorKey.currentContext;
    if (context == null) return;

    final snackBar = SnackBar(
      content: _buildContent(message, type),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: bottomPadding.h),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Widget _buildContent(String message, ToastType type) {
    final color = _getColor(type);
    final icon = _getIcon(type);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.resolveOpacity(0.15),
            radius: 20.r,
            child: Icon(icon, color: color, size: 22.spMin),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: _getTitle(type),
                  fontWeight: FontWeight.bold,
                  fontSize: 15.spMin,
                  color: Colors.black,
                ),
                SizedBox(height: 3.h),
                AppText(
                  text: message,
                  fontWeight: FontWeight.normal,
                  fontSize: 13.5.spMin,
                  color: Colors.black.resolveOpacity(0.7),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(
                myNavigatorKey.currentContext!,
              ).hideCurrentSnackBar();
            },
            child: Icon(Icons.close, color: Colors.grey[600], size: 18.sp),
          ),
        ],
      ),
    );
  }

  static Color _getColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.error:
        return Colors.red;

      case ToastType.info:
        return Colors.blue;
    }
  }

  static IconData _getIcon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Icons.check;
      case ToastType.warning:
        return Icons.warning_amber_rounded;
      case ToastType.error:
        return Icons.block;

      case ToastType.info:
        return Icons.info_outline;
    }
  }

  static _getTitle(ToastType type) {
    switch (type) {
      case ToastType.success:
        return AppMessage.success;
      case ToastType.warning:
        return AppMessage.warning;
      case ToastType.error:
        return AppMessage.error;
      case ToastType.info:
        return AppMessage.info;
    }
  }
}
