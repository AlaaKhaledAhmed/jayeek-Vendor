import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/order_model.dart';
import '../order_card_components/order_status_badge.dart';

/// بطاقة Header الطلب في صفحة التفاصيل
class OrderHeaderCard extends StatelessWidget {
  final OrderModel order;

  const OrderHeaderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppDecoration.decoration(
        color: AppColor.white,
        radius: 12.r,
        shadow: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: AppMessage.orderNumber,
                    fontSize: AppSize.captionText,
                    color: AppColor.subGrayText,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    text: '#${order.orderNumber}',
                    fontSize: AppSize.heading3,
                    fontWeight: AppThem().bold,
                    color: AppColor.mainColor,
                  ),
                ],
              ),
              OrderStatusBadge(status: order.status),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColor.borderColor),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 18.sp,
                color: AppColor.subGrayText,
              ),
              SizedBox(width: 8.w),
              AppText(
                text: DateFormat('dd/MM/yyyy - HH:mm', 'ar')
                    .format(order.createdAt),
                fontSize: AppSize.smallText,
                color: AppColor.subGrayText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
