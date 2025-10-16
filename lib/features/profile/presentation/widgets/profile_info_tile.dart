import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/widgets/app_decoration.dart';
import '../../../../core/widgets/app_text.dart';

/// بطاقة معلومة واحدة في البروفايل
class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool showArrow;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    this.iconColor,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: AppDecoration.decoration(
          showBorder: true,
          borderColor: AppColor.borderColor,
          shadow: false,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColor.mainColor).resolveOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 24.sp,
                color: iconColor ?? AppColor.mainColor,
              ),
            ),

            SizedBox(width: 16.w),

            // Title & Value
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    fontSize: AppSize.captionText,
                    color: AppColor.subGrayText,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    text: value,
                    fontSize: AppSize.normalText,
                    fontWeight: AppThem().bold,
                    color: AppColor.textColor,
                  ),
                ],
              ),
            ),

            // Arrow
            if (showArrow)
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
