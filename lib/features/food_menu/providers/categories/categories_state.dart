import 'package:equatable/equatable.dart';

import '../../domain/models/food_category_model.dart';
import '../../../../core/model/data_handel.dart';

class CategoriesState extends Equatable {
  final DataHandle<FoodCategoriesResponse> categoriesData;
  final bool isLoading;
  final String? selectedImagePath;

  const CategoriesState({
    this.categoriesData = const DataHandle<FoodCategoriesResponse>(),
    this.isLoading = false,
    this.selectedImagePath,
  });

  CategoriesState copyWith({
    DataHandle<FoodCategoriesResponse>? categoriesData,
    bool? isLoading,
    String? selectedImagePath,
  }) {
    return CategoriesState(
      categoriesData: categoriesData ?? this.categoriesData,
      isLoading: isLoading ?? this.isLoading,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
    );
  }

  /// Helper getter for easy access to categories list
  List<FoodCategoryModel> get categories => categoriesData.data?.data ?? [];

  @override
  List<Object?> get props => [
        categoriesData,
        isLoading,
        selectedImagePath,
      ];
}
