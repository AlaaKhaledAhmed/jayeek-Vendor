import 'package:equatable/equatable.dart';

class AddonItem {
  String name;
  String price; // نصي لتناسق مع TextField
  String quantity;
  AddonItem({required this.name, required this.price, required this.quantity});
}

class AddonGroup {
  String name;
  bool isRequired; // true = إجباري
  int? maxSelectable; // مستخدم فقط إن كانت اختيارية
  final List<AddonItem> items;

  AddonGroup({
    required this.name,
    required this.isRequired,
    this.maxSelectable,
    List<AddonItem>? items,
  }) : items = items ?? [];
}

class AddItemState extends Equatable {
  final bool isLoading;
  final List<String> categories;
  final List<String> branches;
  final String? mealImagePath;
  final List<AddonGroup> addonGroups;
  final bool isCustomizable;
  final bool isAvailable;

  const AddItemState({
    this.isLoading = false,
    this.categories = const [],
    this.branches = const [],
    this.mealImagePath,
    this.addonGroups = const [],
    this.isCustomizable = false,
    this.isAvailable = true,
  });

  AddItemState copyWith({
    bool? isLoading,
    List<String>? categories,
    List<String>? branches,
    String? mealImagePath,
    List<AddonGroup>? addonGroups,
    bool? isCustomizable,
    bool? isAvailable,
  }) {
    return AddItemState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      branches: branches ?? this.branches,
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
    branches,
    mealImagePath,
    addonGroups,
    isCustomizable,
    isAvailable,
  ];
}
