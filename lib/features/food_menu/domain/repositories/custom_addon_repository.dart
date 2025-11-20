import '../models/custom_addon_model.dart';
import '../../../../core/model/data_handel.dart';

abstract interface class CustomAddonRepository {
  /// Get all custom add-ons (for organization)
  Future<PostDataHandle<CustomAddonsModels>> getCustomAddons();

  /// Get branch custom add-ons
  Future<PostDataHandle<BranchCustomAddonsResponse>> getBranchCustomAddons(
      int branchId);

  /// Get a specific custom add-on by ID
  Future<PostDataHandle<SingleAddon>> getCustomAddonById(int addonId);

  /// Create a new custom add-on
  Future<PostDataHandle<SingleAddon>> createCustomAddon(AddonsData addonDto);

  /// Assign custom addon to branch
  Future<PostDataHandle> assignCustomAddonToBranch({
    required int branchId,
    required int customAddonId,
  });

  /// Update branch custom addon
  Future<PostDataHandle<BranchCustomAddonModel>> updateBranchCustomAddon({
    required int oldCustomAddonId,
    required int oldBranchId,
    required int newCustomAddonId,
    required int newBranchId,
  });

  /// Update an existing custom add-on
  Future<PostDataHandle<SingleAddon>> updateCustomAddon(AddonsData addonDto);

  /// Delete a custom add-on
  Future<PostDataHandle> deleteCustomAddon(int addonId);
}
