import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/order_model.dart';

/// Footer الطلب - يعرض الإجمالي وزر العمل
class OrderTotalActionFooter extends StatelessWidget {
  final OrderModel order;

  const OrderTotalActionFooter({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: AppMessage.orderTotal,
              fontSize: AppSize.captionText,
              color: AppColor.subGrayText,
            ),
            SizedBox(height: 2.h),
            AppText(
              text: '${order.total.toStringAsFixed(2)} ${AppMessage.sar}',
              fontSize: AppSize.bodyText,
              fontWeight: AppThem().bold,
              color: AppColor.mainColor,
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: AppColor.mainColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: 'عرض التفاصيل',
                fontSize: AppSize.captionText,
                fontWeight: FontWeight.w600,
                color: AppColor.white,
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.arrow_back_ios_rounded,
                size: 12.sp,
                color: AppColor.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
