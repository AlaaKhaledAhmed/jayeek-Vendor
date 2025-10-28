import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jayeek_vendor/core/util/print_info.dart';
import 'package:jayeek_vendor/core/services/image_picker_service.dart';
import 'package:jayeek_vendor/core/services/photo_permission_service.dart';

import '../../domain/models/custom_addon_model.dart';
import '../../domain/repositories/custom_addon_repository.dart';
import '../../../../core/constants/app_flow_sate.dart';
import '../../../../core/model/data_handel.dart';
import '../../../../core/domain/repositories/state_repository.dart';

import 'custom_addon_state.dart';

class CustomAddonNotifier extends StateNotifier<CustomAddonState>
    implements StateRepository {
  final CustomAddonRepository _repository;

  CustomAddonNotifier(this._repository) : super(const CustomAddonState());

  // Controllers for add/edit forms
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedUnitType = 'piece';
  String? _selectedImagePath;

  // Track original data for change detection
  CustomAddonModel? _originalAddon;
  String? _originalName;
  String? _originalDescription;
  String? _originalPrice;
  String? _originalUnitType;
  String? _originalImagePath;

  // Getters
  TextEditingController get nameController => _nameController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get priceController => _priceController;
  GlobalKey<FormState> get formKey => _formKey;
  String get selectedUnitType => _selectedUnitType;
  String? get selectedImagePath => _selectedImagePath;

  // Unit type options
  final List<String> unitTypes = ['piece', 'kilogram', 'gram'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  void resetState() {
    state = const CustomAddonState();
  }

  @override
  void loadData({bool? refresh}) async {
    if (refresh == true) {
      ///must add reset state here
      ///if not added, when user refresh data it will return the last data url
      getCustomAddons();
    } else {
      ///check if user upload date before or not
      ///if not upload data, we call api to get data
      ///if upload data, we don't call api again

      if (state.addonsData.data == null || state.addonsData.data!.isEmpty) {
        getCustomAddons();
      }
    }
  }

  /// get custom addons data=============================================================================================================================
  void getCustomAddons() async {
    ///loading state
    state = state.copyWith(
      addonsData: state.addonsData.copyWith(
        result: AppFlowState.loading,
      ),
    );

    ///api call
    final PostDataHandle<List<CustomAddonModel>> apiResponse =
        await _repository.getCustomAddons();
    printInfo('apiResponse: ${apiResponse.message}');

    ///if success
    if (!apiResponse.hasError) {
      ///save changed data
      state = state.copyWith(
        addonsData: state.addonsData.copyWith(
          result: AppFlowState.loaded,
          data: apiResponse.data,
        ),
      );
    }

    ///error response
    else {
      state = state.copyWith(
        addonsData: state.addonsData.copyWith(
          result: apiResponse.message ?? AppFlowState.error,
          data: const <CustomAddonModel>[],
        ),
      );
    }
  }

  Future<void> createAddon() async {
    if (!canSave()) {
      printInfo('No changes detected or form is invalid');
      return;
    }

    state = state.copyWith(isCreating: true, error: null);
    try {
      final addonDto = CreateAddonDto(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        unitType: _selectedUnitType,
        imageUrl: _selectedImagePath,
      );

      final PostDataHandle<CustomAddonModel> apiResponse =
          await _repository.createCustomAddon(addonDto);

      if (!apiResponse.hasError) {
        // Refresh the list after successful creation
        getCustomAddons();
        // Don't clear form here - let the UI handle navigation
        state = state.copyWith(isCreating: false);
        printInfo('Addon created successfully');
      } else {
        state = state.copyWith(
          isCreating: false,
          error: apiResponse.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateAddon(CustomAddonModel addon) async {
    if (!canSave()) {
      printInfo('No changes detected or form is invalid');
      return;
    }

    state = state.copyWith(isUpdating: true, error: null);
    try {
      final addonDto = UpdateAddonDto(
        id: addon.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        unitType: _selectedUnitType,
        imageUrl: _selectedImagePath,
      );

      final PostDataHandle<CustomAddonModel> apiResponse =
          await _repository.updateCustomAddon(addonDto);

      if (!apiResponse.hasError) {
        // Refresh the list after successful update
        getCustomAddons();
        // Don't clear form here - let the UI handle navigation
        state = state.copyWith(isUpdating: false);
        printInfo('Addon updated successfully');
      } else {
        state = state.copyWith(
          isUpdating: false,
          error: apiResponse.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteAddon(int addonId) async {
    state = state.copyWith(isDeleting: true, error: null);
    try {
      final PostDataHandle<void> apiResponse =
          await _repository.deleteCustomAddon(addonId);

      if (!apiResponse.hasError) {
        // Refresh the list after successful deletion
        getCustomAddons();
        state = state.copyWith(isDeleting: false);
        printInfo('Addon deleted successfully');
      } else {
        state = state.copyWith(
          isDeleting: false,
          error: apiResponse.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: e.toString(),
      );
    }
  }

  void setUnitType(String unitType) {
    _selectedUnitType = unitType;
  }

  void setImagePath(String? imagePath) {
    _selectedImagePath = imagePath;
    // Update state to notify UI about image change
    state = state.copyWith(selectedImagePath: imagePath);
  }

  // Check if data has changed
  bool hasDataChanged() {
    if (_originalAddon == null) {
      // For new addon, check if any field has data
      return _nameController.text.trim().isNotEmpty ||
          _descriptionController.text.trim().isNotEmpty ||
          _priceController.text.trim().isNotEmpty ||
          _selectedImagePath != null;
    } else {
      // For existing addon, check if any field has changed
      return _nameController.text.trim() != _originalName ||
          _descriptionController.text.trim() != _originalDescription ||
          _priceController.text.trim() != _originalPrice ||
          _selectedUnitType != _originalUnitType ||
          _selectedImagePath != _originalImagePath;
    }
  }

  // Check if form is valid and has changes
  bool canSave() {
    return _formKey.currentState?.validate() == true && hasDataChanged();
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      // Check photo permission first
      final granted = await AppPermissions.photoPermission(context: context);
      if (!granted) {
        printInfo('Photo permission denied');
        return;
      }

      // Pick image from gallery
      final imagePath = await AppImagePicker.pickFromGallery(imageQuality: 85);
      if (imagePath != null) {
        setImagePath(imagePath);
        printInfo('Image selected: $imagePath');
      }
    } catch (e) {
      printInfo('Error picking image: $e');
    }
  }

  void loadAddonForEdit(CustomAddonModel addon) {
    _originalAddon = addon;
    _originalName = addon.name;
    _originalDescription = addon.description;
    _originalPrice = addon.price.toString();
    _originalUnitType = addon.unitType;
    _originalImagePath = addon.imageUrl;

    _nameController.text = addon.name;
    _descriptionController.text = addon.description;
    _priceController.text = addon.price.toString();
    _selectedUnitType = addon.unitType;
    _selectedImagePath = addon.imageUrl;
  }

  void prepareForNewAddon() {
    _clearForm();
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _selectedUnitType = 'piece';
    _selectedImagePath = null;

    // Reset original data
    _originalAddon = null;
    _originalName = null;
    _originalDescription = null;
    _originalPrice = null;
    _originalUnitType = null;
    _originalImagePath = null;

    // Update state to clear image
    state = state.copyWith(selectedImagePath: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
