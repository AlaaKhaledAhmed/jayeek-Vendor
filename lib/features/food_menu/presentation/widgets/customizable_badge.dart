import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';

class CustomizableBadge extends StatelessWidget {
  const CustomizableBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: AppDecoration.decoration(
          color: AppColor.subtextColor,
          radius: 16,
          shadow: false,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(12.r),
          ),
        ),
        child: AppText(
          text: AppMessage.customizable,
          color: AppColor.white,
          fontSize: AppSize.smallText,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
