import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../data/models/order_model.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: AppDecoration.decoration(
          color: AppColor.white,
          radius: 12.r,
          shadow: true,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Order Number and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text:
                            '${AppMessage.orderNumber}: #${order.orderNumber}',
                        fontSize: AppSize.normalText,
                        fontWeight: AppThem().bold,
                        color: AppColor.textColor,
                      ),
                      SizedBox(height: 4.h),
                      AppText(
                        text: _formatTime(order.createdAt),
                        fontSize: AppSize.captionText,
                        color: AppColor.subGrayText,
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(order.status),
              ],
            ),

            SizedBox(height: 12.h),

            // Customer Info
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 18.sp,
                  color: AppColor.subGrayText,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AppText(
                    text: order.customerName,
                    fontSize: AppSize.smallText,
                    color: AppColor.textColor,
                  ),
                ),
              ],
            ),

            if (order.customerAddress != null) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18.sp,
                    color: AppColor.subGrayText,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: AppText(
                      text: order.customerAddress!,
                      fontSize: AppSize.captionText,
                      color: AppColor.subGrayText,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 12.h),

            // Order Summary
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: AppDecoration.decoration(
                color: AppColor.backgroundColor,
                radius: 8.r,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 18.sp,
                        color: AppColor.mainColor,
                      ),
                      SizedBox(width: 8.w),
                      AppText(
                        text:
                            '${order.items.length} ${order.items.length > 1 ? AppMessage.items : AppMessage.item}',
                        fontSize: AppSize.smallText,
                        color: AppColor.textColor,
                      ),
                    ],
                  ),
                  AppText(
                    text: '${order.total.toStringAsFixed(2)} ${AppMessage.sar}',
                    fontSize: AppSize.normalText,
                    fontWeight: AppThem().bold,
                    color: AppColor.mainColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case OrderStatus.pending:
        backgroundColor = const Color(0xFFFFF3CD);
        textColor = const Color(0xFFF59E0B);
        break;
      case OrderStatus.confirmed:
        backgroundColor = const Color(0xFFD1ECF1);
        textColor = const Color(0xFF0C5460);
        break;
      case OrderStatus.preparing:
        backgroundColor = const Color(0xFFE7E5FF);
        textColor = const Color(0xFF6366F1);
        break;
      case OrderStatus.ready:
        backgroundColor = const Color(0xFFD1F4E0);
        textColor = const Color(0xFF10B981);
        break;
      case OrderStatus.onTheWay:
        backgroundColor = const Color(0xFFDCEDFF);
        textColor = const Color(0xFF3B82F6);
        break;
      case OrderStatus.delivered:
        backgroundColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF059669);
        break;
      case OrderStatus.cancelled:
        backgroundColor = const Color(0xFFFEE);
        textColor = const Color(0xFFEF4444);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: AppDecoration.decoration(
        color: backgroundColor,
        radius: 20.r,
      ),
      child: AppText(
        text: status.arabicLabel,
        fontSize: AppSize.captionText,
        fontWeight: AppThem().bold,
        color: textColor,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} ${AppMessage.minutes}';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm', 'ar').format(dateTime);
    }
  }
}
