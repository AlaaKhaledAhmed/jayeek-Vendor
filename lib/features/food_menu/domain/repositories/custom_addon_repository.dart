import '../models/custom_addon_model.dart';
import '../../../../core/model/data_handel.dart';

abstract interface class CustomAddonRepository {
  /// Get all custom add-ons
  Future<PostDataHandle<CustomAddonsModels>> getCustomAddons();

  /// Get a specific custom add-on by ID
  Future<PostDataHandle<SingleAddon>> getCustomAddonById(int addonId);

  /// Create a new custom add-on
  Future<PostDataHandle<SingleAddon>> createCustomAddon(AddonsData addonDto);

  /// Update an existing custom add-on
  Future<PostDataHandle<SingleAddon>> updateCustomAddon(AddonsData addonDto);

  /// Delete a custom add-on
  Future<PostDataHandle<SingleAddon>> deleteCustomAddon(int addonId);
}
