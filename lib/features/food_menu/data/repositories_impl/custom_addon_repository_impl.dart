import '../../../../core/constants/app_end_points.dart';
import '../../../../core/services/network/inetwork_services.dart';
import '../../../../core/model/data_handel.dart';

import '../../domain/models/custom_addon_model.dart';
import '../../domain/repositories/custom_addon_repository.dart';

class CustomAddonRepositoryImpl implements CustomAddonRepository {
  final INetworkServices networkService;

  CustomAddonRepositoryImpl({required this.networkService});

  @override
  Future<PostDataHandle<CustomAddonsModels>> getCustomAddons() {
    return networkService.get<CustomAddonsModels>(
        url: ApiEndPoints.getCustomAddonsUrl,
        fromJson: CustomAddonsModels.fromJson);
  }

  @override
  Future<PostDataHandle<BranchCustomAddonsResponse>> getBranchCustomAddons(
      int branchId) {
    return networkService.get<BranchCustomAddonsResponse>(
      url: ApiEndPoints.getBranchCustomAddonsUrl(branchId),
      fromJson: (json) {
        if (json.containsKey('data') && json['data'] != null) {
          return BranchCustomAddonsResponse.fromJson(json);
        }
        return BranchCustomAddonsResponse.fromJson(json);
      },
    );
  }

  @override
  Future<PostDataHandle<SingleAddon>> getCustomAddonById(int addonId) {
    return networkService.get<SingleAddon>(
        url: '${ApiEndPoints.getCustomAddonByIdUrl}/$addonId',
        fromJson: SingleAddon.fromJson);
  }

  @override
  Future<PostDataHandle<SingleAddon>> createCustomAddon(AddonsData addonDto) {
    return networkService.post<SingleAddon>(
      url: ApiEndPoints.createCustomAddonUrl,
      body: {
        'name': addonDto.name,
        'description': addonDto.description,
        'price': addonDto.price,
        'image_url': addonDto.imageUrl,
      },
      fromJson: SingleAddon.fromJson,
    );
  }

  @override
  Future<PostDataHandle<SingleAddon>> updateCustomAddon(AddonsData addon) {
    return networkService.put<SingleAddon>(
        url: ApiEndPoints.updateCustomAddonUrl,
        body: {
          'id': addon.id,
          'name': addon.name,
          'description': addon.description,
          'price': addon.price,
          'image_url': addon.imageUrl,
        },
        fromJson: SingleAddon.fromJson);
  }

  @override
  Future<PostDataHandle> assignCustomAddonToBranch({
    required int branchId,
    required int customAddonId,
  }) {
    return networkService.post(
      url: ApiEndPoints.createBranchCustomAddonUrl,
      body: {
        'branchId': branchId,
        'customAddonId': customAddonId,
      },
      fromJson: (json) => json,
    );
  }

  @override
  Future<PostDataHandle<BranchCustomAddonModel>> updateBranchCustomAddon({
    required int oldCustomAddonId,
    required int oldBranchId,
    required int newCustomAddonId,
    required int newBranchId,
  }) {
    return networkService.put<BranchCustomAddonModel>(
      url: ApiEndPoints.updateBranchCustomAddonUrl,
      body: {
        'oldCustomAddonId': oldCustomAddonId,
        'oldBranchId': oldBranchId,
        'newCustomAddonId': newCustomAddonId,
        'newBranchId': newBranchId,
      },
      fromJson: (json) {
        // Handle response structure: { "success": true, "data": {...} }
        if (json.containsKey('data') && json['data'] != null) {
          return BranchCustomAddonModel.fromJson(json['data']);
        }
        return BranchCustomAddonModel.fromJson(json);
      },
    );
  }

  @override
  Future<PostDataHandle> deleteBranchCustomAddon(int id) {
    return networkService.delete(
      url: ApiEndPoints.deleteBranchCustomAddonUrl(id),
      fromJson: (json) => json,
    );
  }

  @override
  Future<PostDataHandle> deleteCustomAddon(int addonId) {
    return networkService.delete(
        url: '${ApiEndPoints.deleteCustomAddonUrl}/$addonId',
        fromJson: (json) => json);
  }
}
