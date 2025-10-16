import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_color.dart';
import '../constants/app_size.dart';
import '../theme/app_them.dart';
import 'app_decoration.dart';
import 'app_text.dart';

/// Widget مشترك للفلترة مع أيقونة ونص
/// يمكن استخدامه في صفحة الطلبات وصفحة قائمة الطعام
class FilterChipWithIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Color? selectedIconColor;
  final Color? unselectedIconColor;
  final bool showShadow;
  final double? borderRadius;
  final bool showIcon;
  final bool showLabel;

  const FilterChipWithIcon({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.count,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.showShadow = true,
    this.borderRadius,
    this.showIcon = true,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedColor = selectedColor ?? AppColor.subtextColor;
    final effectiveUnselectedColor = unselectedColor ?? AppColor.white;
    final effectiveSelectedTextColor = selectedTextColor ?? AppColor.white;
    final effectiveUnselectedTextColor =
        unselectedTextColor ?? AppColor.textColor;
    final effectiveSelectedIconColor = selectedIconColor ?? AppColor.white;
    final effectiveUnselectedIconColor =
        unselectedIconColor ?? AppColor.subtextColor;
    final effectiveBorderRadius = borderRadius ?? 30;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        margin: EdgeInsets.only(left: 8.w),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    effectiveSelectedColor,
                    effectiveSelectedColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : effectiveUnselectedColor,
          borderRadius: BorderRadius.circular(effectiveBorderRadius.r),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColor.borderColor.withOpacity(0.3),
            width: isSelected ? 0 : 1.5,
          ),
          boxShadow: isSelected && showShadow
              ? [
                  BoxShadow(
                    color: effectiveSelectedColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الأيقونة مع Animation عصري
            if (showIcon) ...[
              AnimatedScale(
                scale: isSelected ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.elasticOut,
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: isSelected
                      ? effectiveSelectedIconColor
                      : effectiveUnselectedIconColor,
                ),
              ),
              if (showLabel) SizedBox(width: 10.w),
            ],

            // النص مع خط أوضح
            if (showLabel)
              AppText(
                text: label,
                color: isSelected
                    ? effectiveSelectedTextColor
                    : effectiveUnselectedTextColor,
                fontSize: 13.sp,
                fontWeight: isSelected ? AppThem().bold : FontWeight.w600,
              ),

            // العداد (اختياري)
            if (count != null && count! > 0) ...[
              SizedBox(width: 6.w),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: AppDecoration.decoration(
                  color: isSelected ? AppColor.white : AppColor.mainColor,
                  radius: 10.r,
                ),
                child: AppText(
                  text: count.toString(),
                  fontSize: AppSize.captionText,
                  fontWeight: AppThem().bold,
                  color: isSelected ? AppColor.mainColor : AppColor.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
