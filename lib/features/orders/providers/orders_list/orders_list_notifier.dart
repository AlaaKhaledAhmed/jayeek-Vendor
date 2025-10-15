import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/util/print_info.dart';
import '../../data/models/order_model.dart';
import '../../domain/repositories/orders_repository.dart';
import 'orders_list_state.dart';

class OrdersListNotifier extends StateNotifier<OrdersListState> {
  final OrdersRepository _repository;

  OrdersListNotifier(this._repository) : super(const OrdersListState());

  /// Load orders with optional status filter
  Future<void> loadOrders({OrderStatus? status, bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(isRefreshing: true, currentPage: 1);
    } else {
      state = state.copyWith(isLoading: true);
    }

    final result = await _repository.getOrders(
      status: status,
      page: refresh ? 1 : state.currentPage,
    );

    if (!result.hasError && result.data != null) {
      final newOrders = result.data!;
      state = state.copyWith(
        orders: refresh ? newOrders : [...state.orders, ...newOrders],
        isLoading: false,
        isRefreshing: false,
        hasError: false,
        errorMessage: null,
        hasMore: newOrders.isNotEmpty,
        currentPage: refresh ? 2 : state.currentPage + 1,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        hasError: true,
        errorMessage: result.message ?? 'حدث خطأ أثناء تحميل الطلبات',
      );
    }
  }

  /// Filter orders by status
  void filterByStatus(OrderStatus? status) {
    state = state.copyWith(
      selectedStatus: status,
      orders: [],
      currentPage: 1,
      clearStatus: status == null,
    );
    loadOrders(status: status);
  }

  /// Load more orders (pagination)
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    await loadOrders(status: state.selectedStatus);
  }

  /// Refresh orders
  Future<void> refresh() async {
    await loadOrders(status: state.selectedStatus, refresh: true);
  }

  /// Update order status locally after update
  void updateOrderLocally(String orderId, OrderStatus newStatus) {
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(status: newStatus);
      }
      return order;
    }).toList();

    state = state.copyWith(orders: updatedOrders);
  }

  /// Remove order from list (after rejection)
  void removeOrder(String orderId) {
    final updatedOrders =
        state.orders.where((order) => order.id != orderId).toList();
    state = state.copyWith(orders: updatedOrders);
  }

  @override
  void dispose() {
    printInfo('OrdersListNotifier disposed');
    super.dispose();
  }
}
