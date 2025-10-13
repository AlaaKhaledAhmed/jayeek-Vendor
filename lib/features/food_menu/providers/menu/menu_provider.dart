import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayeek_vendor/core/di/locator_providers.dart';
import 'menu_notifier.dart';
import 'menu_state.dart';

final menuProvider = StateNotifierProvider<MenuNotifier, MenuState>((ref) {
  final repo = ref.read(foodDi);
  return MenuNotifier(repo);
});
