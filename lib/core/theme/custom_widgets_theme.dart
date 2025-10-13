import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../constants/app_color.dart';
import '../constants/app_size.dart';

OutlineInputBorder border({double width = 1, Color? color}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(6.r),
    borderSide: BorderSide(color: color ?? AppColor.lightGray, width: width),
  );
}

defaultPinTheme() {
  return PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: AppSize.captionText,
      color: AppColor.textColor,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.subtextColor),
      borderRadius: BorderRadius.circular(8.r),
    ),
  );
}

errorPinTheme() {
  //==========================================================================
  return PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: AppSize.captionText,
      color: AppColor.red,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.red),
      borderRadius: BorderRadius.circular(8.r),
    ),
  );
}

focusedPinTheme() {
  //==========================================================================
  return PinTheme(
    width: 60,
    height: 60,
    textStyle: TextStyle(
      fontSize: AppSize.captionText,
      color: AppColor.textColor,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.mainColor),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

submittedPinTheme() {
  //==========================================================================
  return PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: AppSize.captionText,
      color: AppColor.textColor,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: AppColor.lightGray,
      border: Border.all(color: AppColor.lightGray),
      borderRadius: BorderRadius.circular(8.r),
    ),
  );
}
