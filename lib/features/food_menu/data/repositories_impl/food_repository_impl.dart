import '../../../../core/services/network/inetwork_services.dart';
import '../../domain/models/menu_item_model.dart';
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
            'https://images.unsplash.com/photo-1548365328-9f547fb09530?w=1200',
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
            'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=1200',
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
}
