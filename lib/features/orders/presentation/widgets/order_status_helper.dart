import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../data/models/order_model.dart';

/// Helper class لمساعدة في معالجة حالات الطلبات
/// يحتوي على دوال مشتركة للألوان والأيقونات
class OrderStatusHelper {
  /// الحصول على لون الحالة
  static Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFF59E0B);
      case OrderStatus.confirmed:
        return const Color(0xFF0C5460);
      case OrderStatus.preparing:
        return const Color(0xFF6366F1);
      case OrderStatus.ready:
        return const Color(0xFF10B981);
      case OrderStatus.onTheWay:
        return const Color(0xFF3B82F6);
      case OrderStatus.delivered:
        return const Color(0xFF059669);
      case OrderStatus.cancelled:
        return const Color(0xFFEF4444);
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
