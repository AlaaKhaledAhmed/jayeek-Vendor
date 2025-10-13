import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/photo_permission_service.dart';
import '../../domain/models/menu_item_model.dart';
import '../../domain/repositories/food_repository.dart';
import '../add_item_state.dart';
import 'update_item_state.dart';

class UpdateItemNotifier extends StateNotifier<UpdateItemState> {
  final FoodRepository repository;
  final MenuItemModel item;

  final formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;

  String? selectedCategory;
  String? selectedBranch;

  UpdateItemNotifier(this.repository, this.item)
    : super(const UpdateItemState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);

    // Initialize controllers with item data
    nameController = TextEditingController(text: item.name);
    priceController = TextEditingController(text: item.price.toString());
    descriptionController = TextEditingController(text: item.description);

    final cats = await repository.getCategories();
    final brs = await repository.getBranches();

    // Set category only if it exists in the list
    if (cats.contains(item.category)) {
      selectedCategory = item.category;
    } else {
      selectedCategory = null;
    }

    // Set branch only if it exists in the list
    if (item.branch != null && brs.contains(item.branch)) {
      selectedBranch = item.branch;
    } else {
      selectedBranch = null;
    }

    state = state.copyWith(
      isLoading: false,
      categories: cats,
      branches: brs,
      mealImagePath: item.imageUrl,
      isAvailable: item.isAvailable,
      isCustomizable: item.isCustomizable,
    );
  }

  void setMealImagePath(String path) {
    state = state.copyWith(mealImagePath: path);
  }

  void selectCategory(String? v) => selectedCategory = v;
  void selectBranch(String? v) => selectedBranch = v;

  void toggleCustomizable(bool v) {
    state = state.copyWith(isCustomizable: v);
  }

  void toggleAvailable(bool v) {
    state = state.copyWith(isAvailable: v);
  }

  Future<void> addNewCategory(String name) async {
    await repository.addCategory(name);
    final updated = [...state.categories, name];
    state = state.copyWith(categories: updated);
    selectedCategory = name;
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

  Future<void> pickMealImage(BuildContext context) async {
    final granted = await PhotoPermissionService.ensurePhotosPermission(
      context,
    );
    if (!granted) return;

    final path = await AppImagePicker.pickFromGallery(imageQuality: 85);
    if (path != null) {
      setMealImagePath(path);
    }
  }

  Future<MenuItemModel?> update() async {
    if (!formKey.currentState!.validate()) return null;

    // Create updated MenuItemModel
    final updatedItem = item.copyWith(
      name: nameController.text,
      description: descriptionController.text,
      price: double.tryParse(priceController.text) ?? item.price,
      imageUrl: state.mealImagePath ?? item.imageUrl,
      category: selectedCategory,
      branch: selectedBranch,
      isAvailable: state.isAvailable,
      isCustomizable: state.isCustomizable,
    );

    final payload = updatedItem.toJson();
    payload['addons'] = state.addonGroups
        .map(
          (g) => {
            "name": g.name,
            "required": g.isRequired,
            "maxSelectable": g.maxSelectable,
            "items": g.items
                .map(
                  (i) => {
                    "name": i.name,
                    "price": i.price,
                    "quantity": i.quantity,
                  },
                )
                .toList(),
          },
        )
        .toList();

    state = state.copyWith(isLoading: true);
    await repository.updateFoodItem(payload);
    state = state.copyWith(isLoading: false);

    return updatedItem;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
