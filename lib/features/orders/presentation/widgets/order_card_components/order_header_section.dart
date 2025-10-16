import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/order_model.dart';
import 'order_status_badge.dart';

/// مكون Header الطلب - يعرض رقم الطلب والوقت والحالة
class OrderHeaderSection extends StatelessWidget {
  final OrderModel order;
  final String formattedTime;

  const OrderHeaderSection({
    super.key,
    required this.order,
    required this.formattedTime,
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
              text: '#${order.orderNumber}',
              fontSize: AppSize.heading3,
              fontWeight: AppThem().bold,
              color: AppColor.mainColor,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14.sp,
                  color: AppColor.subGrayText,
                ),
                SizedBox(width: 4.w),
                AppText(
                  text: formattedTime,
                  fontSize: AppSize.captionText,
                  color: AppColor.subGrayText,
                ),
              ],
            ),
          ],
        ),
        OrderStatusBadge(status: order.status),
      ],
    );
  }
}
