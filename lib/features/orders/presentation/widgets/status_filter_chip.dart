import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';

class StatusFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;

  const StatusFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        margin: EdgeInsets.only(left: 8.w),
        decoration: AppDecoration.decoration(
          color: isSelected ? AppColor.mainColor : AppColor.white,
          radius: 20.r,
          showBorder: !isSelected,
          borderColor: AppColor.borderColor,
          borderWidth: 1,
          shadow: false,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: label,
              fontSize: AppSize.smallText,
              fontWeight: isSelected ? AppThem().bold : AppThem().regular,
              color: isSelected ? AppColor.white : AppColor.textColor,
            ),
            if (count != null && count! > 0) ...[
              SizedBox(width: 6.w),
              Container(
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
