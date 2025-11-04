import 'package:equatable/equatable.dart';
import '../add_item_state.dart';
import '../../domain/models/food_category_model.dart';

class UpdateItemState extends Equatable {
  final bool isLoading;
  final List<FoodCategoryModel> categories;
  final String? mealImagePath;
  final List<AddonGroup> addonGroups;
  final bool isCustomizable;
  final bool isAvailable;

  const UpdateItemState({
    this.isLoading = false,
    this.categories = const [],
    this.mealImagePath,
    this.addonGroups = const [],
    this.isCustomizable = false,
    this.isAvailable = true,
  });

  UpdateItemState copyWith({
    bool? isLoading,
    List<FoodCategoryModel>? categories,
    String? mealImagePath,
    List<AddonGroup>? addonGroups,
    bool? isCustomizable,
    bool? isAvailable,
  }) {
    return UpdateItemState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      mealImagePath: mealImagePath ?? this.mealImagePath,
      addonGroups: addonGroups ?? this.addonGroups,
      isCustomizable: isCustomizable ?? this.isCustomizable,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    categories,
    mealImagePath,
    addonGroups,
    isCustomizable,
    isAvailable,
  ];
}
