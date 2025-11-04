import 'package:equatable/equatable.dart';
import 'package:jayeek_vendor/core/model/data_handel.dart';
import '../../domain/models/food_category_model.dart';
import '../../domain/models/menu_items_response.dart';

class MenuState extends Equatable {
  final DataHandle<MenuItemsResponse> items;
  final String? query;
  final String? category;
  final int? selectedCategoryId;
  final bool? gridMode;
  final DataHandle<FoodCategoriesResponse> categories;

  const MenuState({
    this.items = const DataHandle(),
    this.query,
    this.category,
    this.selectedCategoryId,
    this.gridMode,
    this.categories = const DataHandle(),
  });

  MenuState copyWith({
    DataHandle<MenuItemsResponse>? items,
    String? query,
    String? category,
    int? selectedCategoryId,
    bool? gridMode,
    DataHandle<FoodCategoriesResponse>? categories,
  }) {
    return MenuState(
      items: items ?? this.items,
      query: query ?? this.query,
      category: category == '' ? null : (category ?? this.category),
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      gridMode: gridMode ?? this.gridMode,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        items,
        query,
        category,
        selectedCategoryId,
        gridMode,
        categories,
      ];
}
