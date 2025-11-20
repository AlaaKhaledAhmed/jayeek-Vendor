import '../../../../core/constants/app_end_points.dart';
import '../../../../core/model/data_handel.dart';
import '../../../../core/services/network/inetwork_services.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/vendor_model.dart';
import '../models/wallet_model.dart';

/// Real Implementation للـ Profile Repository
class ProfileRepositoryImpl implements ProfileRepository {
  final INetworkServices networkService;

  ProfileRepositoryImpl(this.networkService);

  @override
  Future<PostDataHandle<VendorModel>> getVendorProfile() async {
    try {
      final response = await networkService.get<VendorModel>(
        url: ApiEndPoints.getProfileUrl,
        fromJson: (json) {
          // Handle response structure: { "success": true, "data": {...} }
          if (json.containsKey('data') && json['data'] != null) {
            return VendorModel.fromJson(json['data']);
          }
          return VendorModel.fromJson(json);
        },
      );

      return response;
    } catch (e) {
      return PostDataHandle<VendorModel>(
        hasError: true,
        message: 'Failed to load profile: ${e.toString()}',
      );
    }
  }

  @override
  Future<PostDataHandle<VendorModel>> updateLogoImage({
    required String imageBase64,
  }) async {
    try {
      final body = <String, dynamic>{
        'imageBase64': imageBase64,
      };

      final response = await networkService.put<VendorModel>(
        url: ApiEndPoints.updateProfileUrl,
        body: body,
        fromJson: (json) {
          // Handle response structure: { "success": true, "data": {...} }
          if (json.containsKey('data') && json['data'] != null) {
            return VendorModel.fromJson(json['data']);
          }
          return VendorModel.fromJson(json);
        },
      );

      return response;
    } catch (e) {
      return PostDataHandle<VendorModel>(
        hasError: true,
        message: 'Failed to update logo image: ${e.toString()}',
      );
    }
  }

  @override
  Future<PostDataHandle<VendorModel>> updateCoverImage({
    required String coverBase64,
  }) async {
    try {
      final body = <String, dynamic>{
        'coverBase64': coverBase64,
      };

      final response = await networkService.put<VendorModel>(
        url: ApiEndPoints.updateProfileUrl,
        body: body,
        fromJson: (json) {
          // Handle response structure: { "success": true, "data": {...} }
          if (json.containsKey('data') && json['data'] != null) {
            return VendorModel.fromJson(json['data']);
          }
          return VendorModel.fromJson(json);
        },
      );

      return response;
    } catch (e) {
      return PostDataHandle<VendorModel>(
        hasError: true,
        message: 'Failed to update cover image: ${e.toString()}',
      );
    }
  }

  @override
  Future<PostDataHandle<WalletModel>> getWallet() async {
    // TODO: Implement when API is available
    return const PostDataHandle<WalletModel>(
      hasError: true,
      message: 'Not implemented yet',
    );
  }

  @override
  Future<PostDataHandle<List<TransactionModel>>> getTransactions({
    TransactionType? type,
    TransactionStatus? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    // TODO: Implement when API is available
    return const PostDataHandle<List<TransactionModel>>(
      hasError: true,
      message: 'Not implemented yet',
    );
  }

  @override
  Future<PostDataHandle<bool>> requestWithdrawal({
    required double amount,
    required String bankAccount,
  }) async {
    // TODO: Implement when API is available
    return const PostDataHandle<bool>(
      hasError: true,
      message: 'Not implemented yet',
    );
  }

  @override
  Future<PostDataHandle<bool>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    // TODO: Implement when API is available
    return const PostDataHandle<bool>(
      hasError: true,
      message: 'Not implemented yet',
    );
  }

  @override
  Future<PostDataHandle<bool>> updateWorkingHours({
    required String openTime,
    required String closeTime,
    required List<int> workingDays,
  }) async {
    // TODO: Implement when API is available
    return const PostDataHandle<bool>(
      hasError: true,
      message: 'Not implemented yet',
    );
  }

  @override
  Future<PostDataHandle<bool>> toggleRestaurantStatus({
    required bool isActive,
  }) async {
    // TODO: Implement when API is available
    return const PostDataHandle<bool>(
      hasError: true,
      message: 'Not implemented yet',
    );
  }
}
