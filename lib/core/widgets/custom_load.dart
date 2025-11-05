import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/context_extensions.dart';
import '../constants/app_color.dart';
import '../constants/app_size.dart';
import 'app_decoration.dart';

class CustomLoad {
  /// 1. Private static instance
  static final CustomLoad _instance = CustomLoad._internal();

  /// 2. Private constructor
  CustomLoad._internal();

  /// 3. Public factory constructor
  factory CustomLoad() => _instance;

  ///CircularProgressIndicator load
  Widget circularLoad({Color? color}) {
    return SizedBox(
      height: 30.spMin,
      width: 30.spMin,
      child: CircularProgressIndicator(
        color: color ?? AppColor.white,
        strokeWidth: 1.9.r,
      ),
    );
  }

  Widget loadVerticalList({required BuildContext context, int length = 10}) {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: length,
        itemBuilder:
            (context, index) => Container(
              margin: EdgeInsets.only(bottom: 10.h,left: 10.w,right: 10.w),
              height: 100.h,
              width: context.width,
              decoration: AppDecoration.decoration(shadow: false,color: AppColor.lightGray),
            ),
      ),
    );
  }

  ///box load
  Widget boxLoad({double? width, double? height}) {
    return Container(
      width: width ?? AppSize.screenWidth,
      height: height ?? 200.h,
      decoration: AppDecoration.decoration(
        radius: 5.r,
        shadow: false,
        color: AppColor.lightGray,
      ),
    );
  }
}
