import 'package:equatable/equatable.dart';
import 'package:jayeek_vendor/core/model/data_handel.dart';
import '../../domain/models/food_category_model.dart';

class MenuState extends Equatable {
  final DataHandle<FoodCategoriesResponse>
      categoriesWithItems; // NEW: Unified data structure
  final String? query;
  final int? selectedCategoryId; // للفلترة حسب الفئة
  final bool? gridMode;

  const MenuState({
    this.categoriesWithItems = const DataHandle(),
    this.query,
    this.selectedCategoryId,
    this.gridMode,
  });

  MenuState copyWith({
    DataHandle<FoodCategoriesResponse>? categoriesWithItems,
    String? query,
    int? selectedCategoryId,
    bool? clearCategoryId = false,
    bool? gridMode,
  }) {
    return MenuState(
      categoriesWithItems: categoriesWithItems ?? this.categoriesWithItems,
      query: query ?? this.query,
      selectedCategoryId: clearCategoryId == true
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      gridMode: gridMode ?? this.gridMode,
    );
  }

  @override
  List<Object?> get props => [
        categoriesWithItems,
        query,
        selectedCategoryId,
        gridMode,
      ];
}
