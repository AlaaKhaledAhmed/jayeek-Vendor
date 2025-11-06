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

  /// Load categories and branch items
  Future<void> _loadInitialData() async {
    // Load categories first
    await _loadCategories();

    // Load all branch items
    await _loadBranchItems();
  }

  /// Load categories
  Future<void> _loadCategories() async {
    state = state.copyWith(
      categories: state.categories.copyWith(
        result: AppFlowState.loading,
      ),
    );

    final apiResponse = await repository.getFoodCategories();

    if (!apiResponse.hasError && apiResponse.data != null) {
      state = state.copyWith(
        categories: state.categories.copyWith(
          result: AppFlowState.loaded,
          data: apiResponse.data,
        ),
      );
    } else {
      state = state.copyWith(
        categories: state.categories.copyWith(
          result: apiResponse.message ?? AppFlowState.error,
          data: const FoodCategoriesResponse(),
        ),
      );
    }
  }

  /// Load all branch items using Branch API
  Future<void> _loadBranchItems() async {
    state = state.copyWith(
      branchData: state.branchData.copyWith(
        result: AppFlowState.loading,
      ),
    );

    // Get branchId from SharedPreferences
    final branchId = await SharedPreferencesService.getBranchId();

    if (branchId == null) {
      state = state.copyWith(
        branchData: state.branchData.copyWith(
          result: 'Branch ID not found',
        ),
      );
      return;
    }

    final apiResponse = await repository.getBranchItems(branchId);

    if (!apiResponse.hasError && apiResponse.data != null) {
      state = state.copyWith(
        branchData: state.branchData.copyWith(
          result: AppFlowState.loaded,
          data: apiResponse.data,
        ),
      );
    } else {
      state = state.copyWith(
        branchData: state.branchData.copyWith(
          result: apiResponse.message ?? AppFlowState.error,
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

  void setCategory(String? cat) {
    if (cat == null || cat == 'All') {
      // عرض كل العناصر - مسح الفلتر
      state = state.copyWith(
          category: '', selectedCategoryId: null, clearItemCategoryId: true);
    } else {
      // Find the selected category's id
      final categories = state.categories.data?.data ?? [];
      final selectedCategory = categories.firstWhere(
        (c) => c.name == cat && c.deleteFlag != true,
        orElse: () => categories.first,
      );

      // Update state with both category name and itemCategoryId for filtering
      state = state.copyWith(
        category: cat,
        selectedCategoryId: selectedCategory.id,
        selectedItemCategoryId:
            selectedCategory.id, // Use category id as itemCategoryId
      );
    }
  }

  /// فلترة العناصر حسب itemCategoryId
  void setItemCategory(int? itemCategoryId) {
    if (itemCategoryId == null) {
      state = state.copyWith(clearItemCategoryId: true);
    } else {
      state = state.copyWith(selectedItemCategoryId: itemCategoryId);
    }
  }

  /// الحصول على قائمة فريدة من فئات العناصر الموجودة
  List<ItemCategoryInfo> getUniqueItemCategories() {
    final items = state.branchData.data?.data?.items ?? [];
    final Map<int, ItemCategoryInfo> categoryMap = {};

    for (final item in items) {
      final categoryId = int.tryParse(item.category);
      if (categoryId != null && !categoryMap.containsKey(categoryId)) {
        categoryMap[categoryId] = ItemCategoryInfo(
          id: categoryId,
          name: item.categoryName ?? '',
          nameAr: item.categoryNameAr ?? '',
        );
      }
    }

    return categoryMap.values.toList();
  }

  void toggleAvailability(String id) {
    final currentItems = state.branchData.data?.data?.items ?? [];
    final updated = currentItems.map((e) {
      if (e.id == id) return e.copyWith(isAvailable: !e.isAvailable);
      return e;
    }).toList(growable: false);

    // Update branchData with new items
    final updatedBranchData =
        state.branchData.data?.data?.copyWith(items: updated);
    state = state.copyWith(
      branchData: state.branchData.copyWith(
        data: state.branchData.data?.copyWith(data: updatedBranchData),
      ),
    );
  }

  Future<void> deleteItem(String id) async {
    try {
      // Call API to delete item from server
      await repository.deleteMenuItem(id);

      // Update local state after successful deletion
      final currentItems = state.branchData.data?.data?.items ?? [];
      final updated =
          currentItems.where((e) => e.id != id).toList(growable: false);

      final updatedBranchData =
          state.branchData.data?.data?.copyWith(items: updated);
      state = state.copyWith(
        branchData: state.branchData.copyWith(
          data: state.branchData.data?.copyWith(data: updatedBranchData),
        ),
      );
    } catch (e) {
      // Handle error - refresh the menu to get the latest state
      await refreshMenu();
    }
  }

  void updateItem(MenuItemModel updatedItem) {
    final currentItems = state.branchData.data?.data?.items ?? [];
    final updated = currentItems
        .map((e) => e.id == updatedItem.id ? updatedItem : e)
        .toList(growable: false);

    final updatedBranchData =
        state.branchData.data?.data?.copyWith(items: updated);
    state = state.copyWith(
      branchData: state.branchData.copyWith(
        data: state.branchData.data?.copyWith(data: updatedBranchData),
      ),
    );
  }

  void addItem(MenuItemModel newItem) {
    final currentItems = state.branchData.data?.data?.items ?? [];
    final updated = [...currentItems, newItem];

    final updatedBranchData =
        state.branchData.data?.data?.copyWith(items: updated);
    state = state.copyWith(
      branchData: state.branchData.copyWith(
        data: state.branchData.data?.copyWith(data: updatedBranchData),
      ),
    );
  }
}

/// معلومات فئة العنصر
class ItemCategoryInfo {
  final int id;
  final String name;
  final String nameAr;

  ItemCategoryInfo({
    required this.id,
    required this.name,
    required this.nameAr,
  });
}
