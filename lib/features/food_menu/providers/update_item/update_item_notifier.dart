import 'dart:io';
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
      // Group addons by name (simple approach)
      // In a real scenario, you might need more sophisticated grouping
      for (var addon in loadedItem!.availableAddons!) {
        final addonItem = AddonItem(
          name: addon.name,
          price: addon.price.toString(),
          image: addon.image,
        );

        // Create a group for each addon (you can modify this logic)
        final group = AddonGroup(
          title: addon.name,
          items: [addonItem],
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

      // Create updated MenuItemModel
      final updatedItem = loadedItem!.copyWith(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.tryParse(priceController.text) ?? loadedItem!.price,
        imageUrl: state.mealImagePath ?? loadedItem!.imageUrl,
        category: selectedCategory!.id?.toString() ?? loadedItem!.category,
        isAvailable: state.isAvailable,
        isCustomizable: state.isCustomizable,
        availableAddons: null,
      );

      // Call repository to update item with addon groups
      final response = await repository.updateMenuItem(
        updatedItem,
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
        message: 'تم تحديث الصنف بنجاح',
        type: ToastType.success,
      );

      // Return the item from response or updatedItem
      return response.data ?? updatedItem;
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
