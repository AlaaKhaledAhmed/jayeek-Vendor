import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/menu_item_model.dart';
import '../../domain/repositories/food_repository.dart';
import 'menu_state.dart';

class MenuNotifier extends StateNotifier<MenuState> {
  final FoodRepository repository;

  MenuNotifier(this.repository)
    : super(
        const MenuState(
          items: [],
          isLoading: true,
          query: '',
          category: null,
          gridMode: false,
        ),
      ) {
    _loadMenu();
  }

  final categories = const <String>[
    'All',
    'Burgers',
    'Pasta',
    'Pizza',
    'Salads',
    'Desserts',
    'Drinks',
  ];

  Future<void> _loadMenu() async {
    state = state.copyWith(isLoading: true);
    try {
      final items = await repository.getMenuItems();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(items: [], isLoading: false);
    }
  }

  Future<void> refreshMenu() async {
    await _loadMenu();
  }

  void toggleGrid() => state = state.copyWith(gridMode: !state.gridMode);

  void setQuery(String q) => state = state.copyWith(query: q);

  void setCategory(String? cat) {
    if (cat == null || cat == 'All') {
      state = state.copyWith(category: '');
    } else {
      state = state.copyWith(category: cat);
    }
  }

  void toggleAvailability(String id) {
    final updated = state.items
        .map((e) {
          if (e.id == id) return e.copyWith(isAvailable: !e.isAvailable);
          return e;
        })
        .toList(growable: false);
    state = state.copyWith(items: updated);
  }

  void deleteItem(String id) {
    final updated = state.items
        .where((e) => e.id != id)
        .toList(growable: false);
    state = state.copyWith(items: updated);
  }

  void updateItem(MenuItemModel updatedItem) {
    final updated = state.items
        .map((e) => e.id == updatedItem.id ? updatedItem : e)
        .toList(growable: false);
    state = state.copyWith(items: updated);
  }

  void addItem(MenuItemModel newItem) {
    final updated = [...state.items, newItem];
    state = state.copyWith(items: updated);
  }
}
