import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/widgets/app_decoration.dart';
import '../../../../core/widgets/app_text.dart';

/// بطاقة إجراء/خيار في البروفايل
class ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool showArrow;
  final Widget? trailing;

  const ProfileActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.showArrow = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: AppDecoration.decoration(
          color: backgroundColor,
          showBorder: true,
          borderColor: AppColor.borderColor,
          shadow: false,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColor.mainColor).resolveOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 22.sp,
                color: iconColor ?? AppColor.mainColor,
              ),
            ),

            SizedBox(width: 16.w),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    fontSize: AppSize.normalText,
                    fontWeight: AppThem().bold,
                    color: AppColor.textColor,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    AppText(
                      text: subtitle!,
                      fontSize: AppSize.captionText,
                      color: AppColor.subGrayText,
                    ),
                  ],
                ],
              ),
            ),

            // Trailing Widget or Arrow
            if (trailing != null)
              trailing!
            else if (showArrow)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
                color: AppColor.subGrayText,
              ),
          ],
        ),
      ),
    );
  }
}
