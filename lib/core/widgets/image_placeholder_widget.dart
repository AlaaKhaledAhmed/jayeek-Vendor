import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_color.dart';
import 'app_decoration.dart';

/// Widget مشترك لعرض Placeholder للصور
/// يستخدم عندما لا تتوفر صورة أو فشل تحميلها
class ImagePlaceholderWidget extends StatelessWidget {
  final double width;
  final double height;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final double? radius;
  final bool showBorder;

  const ImagePlaceholderWidget({
    super.key,
    required this.width,
    required this.height,
    this.icon = Icons.restaurant_menu_rounded,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.radius,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.w,
      decoration: AppDecoration.decoration(
        color: backgroundColor ?? AppColor.backgroundColor,
        radius: radius ?? 10,
        showBorder: showBorder,
        borderColor: AppColor.borderColor.withOpacity(0.3),
        borderWidth: 1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor ?? AppColor.subGrayText.withOpacity(0.5),
            size: iconSize?.sp ?? 28.sp,
          ),
        ],
      ),
    );
  }
}
