import 'package:equatable/equatable.dart';
import 'package:jayeek_vendor/core/model/data_handel.dart';
import '../../domain/models/branch_response.dart';
import '../../domain/models/food_category_model.dart';
import '../../domain/models/menu_items_response.dart';

class MenuState extends Equatable {
  final DataHandle<MenuItemsResponse> items;
  final DataHandle<BranchResponse>
      branchData; // NEW: بيانات Branch مع كل العناصر
  final String? query;
  final String? category;
  final int? selectedCategoryId;
  final int? selectedItemCategoryId; // للفلترة حسب itemCategoryId
  final bool? gridMode;
  final DataHandle<FoodCategoriesResponse> categories;

  const MenuState({
    this.items = const DataHandle(),
    this.branchData = const DataHandle(),
    this.query,
    this.category,
    this.selectedCategoryId,
    this.selectedItemCategoryId,
    this.gridMode,
    this.categories = const DataHandle(),
  });

  MenuState copyWith({
    DataHandle<MenuItemsResponse>? items,
    DataHandle<BranchResponse>? branchData,
    String? query,
    String? category,
    int? selectedCategoryId,
    int? selectedItemCategoryId,
    bool? clearItemCategoryId = false,
    bool? gridMode,
    DataHandle<FoodCategoriesResponse>? categories,
  }) {
    return MenuState(
      items: items ?? this.items,
      branchData: branchData ?? this.branchData,
      query: query ?? this.query,
      category: category == '' ? null : (category ?? this.category),
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedItemCategoryId: clearItemCategoryId == true
          ? null
          : (selectedItemCategoryId ?? this.selectedItemCategoryId),
      gridMode: gridMode ?? this.gridMode,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        items,
        branchData,
        query,
        category,
        selectedCategoryId,
        selectedItemCategoryId,
        gridMode,
        categories,
      ];
}
