import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_text.dart';

/// Header صف المنتج - الاسم وbadge الكمية
class ItemHeaderRow extends StatelessWidget {
  final String itemName;
  final int quantity;

  const ItemHeaderRow({
    super.key,
    required this.itemName,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText(
            text: itemName,
            fontSize: AppSize.bodyText,
            fontWeight: AppThem().bold,
            color: AppColor.textColor,
            maxLine: 2,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 5.h,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.mainColor,
                AppColor.mainColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.close_rounded,
                size: 12.sp,
                color: AppColor.white,
              ),
              AppText(
                text: '$quantity',
                fontSize: AppSize.smallText,
                fontWeight: AppThem().bold,
                color: AppColor.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
