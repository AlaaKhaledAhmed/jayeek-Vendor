import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/widgets/app_text.dart';

/// عنوان قسم في صفحة البروفايل
class ProfileSectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;

  const ProfileSectionTitle({
    super.key,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.horizontalPadding,
        vertical: 12.h,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20.sp,
              color: AppColor.mainColor,
            ),
            SizedBox(width: 8.w),
          ],
          AppText(
            text: title,
            fontSize: AppSize.normalText,
            fontWeight: AppThem().bold,
            color: AppColor.textColor,
          ),
        ],
      ),
    );
  }
}
