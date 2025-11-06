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
