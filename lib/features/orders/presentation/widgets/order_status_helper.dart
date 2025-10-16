import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../data/models/order_model.dart';

/// Helper class لمساعدة في معالجة حالات الطلبات
/// يحتوي على دوال مشتركة للألوان والأيقونات
class OrderStatusHelper {
  /// الحصول على لون الحالة - ألوان عصرية وجذابة
  static Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFFF6B6B); // أحمر كورالي عصري
      case OrderStatus.confirmed:
        return const Color(0xFF4ECDC4); // تركواز فاتح عصري
      case OrderStatus.preparing:
        return const Color(0xFF95E1D3); // أخضر نعناعي فاتح
      case OrderStatus.ready:
        return const Color(0xFF38F9D7); // سيان مشرق
      case OrderStatus.onTheWay:
        return const Color(0xFFFECA57); // أصفر ذهبي دافئ
      case OrderStatus.delivered:
        return const Color(0xFF10B981); // أخضر نجاح
      case OrderStatus.cancelled:
        return const Color(0xFFEE5A6F); // أحمر وردي ناعم
    }
  }

  /// الحصول على اللون الثانوي للتدرج
  static Color getStatusSecondaryColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFFF8E53); // برتقالي دافئ
      case OrderStatus.confirmed:
        return const Color(0xFF45B7D1); // أزرق سماوي
      case OrderStatus.preparing:
        return const Color(0xFFA8E6CF); // أخضر فاتح جداً
      case OrderStatus.ready:
        return const Color(0xFF16F4D0); // تركواز لامع
      case OrderStatus.onTheWay:
        return const Color(0xFFFFA502); // برتقالي مشمشي
      case OrderStatus.delivered:
        return const Color(0xFF059669); // أخضر داكن
      case OrderStatus.cancelled:
        return const Color(0xFFFF6B9D); // وردي فاتح
    }
  }

  /// الحصول على أيقونة الحالة
  static IconData getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppIcons.pendingOrder;
      case OrderStatus.confirmed:
        return AppIcons.confirmedOrder;
      case OrderStatus.preparing:
        return AppIcons.preparingOrder;
      case OrderStatus.ready:
        return AppIcons.readyOrder;
      case OrderStatus.onTheWay:
        return AppIcons.onTheWayOrder;
      case OrderStatus.delivered:
        return AppIcons.deliveredOrder;
      case OrderStatus.cancelled:
        return AppIcons.cancelledOrder;
    }
  }
}
