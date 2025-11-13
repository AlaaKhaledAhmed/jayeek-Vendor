import '../../../../core/model/data_handel.dart';
import '../models/branch_response.dart';
import '../models/food_category_model.dart';
import '../models/menu_item_model.dart';
import '../models/menu_items_response.dart';

abstract class FoodRepository {
  Future<PostDataHandle<MenuItemModel>> getMenuItemById(int itemId);
  Future<PostDataHandle<MenuItemModel>> createMenuItem(
    Map<String, dynamic> body,
  );
  Future<PostDataHandle<MenuItemModel>> updateMenuItem(
    Map<String, dynamic> body,
  );
  Future<void> deleteMenuItem(String id);
  Future<PostDataHandle<MenuItemsResponse>> getMenuItemsByCategoryId(
      int categoryId);
  Future<PostDataHandle<BranchResponse>> getBranchItems(int branchId);
  Future<PostDataHandle<FoodCategoriesResponse>> getFoodCategories();
  Future<PostDataHandle<FoodCategoriesResponse>> getCategoriesWithItemsByBranch(
      int branchId);
  Future<PostDataHandle<FoodCategoryModel>> createCategory(
      FoodCategoryModel category);
  Future<PostDataHandle<FoodCategoryModel>> updateCategory(
      FoodCategoryModel category);
  Future<PostDataHandle> deleteCategory(int categoryId);
}
