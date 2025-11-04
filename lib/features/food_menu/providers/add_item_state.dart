import 'package:equatable/equatable.dart';
import '../domain/models/food_category_model.dart';

class AddonItem {
  String name;
  String price; // نصي لتناسق مع TextField
  String? description;
  String? image; // يمكن أن يكون URL أو base64
  String quantity; // الكمية (يستخدم فقط إذا كان allowQuantity = true)
  
  AddonItem({
    required this.name,
    required this.price,
    this.description,
    this.image,
    this.quantity = '1',
  });
}

class AddonGroup {
  String title; // عنوان المجموعة (مثل "صوصات")
  bool isSingleSelection; // true = اختيار واحد، false = اختيار متعدد
  int? maxSelectable; // الحد الأقصى للاختيارات (اختياري، فقط إذا كان متعدد)
  bool allowQuantity; // هل يمكن اختيار كمية من كل خيار (افتراضي: false)
  bool isRequired; // true = إجباري
  final List<AddonItem> items;

  AddonGroup({
    required this.title,
    this.isSingleSelection = false, // افتراضي: اختيار متعدد
    this.maxSelectable,
    this.allowQuantity = false, // افتراضي: لا يمكن اختيار كمية
    this.isRequired = false,
    List<AddonItem>? items,
  }) : items = items ?? [];
}

class AddItemState extends Equatable {
  final bool isLoading;
  final List<FoodCategoryModel> categories;
  final String? mealImagePath;
  final List<AddonGroup> addonGroups;
  final bool isCustomizable;
  final bool isAvailable;

  const AddItemState({
    this.isLoading = false,
    this.categories = const [],
    this.mealImagePath,
    this.addonGroups = const [],
    this.isCustomizable = false,
    this.isAvailable = true,
  });

  AddItemState copyWith({
    bool? isLoading,
    List<FoodCategoryModel>? categories,
    String? mealImagePath,
    List<AddonGroup>? addonGroups,
    bool? isCustomizable,
    bool? isAvailable,
  }) {
    return AddItemState(
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
