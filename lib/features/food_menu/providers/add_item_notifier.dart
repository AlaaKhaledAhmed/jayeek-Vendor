import 'dart:io';
import 'dart:convert';
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

  /// Process addon groups and convert them to the format expected by backend
  Future<List<Map<String, dynamic>>> _processAddonGroups(
      List<AddonGroup> addonGroups) async {
    final List<Map<String, dynamic>> processedAddons = [];

    if (addonGroups.isEmpty) {
      return processedAddons;
    }

    for (final group in addonGroups) {
      // Process addon options from group items (can be empty)
      final List<Map<String, dynamic>> addonOptions = [];
      for (final item in group.items) {
        addonOptions.add({
          'id': 0, // Backend will generate
          'name': item.name,
          'price': double.tryParse(item.price) ?? 0.0,
        });
      }

      // Get addon image from first item if available
      String? addonImageBase64;
      if (group.items.isNotEmpty) {
        final firstItem = group.items.first;
        if (firstItem.image != null && firstItem.image!.isNotEmpty) {
          if (firstItem.image!.startsWith('/') &&
              !firstItem.image!.startsWith('http')) {
            // It's a local file path, convert to base64
            try {
              final file = File(firstItem.image!);
              final bytes = await file.readAsBytes();
              addonImageBase64 = base64Encode(bytes);
            } catch (e) {
              // If file read fails, use the existing string (might already be base64)
              addonImageBase64 = firstItem.image;
            }
          } else if (firstItem.image!.startsWith('http')) {
            // It's a URL - send it as is (backend should handle it)
            addonImageBase64 = firstItem.image;
          } else {
            // Already base64, use as is
            addonImageBase64 = firstItem.image;
          }
        }
      }

      final addonMap = <String, dynamic>{
        'name': group.title,
        'addonType': 'none', // Fixed as per API spec
        'addonOptions': addonOptions, // Can be empty list
      };

      // Add price only if there are items (use first item's price)
      if (group.items.isNotEmpty) {
        final firstItem = group.items.first;
        addonMap['price'] = double.tryParse(firstItem.price) ?? 0.0;
      } else {
        addonMap['price'] = 0.0; // Default price for addons without options
      }

      // Add contentBase64 only if there's an image
      if (addonImageBase64 != null && addonImageBase64.isNotEmpty) {
        addonMap['contentBase64'] = addonImageBase64;
      }

      processedAddons.add(addonMap);
    }

    return processedAddons;
  }

  /// Convert image to base64 if it's a local file
  Future<String?> _processImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    if (imagePath.startsWith('/') && !imagePath.startsWith('http')) {
      // It's a local file path, convert to base64
      try {
        final file = File(imagePath);
        final bytes = await file.readAsBytes();
        return base64Encode(bytes);
      } catch (e) {
        // If file read fails, use the existing string (might already be base64)
        return imagePath;
      }
    } else if (imagePath.startsWith('http')) {
      // It's a URL, send as is (backend should handle it)
      return imagePath;
    } else {
      // Already base64, use as is
      return imagePath;
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

      // Process image
      final imageBase64 = await _processImage(state.mealImagePath);

      // Process addon groups
      final processedAddons = await _processAddonGroups(state.addonGroups);

      // Prepare request body
      final body = <String, dynamic>{
        'unitId': 0, // Fixed as per requirement
        'itemCategoryId':
            int.tryParse(selectedCategory!.id?.toString() ?? '0') ?? 0,
        'name': nameController.text.trim(),
        'details': descriptionController.text.trim(),
        'price': double.tryParse(priceController.text) ?? 0.0,
        'size': 0, // Fixed as per requirement
        'allBranches': false, // Fixed as per requirement
        'isActive': state.isAvailable,
        'isCustomizable': state.isCustomizable,
        'addons': processedAddons,
      };

      // Add contentBase64 only if there's an image
      if (imageBase64 != null && imageBase64.isNotEmpty) {
        body['contentBase64'] = imageBase64;
      }

      // Call repository with prepared body
      final response = await repository.createMenuItem(body);

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
      // Return the item from response
      return response.data;
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
