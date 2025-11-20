import '../../../../core/constants/app_end_points.dart';
import '../../../../core/model/data_handel.dart';
import '../../../../core/services/network/inetwork_services.dart';
import '../../domain/models/branch_response.dart';
import '../../domain/models/food_category_model.dart';
import '../../domain/models/menu_item_model.dart';
import '../../domain/models/menu_items_response.dart';
import '../../domain/repositories/food_repository.dart';

class FoodRepositoryImpl implements FoodRepository {
  final INetworkServices networkService;

  FoodRepositoryImpl({required this.networkService});

  @override
  Future<PostDataHandle<MenuItemModel>> getMenuItemById(int itemId) async {
    try {
      return networkService.get<MenuItemModel>(
        url: ApiEndPoints.getMenuItemByIdUrl(itemId),
        fromJson: (json) {
          if (json.containsKey('data') && json['data'] != null) {
            return MenuItemModel.fromJson(json['data'] as Map<String, dynamic>);
          }
          return MenuItemModel.fromJson(json);
        },
      );
    } catch (e) {
      return PostDataHandle<MenuItemModel>(
        hasError: true,
        message: 'فشل في جلب بيانات الصنف: ${e.toString()}',
      );
    }
  }

  @override
  Future<PostDataHandle<MenuItemModel>> createMenuItem(
    Map<String, dynamic> body,
  ) async {
    return networkService.post<MenuItemModel>(
      url: ApiEndPoints.createMenuItemUrl,
      body: body,
      fromJson: MenuItemModel.fromJson,
    );
  }

  @override
  Future<PostDataHandle<MenuItemModel>> updateMenuItem(
    Map<String, dynamic> body,
  ) async {
    try {
      return networkService.put<MenuItemModel>(
        url: ApiEndPoints.updateMenuItemUrl,
        body: body,
        fromJson: MenuItemModel.fromJson,
      );
    } catch (e) {
      return PostDataHandle<MenuItemModel>(
        hasError: true,
        message: 'فشل في تحديث الصنف: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteMenuItem(String id) async {
    final itemId = int.tryParse(id);
    if (itemId == null) {
      throw Exception('Invalid item ID: $id');
    }

    await networkService.delete(
      url: ApiEndPoints.deleteMenuItemUrl(itemId),
      fromJson: (json) => json,
    );
  }

  @override
  Future<PostDataHandle<FoodCategoriesResponse>> getFoodCategories() {
    return networkService.get<FoodCategoriesResponse>(
      url: ApiEndPoints.getFoodCategoriesUrl,
      fromJson: FoodCategoriesResponse.fromJson,
    );
  }

  @override
  Future<PostDataHandle<FoodCategoriesResponse>> getCategoriesWithItemsByBranch(
      int branchId) {
    return networkService.get<FoodCategoriesResponse>(
      url: ApiEndPoints.getCategoriesWithItemsByBranchUrl(branchId),
      fromJson: FoodCategoriesResponse.fromJson,
    );
  }

  @override
  Future<PostDataHandle<MenuItemsResponse>> getMenuItemsByCategoryId(
      int categoryId) {
    return networkService.get<MenuItemsResponse>(
      url: ApiEndPoints.getMenuItemsUrl,
      queryParams: {'categoryId': categoryId},
      fromJson: MenuItemsResponse.fromJson,
    );
  }

  @override
  Future<PostDataHandle<BranchResponse>> getBranchItems(int branchId) {
    return networkService.get<BranchResponse>(
      url: ApiEndPoints.getBranchByIdUrl(branchId),
      fromJson: BranchResponse.fromJson,
    );
  }

  @override
  Future<PostDataHandle<FoodCategoryModel>> createCategory(
      FoodCategoryModel category) {
    // Prepare body with correct field names for API
    final body = <String, dynamic>{
      'name': category.name,
      'nameAr': category.nameAr,
      'organizationId': category.organizationId ?? 0,
    };

    // Add image as contentBase64 if available
    if (category.image != null && category.image!.isNotEmpty) {
      body['contentBase64'] = category.image;
    }

    // Add iconCode if available
    if (category.iconCode != null && category.iconCode!.isNotEmpty) {
      body['iconCode'] = category.iconCode;
    }

    return networkService.post<FoodCategoryModel>(
      url: ApiEndPoints.createFoodCategoryUrl,
      body: body,
      fromJson: (json) {
        // Handle response that may not have data field
        if (json.containsKey('data') && json['data'] != null) {
          return FoodCategoryModel.fromJson(json['data']);
        } else if (json.containsKey('success') && json['success'] == true) {
          // Response only has success message, return empty model
          return FoodCategoryModel();
        }
        return FoodCategoryModel.fromJson(json);
      },
    );
  }

  @override
  Future<PostDataHandle<FoodCategoryModel>> updateCategory(
      FoodCategoryModel category) {
    // Prepare body with correct field names for API
    final body = <String, dynamic>{
      'id': category.id ?? 0,
      'name': category.name,
      'nameAr': category.nameAr,
      'organizationId': category.organizationId ?? 0,
      'removeImage': false,
    };

    // Add image as contentBase64 if available
    if (category.image != null && category.image!.isNotEmpty) {
      body['contentBase64'] = category.image;
    }

    // Add iconCode if available
    if (category.iconCode != null && category.iconCode!.isNotEmpty) {
      body['iconCode'] = category.iconCode;
    }

    return networkService.put<FoodCategoryModel>(
      url: ApiEndPoints.updateFoodCategoryUrl,
      body: body,
      fromJson: (json) {
        // Handle response that may not have data field
        if (json.containsKey('data') && json['data'] != null) {
          return FoodCategoryModel.fromJson(json['data']);
        } else if (json.containsKey('success') && json['success'] == true) {
          // Response only has success message, return empty model
          return FoodCategoryModel();
        }
        return FoodCategoryModel.fromJson(json);
      },
    );
  }

  @override
  Future<PostDataHandle> deleteCategory(int categoryId) {
    return networkService.delete(
      url: ApiEndPoints.deleteFoodCategoryUrl,
      queryParams: {'itemCategoryId': categoryId},
      fromJson: (json) => json,
    );
  }
}
