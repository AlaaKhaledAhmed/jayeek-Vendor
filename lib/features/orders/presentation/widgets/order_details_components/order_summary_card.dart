import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/order_model.dart';

/// بطاقة ملخص الطلب - الأسعار وطريقة الدفع
class OrderSummaryCard extends StatelessWidget {
  final OrderModel order;

  const OrderSummaryCard({
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
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            AppMessage.subtotal,
            '${order.subtotal.toStringAsFixed(2)} ${AppMessage.sar}',
            false,
          ),
          SizedBox(height: 8.h),
          _buildSummaryRow(
            AppMessage.deliveryFee,
            '${order.deliveryFee.toStringAsFixed(2)} ${AppMessage.sar}',
            false,
          ),
          SizedBox(height: 12.h),
          const Divider(),
          SizedBox(height: 12.h),
          _buildSummaryRow(
            AppMessage.orderTotal,
            '${order.total.toStringAsFixed(2)} ${AppMessage.sar}',
            true,
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
            decoration: AppDecoration.decoration(
              shadow: false,
              color: order.isPaid
                  ? AppColor.green.withOpacity(0.1)
                  : AppColor.amber.withOpacity(0.1),
              radius: 8.r,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: AppMessage.paymentMethod,
                  fontSize: AppSize.smallText,
                  color: AppColor.textColor,
                ),
                AppText(
                  text: order.paymentMethod ?? 'كاش',
                  fontSize: AppSize.smallText,
                  fontWeight: AppThem().bold,
                  color: AppColor.textColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isBold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: label,
          fontSize: isBold ? AppSize.normalText : AppSize.smallText,
          fontWeight: isBold ? AppThem().bold : AppThem().regular,
          color: AppColor.textColor,
        ),
        AppText(
          text: value,
          fontSize: isBold ? AppSize.heading3 : AppSize.smallText,
          fontWeight: isBold ? AppThem().bold : AppThem().regular,
          color: isBold ? AppColor.mainColor : AppColor.textColor,
        ),
      ],
    );
  }
}
