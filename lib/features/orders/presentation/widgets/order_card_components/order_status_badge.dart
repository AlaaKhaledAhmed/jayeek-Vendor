import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
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
    final icon = OrderStatusHelper.getStatusIcon(status);

    return Container(
      width: AppSize.scale(40.spMin),
      height: AppSize.scale(40.spMin),
      decoration: AppDecoration.decoration(
          radius: 8,
          showBorder: true,
          shadow: false,
          borderWidth: 1,
          borderColor: color,
          color: color.resolveOpacity(0.2)),
      child: Center(
        child: Icon(
          icon,
          size: AppSize.scale(22.spMin),
          color: color,
        ),
      ),
    );
  }
}
