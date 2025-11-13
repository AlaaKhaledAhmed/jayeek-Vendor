import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayeek_vendor/core/di/locator_providers.dart';
import 'update_item_notifier.dart';
import 'update_item_state.dart';

final updateItemProvider =
    StateNotifierProvider.family<UpdateItemNotifier, UpdateItemState, int>(
  (ref, itemId) {
    final repo = ref.read(foodDi);
    return UpdateItemNotifier(repo, itemId);
  },
);
