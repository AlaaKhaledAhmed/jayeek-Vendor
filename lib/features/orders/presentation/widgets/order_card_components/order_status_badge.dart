import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_size.dart';
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: AppText(
        text: status.arabicLabel,
        fontSize: AppSize.captionText,
        fontWeight: AppThem().bold,
        color: color,
      ),
    );
  }
}
