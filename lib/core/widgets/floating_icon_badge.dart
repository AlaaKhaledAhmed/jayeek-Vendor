import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_color.dart';

/// Widget لعرض أيقونة عائمة مع ظل وخلفية
/// يستخدم في البطاقات لعرض الحالة أو المعلومات الهامة
class FloatingIconBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final double size;
  final double iconSize;

  const FloatingIconBadge({
    super.key,
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
    this.size = 36,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: iconSize.sp,
        color: iconColor,
      ),
    );
  }
}
