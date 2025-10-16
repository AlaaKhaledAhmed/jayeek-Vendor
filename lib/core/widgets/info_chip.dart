import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_color.dart';
import 'app_decoration.dart';
import 'app_text.dart';

/// Widget مشترك لعرض معلومة في شكل Chip
/// يستخدم للعرض المدمج للمعلومات مثل الكمية، السعر، إلخ
class InfoChip extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final double? radius;
  final Gradient? gradient;
  final bool showBorder;
  final Color? borderColor;

  const InfoChip({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.radius,
    this.gradient,
    this.showBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 5.h,
          ),
      decoration: gradient != null
          ? BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(radius?.r ?? 8.r),
            )
          : AppDecoration.decoration(
              color: backgroundColor ?? AppColor.mainColor.withOpacity(0.1),
              radius: radius ?? 8,
              showBorder: showBorder,
              borderColor: borderColor ?? AppColor.borderColor,
              borderWidth: 1,
              shadow: false,
            ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12.sp,
              color: textColor ?? AppColor.mainColor,
            ),
            SizedBox(width: 4.w),
          ],
          AppText(
            text: text,
            fontSize: fontSize,
            fontWeight: fontWeight ?? FontWeight.bold,
            color: textColor ?? AppColor.mainColor,
          ),
        ],
      ),
    );
  }
}
