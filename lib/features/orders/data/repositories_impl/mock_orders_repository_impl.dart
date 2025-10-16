import '../../../../../core/model/data_handel.dart';
import '../../domain/repositories/orders_repository.dart';
import '../mock/mock_orders_data.dart';
import '../models/order_model.dart';

/// Mock implementation of OrdersRepository for testing and development
/// This allows working with mock data without requiring a backend connection
class MockOrdersRepositoryImpl implements OrdersRepository {
  // Local copy of orders that can be modified
  final List<OrderModel> _orders = List.from(MockOrdersData.mockOrders);

  @override
  Future<PostDataHandle<List<OrderModel>>> getOrders({
    OrderStatus? status,
    int page = 1,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Filter by status if provided
      var filteredOrders = status != null
          ? _orders.where((order) => order.status == status).toList()
          : _orders;

      // Sort by creation date (newest first)
      filteredOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Implement pagination
      const pageSize = 10;
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      if (startIndex >= filteredOrders.length) {
        return PostDataHandle<List<OrderModel>>(
          data: [],
          hasError: false,
          message: 'تم تحميل الطلبات بنجاح',
        );
      }

      final paginatedOrders = filteredOrders.sublist(
        startIndex,
        endIndex > filteredOrders.length ? filteredOrders.length : endIndex,
      );

      return PostDataHandle<List<OrderModel>>(
        data: paginatedOrders,
        hasError: false,
        message: 'تم تحميل الطلبات بنجاح',
      );
    } catch (e) {
      return PostDataHandle<List<OrderModel>>(
        data: [],
        hasError: true,
        message: 'حدث خطأ أثناء تحميل الطلبات',
      );
    }
  }

  @override
  Future<PostDataHandle<OrderModel>> getOrderDetails({
    required String orderId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final order = _orders.firstWhere(
        (order) => order.id == orderId,
        orElse: () => throw Exception('الطلب غير موجود'),
      );

      return PostDataHandle<OrderModel>(
        data: order,
        hasError: false,
        message: 'تم تحميل تفاصيل الطلب بنجاح',
      );
    } catch (e) {
      return PostDataHandle<OrderModel>(
        data: null,
        hasError: true,
        message: 'لم يتم العثور على الطلب',
      );
    }
  }

  @override
  Future<PostDataHandle<bool>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final orderIndex = _orders.indexWhere((order) => order.id == orderId);

      if (orderIndex == -1) {
        return PostDataHandle<bool>(
          data: false,
          hasError: true,
          message: 'الطلب غير موجود',
        );
      }

      // Update the order status
      _orders[orderIndex] = _orders[orderIndex].copyWith(status: newStatus);

      return PostDataHandle<bool>(
        data: true,
        hasError: false,
        message: 'تم تحديث حالة الطلب بنجاح',
      );
    } catch (e) {
      return PostDataHandle<bool>(
        data: false,
        hasError: true,
        message: 'حدث خطأ أثناء تحديث حالة الطلب',
      );
    }
  }

  @override
  Future<PostDataHandle<bool>> acceptOrder({
    required String orderId,
    int? estimatedTime,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final orderIndex = _orders.indexWhere((order) => order.id == orderId);

      if (orderIndex == -1) {
        return PostDataHandle<bool>(
          data: false,
          hasError: true,
          message: 'الطلب غير موجود',
        );
      }

      // Calculate estimated delivery time
      DateTime? estimatedDeliveryTime;
      if (estimatedTime != null) {
        estimatedDeliveryTime = DateTime.now().add(
          Duration(minutes: estimatedTime),
        );
      }

      // Update the order
      _orders[orderIndex] = _orders[orderIndex].copyWith(
        status: OrderStatus.confirmed,
        estimatedDeliveryTime: estimatedDeliveryTime,
      );

      return PostDataHandle<bool>(
        data: true,
        hasError: false,
        message: 'تم قبول الطلب بنجاح',
      );
    } catch (e) {
      return PostDataHandle<bool>(
        data: false,
        hasError: true,
        message: 'حدث خطأ أثناء قبول الطلب',
      );
    }
  }

  @override
  Future<PostDataHandle<bool>> rejectOrder({
    required String orderId,
    String? reason,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final orderIndex = _orders.indexWhere((order) => order.id == orderId);

      if (orderIndex == -1) {
        return PostDataHandle<bool>(
          data: false,
          hasError: true,
          message: 'الطلب غير موجود',
        );
      }

      // Update the order with rejection
      String notes = _orders[orderIndex].notes ?? '';
      if (reason != null && reason.isNotEmpty) {
        notes =
            notes.isEmpty ? 'سبب الرفض: $reason' : '$notes\nسبب الرفض: $reason';
      }

      _orders[orderIndex] = _orders[orderIndex].copyWith(
        status: OrderStatus.cancelled,
        notes: notes,
      );

      return PostDataHandle<bool>(
        data: true,
        hasError: false,
        message: 'تم رفض الطلب بنجاح',
      );
    } catch (e) {
      return PostDataHandle<bool>(
        data: false,
        hasError: true,
        message: 'حدث خطأ أثناء رفض الطلب',
      );
    }
  }

  /// Helper method to reset orders to original mock data
  void resetOrders() {
    _orders.clear();
    _orders.addAll(MockOrdersData.mockOrders);
  }

  /// Helper method to add a new mock order
  void addOrder(OrderModel order) {
    _orders.add(order);
  }

  /// Helper method to remove an order
  void removeOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
  }
}
