import 'package:jayeek_vendor/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/print_info.dart';

class SharedPreferencesService {
  ///mack class singleton

  static Future<void> saveToken({required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    final x = await prefs.setString(AppConstants.token, token);
    printInfo('token: $x');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(AppConstants.token);
  }

  static Future<void> saveLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final x = await prefs.setString(AppConstants.saveLogin, 'save');
    printInfo('save login: $x');
  }

  static Future<String?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    printInfo('get login: ${prefs.getString(AppConstants.saveLogin)}');
    return prefs.getString(AppConstants.saveLogin);
  }

  static Future<void> removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(AppConstants.saveLogin);
  }

  ///clear all cache
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<void> saveOrganizationId({required int organizationId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.organizationId, organizationId);
    printInfo('organizationId saved: $organizationId');
  }

  static Future<int?> getOrganizationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.organizationId);
  }

  static Future<void> saveBranchId({required int branchId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.branchId, branchId);
    printInfo('branchId saved: $branchId');
  }

  static Future<int?> getBranchId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.branchId);
  }
}
