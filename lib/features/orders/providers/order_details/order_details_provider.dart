import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/locator_providers.dart';
import 'order_details_notifier.dart';
import 'order_details_state.dart';

final orderDetailsProvider =
    StateNotifierProvider.autoDispose<OrderDetailsNotifier, OrderDetailsState>(
  (ref) {
    final repo = ref.read(ordersDi);
    return OrderDetailsNotifier(repo);
  },
);
