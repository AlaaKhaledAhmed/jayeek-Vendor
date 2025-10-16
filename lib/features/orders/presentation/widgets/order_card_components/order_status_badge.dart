import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/order_model.dart';
import '../order_status_helper.dart';

/// Badge الحالة - يعرض أيقونة حالة الطلب فقط
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
    final icon = OrderStatusHelper.getStatusIcon(status);

    return Container(
      width: 38.w,
      height: 38.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            secondaryColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.3),
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
      child: Center(
        child: Icon(
          icon,
          size: 18.sp,
          color: color,
        ),
      ),
    );
  }
}
