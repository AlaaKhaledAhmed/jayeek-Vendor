import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: AppDecoration.decoration(
          color: selected ? AppColor.subtextColor : AppColor.white,
          radius: 25,
          shadow: selected,
          shadowOpacity: 0.2,
          showBorder: !selected,
          borderColor: AppColor.lightGray,
          borderWidth: 1.5,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: selected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: AppSize.mediumIconSize,
                color: selected ? AppColor.white : AppColor.subtextColor,
              ),
            ),
            SizedBox(width: 8.w),
            AppText(
              text: label,
              color: selected ? AppColor.white : AppColor.textColor,
              fontSize: AppSize.captionText,
              fontWeight: selected ? FontWeight.bold : FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
