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
  // Unit type options
  final List<String> unitTypes = ['piece', 'kilogram', 'gram'];
  // Getters
  TextEditingController get nameController => _nameController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get priceController => _priceController;
  GlobalKey<FormState> get formKey => _formKey;
  String get selectedUnitType => _selectedUnitType;
  String? get selectedImagePath => _selectedImagePath;

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

      if (state.addonsData.data == null) {
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
    final PostDataHandle<CustomAddonsModels> apiResponse =
        await _repository.getCustomAddons();

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
          data: const CustomAddonsModels(),
        ),
      );
    }
  }

  ///create addons=====================================================================================================================
  Future<PostDataHandle<SingleAddon>> createAddon() async {
    final addonDto = AddonsData(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      imageUrl: _selectedImagePath,
    );
    state = state.copyWith(isLoading: true);
    final PostDataHandle<SingleAddon> apiResponse =
        await _repository.createCustomAddon(addonDto);
    state = state.copyWith(isLoading: false);

    return apiResponse;
  }

  ///update addons===========================================================================================================================
  Future<PostDataHandle<SingleAddon>> updateAddon(int id) async {
    final addonDto = AddonsData(
      id: id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      imageUrl: _selectedImagePath,
    );
    state = state.copyWith(isLoading: true);
    final PostDataHandle<SingleAddon> apiResponse =
        await _repository.updateCustomAddon(addonDto);
    state = state.copyWith(isLoading: false);
    return apiResponse;
  }

  ///delete addons===========================================================================================================================
  Future<PostDataHandle<bool>> deleteAddon(int addonId) async {
    state = state.copyWith(isLoading: true);
    final PostDataHandle<bool> apiResponse =
        await _repository.deleteCustomAddon(addonId);
    state = state.copyWith(isLoading: false);

    // Refresh the list after successful deletion
    if (!apiResponse.hasError) {
      getCustomAddons();
    }

    return apiResponse;
  }

  ///set unit==========================================================================================================================
  void setUnitType(String unitType) {
    _selectedUnitType = unitType;
  }

  ///set image path===========================================================================================================================
  void setImagePath(String? imagePath) {
    _selectedImagePath = imagePath;

    /// Update state to notify UI about image change
    state = state.copyWith(selectedImagePath: imagePath);
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

  ///load addon for edit===========================================================================================================================
  void loadAddonForEdit(AddonsData addon) {
    _nameController.text = addon.name!;
    _descriptionController.text = addon.description!;
    _priceController.text = addon.price.toString();
    _selectedUnitType = 'piece';
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

    /// Update state to clear image
    state = state.copyWith(selectedImagePath: null);
  }
}
