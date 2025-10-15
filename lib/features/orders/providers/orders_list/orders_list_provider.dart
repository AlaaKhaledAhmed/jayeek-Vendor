import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/locator_providers.dart';
import 'orders_list_notifier.dart';
import 'orders_list_state.dart';

final ordersListProvider =
    StateNotifierProvider.autoDispose<OrdersListNotifier, OrdersListState>(
  (ref) {
    final repo = ref.read(ordersDi);
    return OrdersListNotifier(repo);
  },
);
