import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayeek_vendor/core/di/locator_providers.dart';
import 'add_item_notifier.dart';
import 'add_item_state.dart';

final addItemProvider = StateNotifierProvider.autoDispose<AddItemNotifier, AddItemState>((
  ref,
) {
  final repo = ref.read(foodDi);

  return AddItemNotifier(repo);
});
