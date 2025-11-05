import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/food_category_model.dart';
import '../../domain/repositories/food_repository.dart';
import '../../../../core/constants/app_flow_sate.dart';
import '../../../../core/model/data_handel.dart';
import '../../../../core/domain/repositories/state_repository.dart';
import 'dart:io';
import 'dart:convert';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/constants/app_string.dart';

import 'categories_state.dart';

class CategoriesNotifier extends StateNotifier<CategoriesState>
    implements StateRepository {
  final FoodRepository _repository;

  CategoriesNotifier(this._repository) : super(const CategoriesState());

  // Controllers for add form
  final TextEditingController _addNameController = TextEditingController();
  final TextEditingController _addNameArController = TextEditingController();
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();
  String? _addSelectedImagePath;

  // Controllers for edit form
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editNameArController = TextEditingController();
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
  String? _editSelectedImagePath;
  FoodCategoryModel? _editingCategory;

  // Getters for add form
  TextEditingController get addNameController => _addNameController;
  TextEditingController get addNameArController => _addNameArController;
  GlobalKey<FormState> get addFormKey => _addFormKey;
  String? get addSelectedImagePath => _addSelectedImagePath;

  // Getters for edit form
  TextEditingController get editNameController => _editNameController;
  TextEditingController get editNameArController => _editNameArController;
  GlobalKey<FormState> get editFormKey => _editFormKey;
  String? get editSelectedImagePath => _editSelectedImagePath;
  FoodCategoryModel? get editingCategory => _editingCategory;

  @override
  void dispose() {
    _addNameController.dispose();
    _addNameArController.dispose();
    _editNameController.dispose();
    _editNameArController.dispose();
    super.dispose();
  }

  @override
  void resetState() {
    // Reset add form
    _addNameController.clear();
    _addNameArController.clear();
    _addSelectedImagePath = null;

    // Reset edit form
    _editNameController.clear();
    _editNameArController.clear();
    _editSelectedImagePath = null;
    _editingCategory = null;

    state = state.copyWith(selectedImagePath: null, isLoading: false);
  }

  void resetAddForm() {
    _addNameController.clear();
    _addNameArController.clear();
    _addSelectedImagePath = null;
    state = state.copyWith(selectedImagePath: null);
  }
  
  /// Set image path directly (for emojis)
  void setAddImagePath(String path) {
    _addSelectedImagePath = path;
    state = state.copyWith(selectedImagePath: path);
  }
  
  /// Set edit image path directly (for emojis)
  void setEditImagePath(String path) {
    _editSelectedImagePath = path;
    state = state.copyWith(selectedImagePath: path);
  }

  void resetEditForm() {
    _editNameController.clear();
    _editNameArController.clear();
    _editSelectedImagePath = null;
    _editingCategory = null;
    state = state.copyWith(selectedImagePath: null);
  }

  @override
  void loadData({bool? refresh}) async {
    if (refresh == true) {
      getCategories();
    } else {
      if (state.categoriesData.result == AppFlowState.initial ||
          state.categoriesData.result == AppFlowState.error) {
        getCategories();
      }
    }
  }

  Future<void> getCategories() async {
    state = state.copyWith(
      categoriesData: state.categoriesData.copyWith(
        result: AppFlowState.loading,
      ),
    );

    final response = await _repository.getFoodCategories();

    if (!response.hasError && response.data != null) {
      state = state.copyWith(
        categoriesData: state.categoriesData.copyWith(
          result: AppFlowState.loaded,
          data: response.data,
        ),
      );
    } else {
      state = state.copyWith(
        categoriesData: state.categoriesData.copyWith(
          result: response.message ?? AppFlowState.error,
          data: const FoodCategoriesResponse(),
        ),
      );
    }
  }

  void loadCategoryForEdit(FoodCategoryModel category) {
    _editingCategory = category;
    _editNameController.text = category.name ?? '';
    _editNameArController.text = category.nameAr ?? '';
    _editSelectedImagePath = category.image;
    state = state.copyWith(selectedImagePath: category.image);
  }

  Future<PostDataHandle<FoodCategoryModel>> createCategory() async {
    if (!_addFormKey.currentState!.validate()) {
      return PostDataHandle<FoodCategoryModel>(
        hasError: true,
        message: AppFlowState.error,
      );
    }

    state = state.copyWith(isLoading: true);

    // Get organizationId from shared preferences
    final organizationId = await SharedPreferencesService.getOrganizationId();

    // Convert image to base64 if it's a local file
    String? imageBase64;
    if (_addSelectedImagePath != null && _addSelectedImagePath!.isNotEmpty) {
      // Check if it's a local file path
      if (_addSelectedImagePath!.startsWith('/') &&
          !_addSelectedImagePath!.startsWith('http')) {
        try {
          final file = File(_addSelectedImagePath!);
          final bytes = await file.readAsBytes();
          imageBase64 = base64Encode(bytes);
        } catch (e) {
          // If file read fails, use the existing string (might already be base64)
          imageBase64 = _addSelectedImagePath;
        }
      } else {
        // Already base64 or URL, use as is
        imageBase64 = _addSelectedImagePath;
      }
    }

    final category = FoodCategoryModel(
      name: _addNameController.text.trim(),
      nameAr: _addNameArController.text.trim().isEmpty
          ? null
          : _addNameArController.text.trim(),
      image: imageBase64,
      organizationId: organizationId,
    );

    final response = await _repository.createCategory(category);

    state = state.copyWith(isLoading: false);

    if (!response.hasError) {
      await getCategories();
      resetAddForm();
    }

    return response;
  }

  Future<PostDataHandle<FoodCategoryModel>> updateCategory() async {
    if (!_editFormKey.currentState!.validate() || _editingCategory == null) {
      return PostDataHandle<FoodCategoryModel>(
        hasError: true,
        message: AppFlowState.error,
      );
    }

    state = state.copyWith(isLoading: true);

    // Get organizationId from shared preferences if not already set
    final organizationId = _editingCategory!.organizationId ??
        await SharedPreferencesService.getOrganizationId();

    // Convert image to base64 if it's a local file
    String? imageBase64;
    final imagePath = _editSelectedImagePath ?? _editingCategory!.image;
    if (imagePath != null && imagePath.isNotEmpty) {
      // Check if it's a local file path
      if (imagePath.startsWith('/') && !imagePath.startsWith('http')) {
        try {
          final file = File(imagePath);
          final bytes = await file.readAsBytes();
          imageBase64 = base64Encode(bytes);
        } catch (e) {
          // If file read fails, use the existing string (might already be base64)
          imageBase64 = imagePath;
        }
      } else {
        // Already base64 or URL, use as is
        imageBase64 = imagePath;
      }
    }

    final category = _editingCategory!.copyWith(
      name: _editNameController.text.trim(),
      nameAr: _editNameArController.text.trim().isEmpty
          ? null
          : _editNameArController.text.trim(),
      image: imageBase64,
      organizationId: organizationId,
    );

    final response = await _repository.updateCategory(category);

    state = state.copyWith(isLoading: false);

    if (!response.hasError) {
      await getCategories();
      resetEditForm();
    }

    return response;
  }

  Future<PostDataHandle> deleteCategory(int categoryId) async {
    state = state.copyWith(isLoading: true);

    final response = await _repository.deleteCategory(categoryId);

    state = state.copyWith(isLoading: false);

    if (!response.hasError) {
      await getCategories();
    }

    return response;
  }

  Future<void> pickCategoryImage(BuildContext context,
      {bool isEdit = false}) async {
    final imagePath = await AppImagePicker.pickImageWithSource(
      context: context,
    );

    if (imagePath != null) {
      // Check file size (1 MB = 1024 * 1024 bytes)
      try {
        final file = File(imagePath);
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
        setImagePath(imagePath, isEdit: isEdit);
      } catch (e) {
        AppSnackBar.show(
          message: AppMessage.errorCheckingImageSize,
          type: ToastType.error,
        );
      }
    }
  }

  void setImagePath(String? imagePath, {bool isEdit = false}) {
    if (isEdit) {
      _editSelectedImagePath = imagePath;
    } else {
      _addSelectedImagePath = imagePath;
    }
    state = state.copyWith(selectedImagePath: imagePath);
  }
}
