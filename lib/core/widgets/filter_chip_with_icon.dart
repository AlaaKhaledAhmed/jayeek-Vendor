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
    final effectiveBorderRadius = borderRadius ?? 25;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        margin: EdgeInsets.only(left: 8.w),
        decoration: AppDecoration.decoration(
          color: isSelected ? effectiveSelectedColor : effectiveUnselectedColor,
          radius: effectiveBorderRadius,
          shadow: isSelected && showShadow,
          shadowOpacity: 0.2,
          showBorder: !isSelected,
          borderColor: AppColor.borderColor,
          borderWidth: 1.5,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الأيقونة مع Animation
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: AppSize.mediumIconSize,
                color: isSelected
                    ? effectiveSelectedIconColor
                    : effectiveUnselectedIconColor,
              ),
            ),
            SizedBox(width: 8.w),

            // النص
            AppText(
              text: label,
              color: isSelected
                  ? effectiveSelectedTextColor
                  : effectiveUnselectedTextColor,
              fontSize: AppSize.captionText,
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
