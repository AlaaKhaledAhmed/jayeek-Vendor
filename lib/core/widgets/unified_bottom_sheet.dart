import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_color.dart';
import '../constants/app_icons.dart';
import '../constants/app_size.dart';
import '../constants/app_string.dart';
import 'app_text.dart';
import 'app_buttons.dart';

/// Unified bottom sheet system for all dialog types
/// Supports confirmation, info, and custom content
class UnifiedBottomSheet {
  /// Shows a confirmation bottom sheet
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
    Color? cancelColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) async {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColor.black.withOpacity(0.3),
      isDismissible: barrierDismissible,
      enableDrag: barrierDismissible,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: AppColor.mediumGray,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Title
              AppText(
                text: title,
                fontSize: AppSize.heading3,
                fontWeight: FontWeight.bold,
                color: AppColor.textColor,
              ),
              SizedBox(height: 16.h),
              // Message
              AppText(
                text: message,
                fontSize: AppSize.normalText,
                color: AppColor.subGrayText,
                align: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButtons(
                      text: cancelText ?? AppMessage.cancel,
                      onPressed: () {
                        Navigator.pop(context, false);
                        onCancel?.call();
                      },
                      backgroundColor: cancelColor ?? AppColor.lightGray,
                      textStyleColor: AppColor.textColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButtons(
                      text: confirmText ?? AppMessage.confirm,
                      onPressed: () {
                        Navigator.pop(context, true);
                        onConfirm?.call();
                      },
                      backgroundColor: confirmColor ?? AppColor.mainColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows an info bottom sheet
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColor.black.withOpacity(0.3),
      isDismissible: barrierDismissible,
      enableDrag: barrierDismissible,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: AppColor.mediumGray,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Icon
              Icon(
                AppIcons.warning,
                size: 48.sp,
                color: AppColor.mainColor,
              ),
              SizedBox(height: 16.h),
              // Title
              AppText(
                text: title,
                fontSize: AppSize.heading3,
                fontWeight: FontWeight.bold,
                color: AppColor.textColor,
              ),
              SizedBox(height: 12.h),
              // Message
              AppText(
                text: message,
                fontSize: AppSize.normalText,
                color: AppColor.subGrayText,
                align: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              // Button
              AppButtons(
                text: buttonText ?? AppMessage.ok,
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm?.call();
                },
                backgroundColor: AppColor.mainColor,
                width: double.infinity,
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a custom content bottom sheet
  static Future<T?> showCustom<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double? height,
    bool barrierDismissible = true,
    bool showDragHandle = true,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColor.black.withOpacity(0.3),
      isDismissible: barrierDismissible,
      enableDrag: barrierDismissible,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: height ?? MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDragHandle)
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
                  decoration: BoxDecoration(
                    color: AppColor.mediumGray,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              if (title != null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: AppText(
                    text: title,
                    fontSize: AppSize.heading3,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textColor,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              Flexible(child: child),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
