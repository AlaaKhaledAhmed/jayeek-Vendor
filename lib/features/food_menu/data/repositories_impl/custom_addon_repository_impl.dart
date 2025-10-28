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
  Future<PostDataHandle<CustomAddonsModels>> getCustomAddonById(int addonId) {
    return networkService.get<CustomAddonsModels>(
        url: '${ApiEndPoints.getCustomAddonByIdUrl}/$addonId',
        requiresToken: true,
        fromJson: CustomAddonsModels.fromJson);
  }

  @override
  Future<PostDataHandle<CustomAddonsModels>> createCustomAddon(
      AddonsData addonDto) {
    return networkService.post<CustomAddonsModels>(
      url: ApiEndPoints.createCustomAddonUrl,
      body: addonDto.toJson(),
      fromJson: CustomAddonsModels.fromJson,
    );
  }

  @override
  Future<PostDataHandle<CustomAddonsModels>> updateCustomAddon(
      AddonsData addon) {
    // For now, use regular POST without multipart
    // You can implement multipart upload later
    return networkService.post<CustomAddonsModels>(
        url: ApiEndPoints.updateCustomAddonUrl,
        body: addon.toJson(),
        fromJson: CustomAddonsModels.fromJson);
  }

  @override
  Future<PostDataHandle<void>> deleteCustomAddon(int addonId) {
    return networkService.post<void>(
      url: '${ApiEndPoints.deleteCustomAddonUrl}/$addonId',
      fromJson: CustomAddonsModels.fromJson,
    );
  }
}
