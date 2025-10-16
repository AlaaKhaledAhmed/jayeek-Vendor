import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/order_model.dart';
import '../order_status_helper.dart';

/// Badge الحالة - يعرض حالة الطلب بشكل مرئي
class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = OrderStatusHelper.getStatusColor(status);
    final secondaryColor = OrderStatusHelper.getStatusSecondaryColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            secondaryColor.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          AppText(
            text: status.arabicLabel,
            fontSize: 12.sp,
            fontWeight: AppThem().bold,
            color: color,
          ),
        ],
      ),
    );
  }
}
