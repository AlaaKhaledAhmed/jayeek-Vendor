class ApiEndPoints {
  static const String _appDomain = 'http://mkqadommi-007-site1.ktempurl.com';

  static const String _baseUrl = '$_appDomain/api';

  static const String loginUrl = '$_baseUrl/User/OrganizationLogin';
  static const String singUpUrl = '$_baseUrl/Signup';

  // Orders endpoints
  static const String ordersUrl = '$_baseUrl/Orders';

  // Custom Addon endpoints
  static const String getCustomAddonsUrl =
      '$_baseUrl/CustomAddon/get-custom-addon';
  static const String getCustomAddonByIdUrl =
      '$_baseUrl/CustomAddon/get-custom-addon';
  static const String createCustomAddonUrl =
      '$_baseUrl/CustomAddon/create-custom-addon';
  static const String updateCustomAddonUrl =
      '$_baseUrl/CustomAddon/update-custom-addon';
  static const String deleteCustomAddonUrl =
      '$_baseUrl/CustomAddon/delete-custom-addon';

  // Food Category endpoints
  static const String getFoodCategoriesUrl = '$_baseUrl/ItemCategory/get-all';
  static String getCategoriesWithItemsByBranchUrl(int branchId) =>
      '$_baseUrl/ItemCategory/get/$branchId';
  static const String createFoodCategoryUrl = '$_baseUrl/ItemCategory/create';
  static const String updateFoodCategoryUrl = '$_baseUrl/ItemCategory/update';
  static const String deleteFoodCategoryUrl = '$_baseUrl/ItemCategory/delete';

  // Menu Items endpoints
  static const String getMenuItemsUrl = '$_baseUrl/Item/get-all';
  static String getMenuItemByIdUrl(int itemId) =>
      '$_baseUrl/Item/get-item/$itemId';
  static const String createMenuItemUrl = '$_baseUrl/Item/create-item';
  static const String updateMenuItemUrl = '$_baseUrl/Item/update-item';
  static String deleteMenuItemUrl(int itemId) =>
      '$_baseUrl/Item/delete-item/$itemId';

  // Branch endpoints
  static String getBranchByIdUrl(int branchId) =>
      '$_baseUrl/Branch/get-branch-id/$branchId';

  // Profile endpoints
  static const String getProfileUrl = '$_baseUrl/UserDetails/branch-profile';
  static const String updateProfileUrl =
      '$_baseUrl/UserDetails/update-branch-profile';
}
