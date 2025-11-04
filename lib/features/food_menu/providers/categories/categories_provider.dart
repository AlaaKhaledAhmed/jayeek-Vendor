import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/locator_providers.dart';
import 'categories_notifier.dart';
import 'categories_state.dart';

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, CategoriesState>((ref) {
  final repository = ref.watch(foodDi);
  return CategoriesNotifier(repository);
});
