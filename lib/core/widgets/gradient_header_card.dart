import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget مشترك لعرض Header مع Gradient Background
/// قابل للاستخدام في أي صفحة تحتاج header عصري
class GradientHeaderCard extends StatelessWidget {
  final Color primaryColor;
  final double height;
  final Widget child;
  final BorderRadius? borderRadius;

  const GradientHeaderCard({
    super.key,
    required this.primaryColor,
    required this.child,
    this.height = 140,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: borderRadius ??
            BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
      ),
      child: child,
    );
  }
}
