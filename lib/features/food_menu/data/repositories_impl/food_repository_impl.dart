import '../../../../core/constants/app_end_points.dart';
import '../../../../core/model/data_handel.dart';
import '../../../../core/services/network/inetwork_services.dart';
import '../../domain/models/branch_response.dart';
import '../../domain/models/food_category_model.dart';
import '../../domain/models/menu_item_model.dart';
import '../../domain/models/menu_items_response.dart';
import '../../domain/repositories/food_repository.dart';
import '../../providers/add_item_state.dart';
import 'dart:io';
import 'dart:convert';

class FoodRepositoryImpl implements FoodRepository {
  final INetworkServices networkService;

  FoodRepositoryImpl({required this.networkService});

  @override
  Future<PostDataHandle<MenuItemModel>> getMenuItemById(int itemId) async {
    try {
      return networkService.get<MenuItemModel>(
        url: ApiEndPoints.getMenuItemByIdUrl(itemId),
        fromJson: (json) {
          // The API returns {success: true, data: {...}, message: null}
          // response.data is the full response object
          // Check if response has 'data' key
          if (json.containsKey('data') && json['data'] != null) {
            return MenuItemModel.fromJson(json['data'] as Map<String, dynamic>);
          }
          // If no 'data' key, maybe the response is the data itself
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
    MenuItemModel menuItem,
    List<AddonGroup> addonGroups,
  ) async {
    try {
      // Convert image to base64 if it's a local file
      String? imageBase64;
      if (menuItem.imageUrl.isNotEmpty) {
        if (menuItem.imageUrl.startsWith('/') &&
            !menuItem.imageUrl.startsWith('http')) {
          // It's a local file path, convert to base64
          try {
            final file = File(menuItem.imageUrl);
            final bytes = await file.readAsBytes();
            imageBase64 = base64Encode(bytes);
          } catch (e) {
            // If file read fails, use the existing string (might already be base64)
            imageBase64 = menuItem.imageUrl;
          }
        } else if (menuItem.imageUrl.startsWith('http')) {
          // It's a URL, send as is (backend should handle it)
          imageBase64 = menuItem.imageUrl;
        } else {
          // Already base64, use as is
          imageBase64 = menuItem.imageUrl;
        }
      }

      // Process addon groups - each group becomes an addon with its items as addonOptions
      final List<Map<String, dynamic>> processedAddons = [];
      if (menuItem.isCustomizable && addonGroups.isNotEmpty) {
        for (var group in addonGroups) {
          if (group.items.isEmpty) continue;

          // Process addon options from group items
          final List<Map<String, dynamic>> addonOptions = [];
          for (var item in group.items) {
            addonOptions.add({
              'id': 0, // Backend will generate
              'name': item.name,
              'price': double.tryParse(item.price) ?? 0.0,
            });
          }

          // Use first item's data for the addon main info
          final firstItem = group.items.first;

          // Convert addon image to base64 if it's a local file
          String? addonImageBase64;
          if (firstItem.image != null && firstItem.image!.isNotEmpty) {
            if (firstItem.image!.startsWith('/') &&
                !firstItem.image!.startsWith('http')) {
              try {
                final file = File(firstItem.image!);
                final bytes = await file.readAsBytes();
                addonImageBase64 = base64Encode(bytes);
              } catch (e) {
                addonImageBase64 = firstItem.image;
              }
            } else {
              addonImageBase64 = firstItem.image;
            }
          }

          final addonMap = <String, dynamic>{
            'name': group.title,
            'price': double.tryParse(firstItem.price) ?? 0.0,
            'addonType': 'none', // Fixed as per API spec
            'addonOptions': addonOptions,
          };

          // Add contentBase64 only if there's an image
          if (addonImageBase64 != null && addonImageBase64.isNotEmpty) {
            addonMap['contentBase64'] = addonImageBase64;
          }

          processedAddons.add(addonMap);
        }
      }

      // Prepare request body with fixed values
      final body = <String, dynamic>{
        'unitId': 0, // Fixed as per requirement
        'itemCategoryId': int.tryParse(menuItem.category) ?? 0,
        'name': menuItem.name,
        'details': menuItem.description,
        'price': menuItem.price,
        'size': 0, // Fixed as per requirement
        'allBranches': true, // Fixed as per requirement
        'isActive': menuItem.isAvailable,
        'isCustomizable': menuItem.isCustomizable,
        'addons': processedAddons,
      };

      // Add contentBase64 only if there's an image
      if (imageBase64 != null && imageBase64.isNotEmpty) {
        body['contentBase64'] = imageBase64;
      }

      return networkService.post<MenuItemModel>(
        url: ApiEndPoints.createMenuItemUrl,
        body: body,
        fromJson: MenuItemModel.fromJson,
      );
    } catch (e) {
      return PostDataHandle<MenuItemModel>(
        hasError: true,
        message: 'فشل في إضافة الصنف: ${e.toString()}',
      );
    }
  }

  @override
  Future<PostDataHandle<MenuItemModel>> updateMenuItem(
    MenuItemModel menuItem,
    List<AddonGroup> addonGroups,
  ) async {
    try {
      // Convert image to base64 if it's a local file
      String? imageBase64;
      if (menuItem.imageUrl.isNotEmpty) {
        if (menuItem.imageUrl.startsWith('/') &&
            !menuItem.imageUrl.startsWith('http')) {
          // It's a local file path, convert to base64
          try {
            final file = File(menuItem.imageUrl);
            final bytes = await file.readAsBytes();
            imageBase64 = base64Encode(bytes);
          } catch (e) {
            // If file read fails, use the existing string (might already be base64)
            imageBase64 = menuItem.imageUrl;
          }
        } else if (menuItem.imageUrl.startsWith('http')) {
          // It's a URL, don't send it (image already exists on server)
          imageBase64 = null;
        } else {
          // Already base64, use as is
          imageBase64 = menuItem.imageUrl;
        }
      }

      // Process addon groups - each group becomes an addon with its items as addonOptions
      final List<Map<String, dynamic>> processedAddons = [];
      if (menuItem.isCustomizable && addonGroups.isNotEmpty) {
        for (var group in addonGroups) {
          if (group.items.isEmpty) continue;

          // Process addon options from group items
          final List<Map<String, dynamic>> addonOptions = [];
          for (var item in group.items) {
            addonOptions.add({
              'id': 0, // Backend will generate
              'name': item.name,
              'price': double.tryParse(item.price) ?? 0.0,
            });
          }

          // Use first item's data for the addon main info
          final firstItem = group.items.first;

          // Convert addon image to base64 if it's a local file
          String? addonImageBase64;
          if (firstItem.image != null && firstItem.image!.isNotEmpty) {
            if (firstItem.image!.startsWith('/') &&
                !firstItem.image!.startsWith('http')) {
              try {
                final file = File(firstItem.image!);
                final bytes = await file.readAsBytes();
                addonImageBase64 = base64Encode(bytes);
              } catch (e) {
                addonImageBase64 = firstItem.image;
              }
            } else if (firstItem.image!.startsWith('http')) {
              // It's a URL, don't send it
              addonImageBase64 = null;
            } else {
              addonImageBase64 = firstItem.image;
            }
          }

          final addonMap = <String, dynamic>{
            'name': group.title,
            'price': double.tryParse(firstItem.price) ?? 0.0,
            'addonType': 'none', // Fixed as per API spec
            'addonOptions': addonOptions,
          };

          // Add contentBase64 only if there's an image
          if (addonImageBase64 != null && addonImageBase64.isNotEmpty) {
            addonMap['contentBase64'] = addonImageBase64;
          }

          processedAddons.add(addonMap);
        }
      }

      // Prepare request body with fixed values
      final body = <String, dynamic>{
        'itemId': int.tryParse(menuItem.id) ?? 0, // Required for update
        'unitId': 0, // Fixed as per requirement
        'itemCategoryId': int.tryParse(menuItem.category) ?? 0,
        'name': menuItem.name,
        'details': menuItem.description,
        'price': menuItem.price,
        'size': 0, // Fixed as per requirement
        'allBranches': true, // Fixed as per requirement
        'isActive': menuItem.isAvailable,
        'isCustomizable': menuItem.isCustomizable,
        'addons': processedAddons,
        'removeImage': false, // Don't remove existing image
      };

      // Add contentBase64 only if there's a new image
      if (imageBase64 != null && imageBase64.isNotEmpty) {
        body['contentBase64'] = imageBase64;
      }

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
  Future<void> addFoodItem(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1)); // mock API
  }

  @override
  Future<void> updateFoodItem(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1)); // mock API
  }

  @override
  Future<void> deleteMenuItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 500)); // mock API
    // In real implementation, this would make a DELETE request to the server
    // await networkService.delete(url: '/menu-items/$id');
  }

  @override
  Future<List<MenuItemModel>> getMenuItems() async {
    // Simulate API fetch - replace with actual network call
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      const MenuItemModel(
        id: '1',
        name: 'Cheese Burger',
        description: 'لحم بقري، جبنة شيدر، خس وطماطم مع صوص خاص.',
        imageUrl:
            'https://images.unsplash.com/photo-1550317138-10000687a72b?w=1200',
        price: 18.0,
        isAvailable: true,
        isFeatured: true,
        category: 'Burgers',
      ),
      const MenuItemModel(
        id: '2',
        name: 'Chicken Alfredo Pasta',
        description: 'باستا كريمية مع دجاج مشوي وفطر.',
        imageUrl:
            'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=1200',
        price: 24.5,
        isAvailable: true,
        isFeatured: false,
        category: 'Pasta',
      ),
      const MenuItemModel(
        id: '3',
        name: 'Pepperoni Pizza',
        description: 'بيتزا مغطاة بشرائح البيبروني وجبنة موزاريلا.',
        imageUrl:
            'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
        price: 36.0,
        isAvailable: false,
        isFeatured: true,
        category: 'Pizza',
      ),
      const MenuItemModel(
        id: '4',
        name: 'Greek Salad',
        description: 'سلطة منعشة بخيار وطماطم وزيتون وجبنة فيتا.',
        imageUrl:
            'https://images.unsplash.com/photo-1569760142069-bc6838de16c1?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1074',
        price: 14.0,
        isAvailable: true,
        isFeatured: false,
        category: 'Salads',
      ),
    ];
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ['Burgers', 'Pasta', 'Pizza', 'Salads', 'Desserts', 'Drinks'];
  }

  @override
  Future<void> addCategory(String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<List<String>> getBranches() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ['فرع الرياض', 'فرع جدة'];
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

    return networkService.post<FoodCategoryModel>(
      url: ApiEndPoints.createFoodCategoryUrl,
      body: body,
      fromJson: FoodCategoryModel.fromJson,
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

    return networkService.put<FoodCategoryModel>(
      url: ApiEndPoints.updateFoodCategoryUrl,
      body: body,
      fromJson: FoodCategoryModel.fromJson,
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
