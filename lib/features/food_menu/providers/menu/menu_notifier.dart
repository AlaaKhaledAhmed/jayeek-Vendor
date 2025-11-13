import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayeek_vendor/core/constants/app_flow_sate.dart';
import 'package:jayeek_vendor/core/services/shared_preferences_service.dart';
import 'package:jayeek_vendor/features/food_menu/domain/models/food_category_model.dart';
import 'package:jayeek_vendor/features/food_menu/domain/models/menu_item_model.dart';
import '../../domain/repositories/food_repository.dart';
import 'menu_state.dart';

class MenuNotifier extends StateNotifier<MenuState> {
  final FoodRepository repository;

  MenuNotifier(this.repository)
      : super(
          const MenuState(),
        ) {
    _loadInitialData();
  }

  /// Load categories with items using the new unified API
  Future<void> _loadInitialData() async {
    state = state.copyWith(
      categoriesWithItems: state.categoriesWithItems.copyWith(
        result: AppFlowState.loading,
      ),
    );

    // Get branchId from SharedPreferences
    final branchId = await SharedPreferencesService.getBranchId();

    if (branchId == null) {
      state = state.copyWith(
        categoriesWithItems: state.categoriesWithItems.copyWith(
          result: 'Branch ID not found',
        ),
      );
      return;
    }

    final apiResponse =
        await repository.getCategoriesWithItemsByBranch(branchId);

    if (!apiResponse.hasError && apiResponse.data != null) {
      // Update items with category names
      final categoriesWithUpdatedItems =
          apiResponse.data!.data?.map((category) {
        if (category.items == null || category.items!.isEmpty) {
          return category;
        }

        // Add category name to each item
        final updatedItems = category.items!.map((item) {
          return item.copyWith(
            categoryName: category.name,
            categoryNameAr: category.nameAr,
          );
        }).toList();

        return category.copyWith(items: updatedItems);
      }).toList();

      state = state.copyWith(
        categoriesWithItems: state.categoriesWithItems.copyWith(
          result: AppFlowState.loaded,
          data: apiResponse.data!.copyWith(data: categoriesWithUpdatedItems),
        ),
      );
    } else {
      state = state.copyWith(
        categoriesWithItems: state.categoriesWithItems.copyWith(
          result: apiResponse.message ?? AppFlowState.error,
          data: const FoodCategoriesResponse(),
        ),
      );
    }
  }

  Future<void> refreshMenu() async {
    await _loadInitialData();
  }

  void toggleGrid() =>
      state = state.copyWith(gridMode: !(state.gridMode ?? false));

  void setQuery(String q) => state = state.copyWith(query: q);

  void setCategory(int? categoryId) {
    if (categoryId == null) {
      state = state.copyWith(clearCategoryId: true);
    } else {
      state = state.copyWith(selectedCategoryId: categoryId);
    }
  }

  /// Get all items from all categories
  List<MenuItemModel> getAllItems() {
    final categories = state.categoriesWithItems.data?.data ?? [];
    final List<MenuItemModel> allItems = [];

    for (final category in categories) {
      if (category.items != null) {
        allItems.addAll(category.items!);
      }
    }

    return allItems;
  }

  /// Get filtered items based on current state
  List<MenuItemModel> getFilteredItems() {
    final categories = state.categoriesWithItems.data?.data ?? [];
    List<MenuItemModel> items = [];

    // Get items from selected category or all categories
    if (state.selectedCategoryId != null) {
      final selectedCategory = categories.firstWhere(
        (cat) => cat.id == state.selectedCategoryId,
        orElse: () => const FoodCategoryModel(),
      );
      items = selectedCategory.items ?? [];
    } else {
      // Get all items from all categories
      for (final category in categories) {
        if (category.items != null) {
          items.addAll(category.items!);
        }
      }
    }

    // Apply search query filter
    if (state.query != null && state.query!.isNotEmpty) {
      final query = state.query!.toLowerCase();
      items = items.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query);
      }).toList();
    }

    return items;
  }

  /// Get list of categories
  List<FoodCategoryModel> getCategories() {
    return state.categoriesWithItems.data?.data ?? [];
  }

  void toggleAvailability(String itemId) {
    final categories = state.categoriesWithItems.data?.data ?? [];
    final updatedCategories = categories.map((category) {
      if (category.items == null) return category;

      final updatedItems = category.items!.map((item) {
        if (item.id == itemId) {
          return item.copyWith(isAvailable: !item.isAvailable);
        }
        return item;
      }).toList();

      return category.copyWith(items: updatedItems);
    }).toList();

    state = state.copyWith(
      categoriesWithItems: state.categoriesWithItems.copyWith(
        data: state.categoriesWithItems.data?.copyWith(data: updatedCategories),
      ),
    );
  }

  Future<void> deleteItem(String itemId) async {
    try {
      // Call API to delete item from server
      await repository.deleteMenuItem(itemId);

      // Update local state after successful deletion
      final categories = state.categoriesWithItems.data?.data ?? [];
      final updatedCategories = categories.map((category) {
        if (category.items == null) return category;

        final updatedItems =
            category.items!.where((item) => item.id != itemId).toList();
        return category.copyWith(items: updatedItems);
      }).toList();

      state = state.copyWith(
        categoriesWithItems: state.categoriesWithItems.copyWith(
          data:
              state.categoriesWithItems.data?.copyWith(data: updatedCategories),
        ),
      );
    } catch (e) {
      // Handle error - refresh the menu to get the latest state
      await refreshMenu();
      rethrow; // Re-throw to allow UI to handle error display
    }
  }

  void updateItem(MenuItemModel updatedItem) {
    final categories = state.categoriesWithItems.data?.data ?? [];
    final updatedCategories = categories.map((category) {
      if (category.items == null) return category;

      final updatedItems = category.items!.map((item) {
        if (item.id == updatedItem.id) {
          return updatedItem;
        }
        return item;
      }).toList();

      return category.copyWith(items: updatedItems);
    }).toList();

    state = state.copyWith(
      categoriesWithItems: state.categoriesWithItems.copyWith(
        data: state.categoriesWithItems.data?.copyWith(data: updatedCategories),
      ),
    );
  }

  void addItem(MenuItemModel newItem) {
    final categories = state.categoriesWithItems.data?.data ?? [];
    final categoryId = int.tryParse(newItem.category);

    final updatedCategories = categories.map((category) {
      if (category.id == categoryId) {
        final currentItems = category.items ?? [];
        final updatedItems = [...currentItems, newItem];
        return category.copyWith(items: updatedItems);
      }
      return category;
    }).toList();

    state = state.copyWith(
      categoriesWithItems: state.categoriesWithItems.copyWith(
        data: state.categoriesWithItems.data?.copyWith(data: updatedCategories),
      ),
    );
  }
}
