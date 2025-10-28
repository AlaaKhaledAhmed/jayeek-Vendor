import '../../../../core/constants/app_end_points.dart';
import '../../../../core/services/network/inetwork_services.dart';
import '../../../../core/model/data_handel.dart';

import '../../domain/models/custom_addon_model.dart';
import '../../domain/repositories/custom_addon_repository.dart';

class CustomAddonRepositoryImpl implements CustomAddonRepository {
  final INetworkServices networkService;

  CustomAddonRepositoryImpl({required this.networkService});

  @override
  Future<PostDataHandle<List<CustomAddonModel>>> getCustomAddons() {
    return networkService.get<List<CustomAddonModel>>(
      url: ApiEndPoints.getCustomAddonsUrl,
      requiresToken: true,
      fromJson: (json) {
        if (json['success'] == true && json['data'] != null) {
          return (json['data'] as List)
              .map((item) => CustomAddonModel.fromJson(item))
              .toList();
        }
        return <CustomAddonModel>[];
      },
    );
  }

  @override
  Future<PostDataHandle<CustomAddonModel>> getCustomAddonById(int addonId) {
    return networkService.get<CustomAddonModel>(
      url: '${ApiEndPoints.getCustomAddonByIdUrl}/$addonId',
      requiresToken: true,
      fromJson: (json) {
        if (json['success'] == true && json['data'] != null) {
          return CustomAddonModel.fromJson(json['data']);
        }
        throw Exception('Add-on not found');
      },
    );
  }

  @override
  Future<PostDataHandle<CustomAddonModel>> createCustomAddon(
      CreateAddonDto addonDto) {
    // For now, use regular POST without multipart
    // You can implement multipart upload later
    return networkService.post<CustomAddonModel>(
      url: ApiEndPoints.createCustomAddonUrl,
      requiresToken: true,
      body: addonDto.toJson(),
      fromJson: (json) {
        if (json['success'] == true && json['data'] != null) {
          return CustomAddonModel.fromJson(json['data']);
        }
        throw Exception('Failed to create add-on');
      },
    );
  }

  @override
  Future<PostDataHandle<CustomAddonModel>> updateCustomAddon(
      UpdateAddonDto addonDto) {
    // For now, use regular POST without multipart
    // You can implement multipart upload later
    return networkService.post<CustomAddonModel>(
      url: ApiEndPoints.updateCustomAddonUrl,
      requiresToken: true,
      body: addonDto.toJson(),
      fromJson: (json) {
        if (json['success'] == true && json['data'] != null) {
          return CustomAddonModel.fromJson(json['data']);
        }
        throw Exception('Failed to update add-on');
      },
    );
  }

  @override
  Future<PostDataHandle<void>> deleteCustomAddon(int addonId) {
    return networkService.post<void>(
      url: '${ApiEndPoints.deleteCustomAddonUrl}/$addonId',
      requiresToken: true,
      fromJson: (json) {
        if (json['success'] == true) {
          return null;
        }
        throw Exception('Failed to delete add-on');
      },
    );
  }
}
