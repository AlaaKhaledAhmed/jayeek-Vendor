import '../models/custom_addon_model.dart';
import '../../../../core/model/data_handel.dart';

abstract interface class CustomAddonRepository {
  /// Get all custom add-ons
  Future<PostDataHandle<List<CustomAddonModel>>> getCustomAddons();

  /// Get a specific custom add-on by ID
  Future<PostDataHandle<CustomAddonModel>> getCustomAddonById(int addonId);

  /// Create a new custom add-on
  Future<PostDataHandle<CustomAddonModel>> createCustomAddon(
      CreateAddonDto addonDto);

  /// Update an existing custom add-on
  Future<PostDataHandle<CustomAddonModel>> updateCustomAddon(
      UpdateAddonDto addonDto);

  /// Delete a custom add-on
  Future<PostDataHandle<void>> deleteCustomAddon(int addonId);
}
