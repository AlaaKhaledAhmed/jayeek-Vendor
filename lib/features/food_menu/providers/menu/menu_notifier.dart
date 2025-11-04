import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayeek_vendor/core/constants/app_flow_sate.dart';
import 'package:jayeek_vendor/features/food_menu/domain/models/food_category_model.dart';
import 'package:jayeek_vendor/features/food_menu/domain/models/menu_item_model.dart';
import 'package:jayeek_vendor/features/food_menu/domain/models/menu_items_response.dart';
import '../../domain/repositories/food_repository.dart';
import 'menu_state.dart';

class MenuNotifier extends StateNotifier<MenuState> {
  final FoodRepository repository;

  MenuNotifier(this.repository)
      : super(
          const MenuState(),
        ) {
    _loadCategories();
  }

  /// Load categories first, then load items based on first category
  Future<void> _loadCategories() async {
    state = state.copyWith(
      categories: state.categories.copyWith(
        result: AppFlowState.loading,
      ),
    );

    final apiResponse = await repository.getFoodCategories();

    ///if success
    if (!apiResponse.hasError && apiResponse.data != null) {
      ///save changed data
      state = state.copyWith(
        categories: state.categories.copyWith(
          result: AppFlowState.loaded,
          data: apiResponse.data,
        ),
      );

      // Load items for the first category (or "All" if no categories)
      final categories = apiResponse.data!.data ?? [];
      if (categories.isNotEmpty) {
        final firstCategory = categories.firstWhere(
          (cat) => cat.deleteFlag != true,
          orElse: () => categories.first,
        );
        if (firstCategory.id != null) {
          await _loadMenuItemsByCategoryId(firstCategory.id!);
        }
      }
    }

    ///error response
    else {
      state = state.copyWith(
        categories: state.categories.copyWith(
          result: apiResponse.message ?? AppFlowState.error,
          data: const FoodCategoriesResponse(),
        ),
      );
      // Don't load items if categories failed
    }
  }

  /// Load menu items by category id
  Future<void> _loadMenuItemsByCategoryId(int categoryId) async {
    state = state.copyWith(
      items: state.items.copyWith(
        result: AppFlowState.loading,
      ),
      selectedCategoryId: categoryId,
    );

    final apiResponse = await repository.getMenuItemsByCategoryId(categoryId);

    ///if success
    if (!apiResponse.hasError) {
      state = state.copyWith(
        items: state.items.copyWith(
          result: AppFlowState.loaded,
          data: apiResponse.data,
        ),
      );
    }

    ///error response
    else {
      state = state.copyWith(
        items: state.items.copyWith(
          result: apiResponse.message ?? AppFlowState.error,
          data: const MenuItemsResponse(),
        ),
      );
    }
  }

  Future<void> refreshMenu() async {
    await _loadCategories();
  }

  void toggleGrid() =>
      state = state.copyWith(gridMode: !(state.gridMode ?? false));

  void setQuery(String q) => state = state.copyWith(query: q);

  void setCategory(String? cat) {
    if (cat == null || cat == 'All') {
      state = state.copyWith(category: '');
      // Load items for first category when "All" is selected
      final categories = state.categories.data?.data ?? [];
      if (categories.isNotEmpty) {
        final firstCategory = categories.firstWhere(
          (c) => c.deleteFlag != true,
          orElse: () => categories.first,
        );
        if (firstCategory.id != null) {
          _loadMenuItemsByCategoryId(firstCategory.id!);
        }
      }
    } else {
      state = state.copyWith(category: cat);
      // Find category by name and load items
      final categories = state.categories.data?.data ?? [];
      final selectedCategory = categories.firstWhere(
        (c) => c.name == cat && c.deleteFlag != true,
        orElse: () => categories.first,
      );
      if (selectedCategory.id != null) {
        _loadMenuItemsByCategoryId(selectedCategory.id!);
      }
    }
  }

  void toggleAvailability(String id) {
    final currentItems = state.items.data?.data ?? [];
    final updated = currentItems.map((e) {
      if (e.id == id) return e.copyWith(isAvailable: !e.isAvailable);
      return e;
    }).toList(growable: false);
    state = state.copyWith(
      items: state.items.copyWith(
        data: state.items.data?.copyWith(data: updated),
      ),
    );
  }

  Future<void> deleteItem(String id) async {
    try {
      // Call API to delete item from server
      await repository.deleteMenuItem(id);

      // Update local state after successful deletion
      final currentItems = state.items.data?.data ?? [];
      final updated =
          currentItems.where((e) => e.id != id).toList(growable: false);
      state = state.copyWith(
        items: state.items.copyWith(
          data: state.items.data?.copyWith(data: updated),
        ),
      );
    } catch (e) {
      // Handle error - refresh the menu to get the latest state
      await refreshMenu();
    }
  }

  void updateItem(MenuItemModel updatedItem) {
    final currentItems = state.items.data?.data ?? [];
    final updated = currentItems
        .map((e) => e.id == updatedItem.id ? updatedItem : e)
        .toList(growable: false);
    state = state.copyWith(
      items: state.items.copyWith(
        data: state.items.data?.copyWith(data: updated),
      ),
    );
  }

  void addItem(MenuItemModel newItem) {
    final currentItems = state.items.data?.data ?? [];
    final updated = [...currentItems, newItem];
    state = state.copyWith(
      items: state.items.copyWith(
        data: state.items.data?.copyWith(data: updated),
      ),
    );
  }
}
