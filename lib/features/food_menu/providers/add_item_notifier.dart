import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/image_picker_service.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../core/constants/app_string.dart';
import '../domain/models/menu_item_model.dart';
import '../domain/models/food_category_model.dart';
import '../domain/repositories/food_repository.dart';
import 'add_item_state.dart';

class AddItemNotifier extends StateNotifier<AddItemState> {
  final FoodRepository repository;

  final formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  FoodCategoryModel? selectedCategory;

  AddItemNotifier(this.repository) : super(const AddItemState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final response = await repository.getFoodCategories();
    if (!response.hasError && response.data != null) {
      final categories = response.data!.data ?? [];
      // Filter out deleted categories
      final activeCategories =
          categories.where((cat) => cat.deleteFlag != true).toList();
      state = state.copyWith(isLoading: false, categories: activeCategories);
    } else {
      state = state.copyWith(isLoading: false, categories: []);
    }
  }

  // صورة (placeholder – اربطه لاحقًا مع ImagePicker)
  void setMealImagePath(String path) {
    state = state.copyWith(mealImagePath: path);
  }

  void selectCategory(FoodCategoryModel? v) => selectedCategory = v;

  void toggleCustomizable(bool v) {
    state = state.copyWith(isCustomizable: v);
  }

  void toggleAvailable(bool v) {
    state = state.copyWith(isAvailable: v);
  }

  // Refresh categories from API
  Future<void> refreshCategories() async {
    final response = await repository.getFoodCategories();
    if (!response.hasError && response.data != null) {
      final categories = response.data!.data ?? [];
      final activeCategories =
          categories.where((cat) => cat.deleteFlag != true).toList();
      state = state.copyWith(categories: activeCategories);
    }
  }

  // إدارة الإضافات
  void addAddonGroup(AddonGroup group) {
    final list = [...state.addonGroups, group];
    state = state.copyWith(addonGroups: list);
  }

  void deleteAddonGroup(int index) {
    final list = [...state.addonGroups]..removeAt(index);
    state = state.copyWith(addonGroups: list);
  }

  void editAddonGroupTitle(int index, String title) {
    final list = [...state.addonGroups];
    list[index].title = title;
    state = state.copyWith(addonGroups: list);
  }

  void setGroupSelectionType(int index, bool isSingle) {
    final list = [...state.addonGroups];
    list[index].isSingleSelection = isSingle;
    if (isSingle) {
      list[index].maxSelectable = null;
    }
    state = state.copyWith(addonGroups: list);
  }

  void setGroupRequired(int index, bool required) {
    final list = [...state.addonGroups];
    list[index].isRequired = required;
    state = state.copyWith(addonGroups: list);
  }

  void setGroupMaxSelectable(int index, int? max) {
    final list = [...state.addonGroups];
    list[index].maxSelectable = max;
    state = state.copyWith(addonGroups: list);
  }

  void setGroupAllowQuantity(int index, bool allow) {
    final list = [...state.addonGroups];
    list[index].allowQuantity = allow;
    state = state.copyWith(addonGroups: list);
  }

  void editAddonItem(int groupIndex, int itemIndex, AddonItem updatedItem) {
    final list = [...state.addonGroups];
    list[groupIndex].items[itemIndex] = updatedItem;
    state = state.copyWith(addonGroups: list);
  }

  void addAddonItem(int groupIndex, AddonItem item) {
    final list = [...state.addonGroups];
    list[groupIndex].items.add(item);
    state = state.copyWith(addonGroups: list);
  }

  void deleteAddonItem(int groupIndex, int itemIndex) {
    final list = [...state.addonGroups];
    list[groupIndex].items.removeAt(itemIndex);
    state = state.copyWith(addonGroups: list);
  }

  Future<void> pickMealImage(BuildContext context) async {
    final path = await AppImagePicker.pickImageWithSource(
      context: context,
      imageQuality: 85,
    );

    if (path != null) {
      // Check file size (1 MB = 1024 * 1024 bytes)
      try {
        final file = File(path);
        final fileSize = await file.length();
        const maxSize = 1024 * 1024; // 1 MB in bytes

        if (fileSize > maxSize) {
          AppSnackBar.show(
            message: AppMessage.imageSizeExceedsLimit,
            type: ToastType.error,
          );
          return;
        }

        // If file size is OK, save the path
        setMealImagePath(path);
      } catch (e) {
        AppSnackBar.show(
          message: AppMessage.errorCheckingImageSize,
          type: ToastType.error,
        );
      }
    }
  }

  Future<MenuItemModel?> submit() async {
    if (!formKey.currentState!.validate()) return null;

    // Check if image is selected (required)
    if (state.mealImagePath == null || state.mealImagePath!.isEmpty) {
      return null;
    }

    // Check if category is selected (required)
    if (selectedCategory == null) {
      AppSnackBar.show(
        message: 'يرجى اختيار الفئة',
        type: ToastType.error,
      );
      return null;
    }

    try {
      state = state.copyWith(isLoading: true);

      // Create MenuItemModel
      final newItem = MenuItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        imageUrl: state.mealImagePath ?? '',
        price: double.tryParse(priceController.text) ?? 0.0,
        isAvailable: state.isAvailable,
        isFeatured: false,
        category: selectedCategory!.id?.toString() ?? '0',
        isCustomizable: state.isCustomizable,
        availableAddons: null,
      );

      // Call repository to create item with addon groups
      final response = await repository.createMenuItem(
        newItem,
        state.addonGroups,
      );

      state = state.copyWith(isLoading: false);

      if (response.hasError) {
        AppSnackBar.show(
          message: response.message ?? AppMessage.errorOccurred,
          type: ToastType.error,
        );
        return null;
      }

      // Show success message
      AppSnackBar.show(
        message: AppMessage.addedSuccessfully,
        type: ToastType.success,
      );

      // Return the item from response or newItem
      return response.data ?? newItem;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      AppSnackBar.show(
        message: 'فشل في إضافة الصنف: ${e.toString()}',
        type: ToastType.error,
      );
      return null;
    }
  }

  /// Reset form to initial state
  void resetForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    selectedCategory = null;
    state = state.copyWith(
      mealImagePath: null,
      addonGroups: const [],
      isCustomizable: false,
      isAvailable: true,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
