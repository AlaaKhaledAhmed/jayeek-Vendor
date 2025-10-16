import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_color.dart';

/// Widget لعرض أيقونة عائمة عصرية مع ظل وتدرج لوني
/// يستخدم في البطاقات لعرض الحالة أو المعلومات الهامة
class FloatingIconBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final double size;
  final double iconSize;
  final bool showGradient;

  const FloatingIconBadge({
    super.key,
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
    this.size = 42,
    this.iconSize = 22,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        gradient: showGradient
            ? LinearGradient(
                colors: [
                  Colors.white,
                  iconColor.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: showGradient ? null : (backgroundColor ?? AppColor.white),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: iconColor.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize.sp,
          color: iconColor,
        ),
      ),
    );
  }
}
