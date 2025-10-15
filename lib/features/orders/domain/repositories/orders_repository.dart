import '../../../../../core/model/data_handel.dart';
import '../../data/models/order_model.dart';

abstract interface class OrdersRepository {
  /// Get all orders with optional status filter
  Future<PostDataHandle<List<OrderModel>>> getOrders({
    OrderStatus? status,
    int page = 1,
  });

  /// Get order details by ID
  Future<PostDataHandle<OrderModel>> getOrderDetails({
    required String orderId,
  });

  /// Update order status
  Future<PostDataHandle<bool>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  });

  /// Accept order
  Future<PostDataHandle<bool>> acceptOrder({
    required String orderId,
    int? estimatedTime, // in minutes
  });

  /// Reject/Cancel order
  Future<PostDataHandle<bool>> rejectOrder({
    required String orderId,
    String? reason,
  });
}
