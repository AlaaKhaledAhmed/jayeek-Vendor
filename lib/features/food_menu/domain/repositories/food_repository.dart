import '../models/menu_item_model.dart';

abstract class FoodRepository {
  Future<void> addFoodItem(Map<String, dynamic> data);
  Future<void> updateFoodItem(Map<String, dynamic> data);
  Future<List<MenuItemModel>> getMenuItems();
  Future<List<String>> getCategories();
  Future<void> addCategory(String name);
  Future<List<String>> getBranches();
}
