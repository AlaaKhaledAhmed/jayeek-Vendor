import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/constants/app_string.dart';
import '../../domain/models/menu_item_model.dart';
import '../../domain/models/food_category_model.dart';
import '../../domain/repositories/food_repository.dart';
import '../add_item_state.dart';
import 'update_item_state.dart';

class UpdateItemNotifier extends StateNotifier<UpdateItemState> {
  final FoodRepository repository;
  final int itemId; // Use itemId instead of full item

  final formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;

  FoodCategoryModel? selectedCategory;
  MenuItemModel? loadedItem; // Store the loaded item
  String? originalImageUrl; // Store original image URL to detect changes

  UpdateItemNotifier(this.repository, this.itemId)
      : super(const UpdateItemState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);

    // Initialize controllers with empty values
    nameController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();

    // Fetch item data from API
    final itemResponse = await repository.getMenuItemById(itemId);

    if (itemResponse.hasError || itemResponse.data == null) {
      state = state.copyWith(
        isLoading: false,
        categories: [],
      );
      AppSnackBar.show(
        message: itemResponse.message ?? 'فشل في جلب بيانات الصنف',
        type: ToastType.error,
      );
      return;
    }

    loadedItem = itemResponse.data!;
    originalImageUrl = loadedItem!.imageUrl; // Store original image URL

    // Set controller values from loaded item
    nameController.text = loadedItem!.name;
    priceController.text = loadedItem!.price.toString();
    descriptionController.text = loadedItem!.description;

    // Fetch categories to populate dropdown
    final categoriesResponse = await repository.getFoodCategories();
    List<FoodCategoryModel> activeCategories = [];

    if (!categoriesResponse.hasError && categoriesResponse.data != null) {
      final categories = categoriesResponse.data!.data ?? [];
      activeCategories =
          categories.where((cat) => cat.deleteFlag != true).toList();

      // Find and set the selected category by ID
      if (loadedItem!.category.isNotEmpty && activeCategories.isNotEmpty) {
        try {
          final categoryId = int.tryParse(loadedItem!.category);
          if (categoryId != null) {
            selectedCategory = activeCategories.firstWhere(
              (cat) => cat.id == categoryId,
              orElse: () => activeCategories.first,
            );
          }
        } catch (e) {
          selectedCategory =
              activeCategories.isNotEmpty ? activeCategories.first : null;
        }
      }
    }

    // Convert addons to addon groups if available
    List<AddonGroup> addonGroups = [];
    if (loadedItem!.availableAddons != null &&
        loadedItem!.availableAddons!.isNotEmpty) {
      // Convert each addon to a group
      // If addon has addonOptions, convert them to AddonItem
      // If addon has no options, create an empty group
      for (var addon in loadedItem!.availableAddons!) {
        List<AddonItem> items = [];

        // Convert addonOptions to AddonItem if they exist
        if (addon.addonOptions.isNotEmpty) {
          for (var option in addon.addonOptions) {
            items.add(AddonItem(
              name: option.name,
              price: option.price.toString(),
              image: addon.image, // Use addon image for all options
            ));
          }
        }

        // Create a group for each addon
        // Group can have items (if addonOptions exist) or be empty
        final group = AddonGroup(
          title: addon.name,
          items: items,
        );
        addonGroups.add(group);
      }
    }

    state = state.copyWith(
      isLoading: false,
      categories: activeCategories,
      mealImagePath: loadedItem!.imageUrl,
      isAvailable: loadedItem!.isAvailable,
      isCustomizable: loadedItem!.isCustomizable,
      addonGroups: addonGroups,
    );
  }

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

  void addAddonGroup(AddonGroup group) {
    final list = [...state.addonGroups, group];
    state = state.copyWith(addonGroups: list);
  }

  void deleteAddonGroup(int index) {
    final list = [...state.addonGroups]..removeAt(index);
    state = state.copyWith(addonGroups: list);
  }

  void setGroupRequired(int index, bool required) {
    final list = [...state.addonGroups];
    list[index].isRequired = required;
    if (required) list[index].maxSelectable = null;
    state = state.copyWith(addonGroups: list);
  }

  void setGroupMaxSelectable(int index, int? max) {
    final list = [...state.addonGroups];
    list[index].maxSelectable = max;
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

  void editAddonItem(int groupIndex, int itemIndex, AddonItem updatedItem) {
    final list = [...state.addonGroups];
    list[groupIndex].items[itemIndex] = updatedItem;
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

  void setGroupAllowQuantity(int index, bool allow) {
    final list = [...state.addonGroups];
    list[index].allowQuantity = allow;
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
  Future<String?> _processImage(
      String? imagePath, String? originalImageUrl) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    final imageChanged =
        originalImageUrl != null && imagePath != originalImageUrl;

    if (imagePath.startsWith('/') && !imagePath.startsWith('http')) {
      // It's a local file path (new image selected), convert to base64
      try {
        final file = File(imagePath);
        final bytes = await file.readAsBytes();
        return base64Encode(bytes);
      } catch (e) {
        // If file read fails, use the existing string (might already be base64)
        return imagePath;
      }
    } else if (imagePath.startsWith('http')) {
      // It's a URL - check if it's different from original
      if (imageChanged) {
        // Image was changed, send the new URL
        return imagePath;
      } else {
        // Image is the same, don't send it (image already exists on server)
        return null;
      }
    } else {
      // Already base64 (new image), use as is
      return imagePath;
    }
  }

  Future<MenuItemModel?> update() async {
    if (!formKey.currentState!.validate()) return null;

    // Check if item was loaded successfully
    if (loadedItem == null) {
      AppSnackBar.show(
        message: 'لم يتم تحميل بيانات الصنف',
        type: ToastType.error,
      );
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

      // Get current image path
      final currentImagePath = state.mealImagePath ?? loadedItem!.imageUrl;

      // Process image
      final imageBase64 =
          await _processImage(currentImagePath, originalImageUrl);

      // Process addon groups
      final processedAddons = await _processAddonGroups(state.addonGroups);

      // Prepare request body
      final body = <String, dynamic>{
        'itemId': int.tryParse(loadedItem!.id) ?? 0, // Required for update
        'unitId': 0, // Fixed as per requirement
        'itemCategoryId': int.tryParse(
                selectedCategory!.id?.toString() ?? loadedItem!.category) ??
            0,
        'name': nameController.text.trim(),
        'details': descriptionController.text.trim(),
        'price': double.tryParse(priceController.text) ?? loadedItem!.price,
        'size': 0, // Fixed as per requirement
        'allBranches': true, // Fixed as per requirement
        'isActive': state.isAvailable,
        'isCustomizable': state.isCustomizable,
        'addons': processedAddons,
        'removeImage': false, // Don't remove existing image
      };

      // Add contentBase64 only if there's a new image
      if (imageBase64 != null && imageBase64.isNotEmpty) {
        body['contentBase64'] = imageBase64;
      }

      // Call repository with prepared body
      final response = await repository.updateMenuItem(body);

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
        message: 'تم تحديث الصنف بنجاح',
        type: ToastType.success,
      );

      // Return the item from response
      return response.data;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      AppSnackBar.show(
        message: 'فشل في تحديث الصنف: ${e.toString()}',
        type: ToastType.error,
      );
      return null;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
