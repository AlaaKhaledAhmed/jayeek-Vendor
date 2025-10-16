import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget مشترك لعرض Header مع Gradient Background عصري
/// قابل للاستخدام في أي صفحة تحتاج header عصري مع تدرجات جذابة
class GradientHeaderCard extends StatelessWidget {
  final Color primaryColor;
  final Color? secondaryColor;
  final double height;
  final Widget child;
  final BorderRadius? borderRadius;

  const GradientHeaderCard({
    super.key,
    required this.primaryColor,
    this.secondaryColor,
    required this.child,
    this.height = 140,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSecondaryColor = secondaryColor ?? primaryColor;

    return Container(
      height: height.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.15),
            effectiveSecondaryColor.withOpacity(0.08),
            Colors.white.withOpacity(0.95),
          ],
          stops: const [0.0, 0.5, 1.0],
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
