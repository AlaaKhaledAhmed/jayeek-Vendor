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
  Future<PostDataHandle> deleteCustomAddon(int addonId) {
    return networkService.delete(
        url: '${ApiEndPoints.deleteCustomAddonUrl}/$addonId',
        fromJson: (json) => json);
  }
}
