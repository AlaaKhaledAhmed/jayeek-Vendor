import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayeek_vendor/features/food_menu/data/repositories_impl/food_repository_impl.dart';
import 'package:jayeek_vendor/features/food_menu/domain/repositories/food_repository.dart';
import 'package:jayeek_vendor/features/food_menu/data/repositories_impl/custom_addon_repository_impl.dart';
import 'package:jayeek_vendor/features/food_menu/domain/repositories/custom_addon_repository.dart';
import 'package:jayeek_vendor/features/orders/data/repositories_impl/mock_orders_repository_impl.dart';
import 'package:jayeek_vendor/features/orders/data/repositories_impl/orders_repository_impl.dart';
import 'package:jayeek_vendor/features/orders/domain/repositories/orders_repository.dart';
import '../../features/auth/data/repositories_impl/auth_repository_implement.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/profile/data/repositories_impl/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../constants/app_config.dart';
import '../services/network/dio_network_service.dart';
import '../services/network/inetwork_services.dart';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';

// NearPay

/// Dio instance
final dioProvider =
Provider<Dio>((ref) => Dio()..interceptors.add(AwesomeDioInterceptor()));

/// Network services (Dio)
final networkServicesDi = Provider<INetworkServices>(
  (ref) => DioNetworkService(ref.read(dioProvider)),
);

// Transaction repository
final dioNetworkServiceProvider = Provider<DioNetworkService>(
  (ref) => DioNetworkService(ref.read(dioProvider)),
);

final loginDi = Provider<AuthRepository>(
  (ref) =>
      AuthRepositoryImplementing(networkService: ref.read(networkServicesDi)),
);
final foodDi = Provider<FoodRepository>(
  (ref) => FoodRepositoryImpl(networkService: ref.read(networkServicesDi)),
);

final customAddonDi = Provider<CustomAddonRepository>(
  (ref) =>
      CustomAddonRepositoryImpl(networkService: ref.read(networkServicesDi)),
);

/// Orders Repository
/// يتم التبديل بين البيانات الحقيقية والوهمية حسب إعدادات AppConfig
final ordersDi = Provider<OrdersRepository>(
  (ref) {
    if (AppConfig.useMockData) {
      // استخدام البيانات الوهمية (Mock Data)
      return MockOrdersRepositoryImpl();
    } else {
      // استخدام البيانات الحقيقية من الـ API
      return OrdersRepositoryImpl(networkService: ref.read(networkServicesDi));
    }
  },
);

/// Profile Repository
final profileDi = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.read(networkServicesDi)),
);
