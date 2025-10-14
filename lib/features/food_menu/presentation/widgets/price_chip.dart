import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';

class PriceChip extends StatelessWidget {
  final double price;

  const PriceChip({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: AppDecoration.decoration(
        color: AppColor.white,
        radius: 24,
        shadow: false,
      ),
      child: AppText(
        text: '${price.toStringAsFixed(2)} ${AppMessage.sar}',
        color: AppColor.mainColor,
        fontSize: AppSize.smallText,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
