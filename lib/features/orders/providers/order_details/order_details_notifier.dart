import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/model/data_handel.dart';
import '../../../../../core/util/print_info.dart';
import '../../data/models/order_model.dart';
import '../../domain/repositories/orders_repository.dart';
import 'order_details_state.dart';

class OrderDetailsNotifier extends StateNotifier<OrderDetailsState> {
  final OrdersRepository _repository;
  final TextEditingController estimatedTimeController = TextEditingController();
  final TextEditingController rejectionReasonController =
      TextEditingController();

  OrderDetailsNotifier(this._repository) : super(const OrderDetailsState());

  /// Load order details
  Future<void> loadOrderDetails(String orderId) async {
    state = state.copyWith(isLoading: true, hasError: false);

    final result = await _repository.getOrderDetails(orderId: orderId);

    if (!result.hasError && result.data != null) {
      state = state.copyWith(
        order: result.data,
        isLoading: false,
        hasError: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: result.message ?? 'حدث خطأ أثناء تحميل تفاصيل الطلب',
      );
    }
  }

  /// Update order status
  Future<PostDataHandle<bool>> updateStatus(OrderStatus newStatus) async {
    state = state.copyWith(isUpdating: true);

    final result = await _repository.updateOrderStatus(
      orderId: state.order!.id,
      newStatus: newStatus,
    );

    if (!result.hasError) {
      state = state.copyWith(
        order: state.order?.copyWith(status: newStatus),
        isUpdating: false,
      );
    } else {
      state = state.copyWith(isUpdating: false);
    }

    return result;
  }

  /// Accept order
  Future<PostDataHandle<bool>> acceptOrder() async {
    state = state.copyWith(isUpdating: true);

    final estimatedTime = int.tryParse(estimatedTimeController.text);

    final result = await _repository.acceptOrder(
      orderId: state.order!.id,
      estimatedTime: estimatedTime,
    );

    if (!result.hasError) {
      state = state.copyWith(
        order: state.order?.copyWith(status: OrderStatus.confirmed),
        isUpdating: false,
      );
    } else {
      state = state.copyWith(isUpdating: false);
    }

    return result;
  }

  /// Reject order
  Future<PostDataHandle<bool>> rejectOrder() async {
    state = state.copyWith(isUpdating: true);

    final result = await _repository.rejectOrder(
      orderId: state.order!.id,
      reason: rejectionReasonController.text.isEmpty
          ? null
          : rejectionReasonController.text,
    );

    if (!result.hasError) {
      state = state.copyWith(
        order: state.order?.copyWith(status: OrderStatus.cancelled),
        isUpdating: false,
      );
    } else {
      state = state.copyWith(isUpdating: false);
    }

    return result;
  }

  @override
  void dispose() {
    estimatedTimeController.dispose();
    rejectionReasonController.dispose();
    printInfo('OrderDetailsNotifier disposed');
    super.dispose();
  }
}
