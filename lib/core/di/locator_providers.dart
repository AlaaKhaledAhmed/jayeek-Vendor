import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayeek_vendor/features/food_menu/data/repositories_impl/food_repository_impl.dart';
import 'package:jayeek_vendor/features/food_menu/domain/repositories/food_repository.dart';
import '../../features/auth/data/repositories_impl/auth_repository_implement.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../services/network/dio_network_service.dart';
import '../services/network/inetwork_services.dart';

// NearPay

/// Dio instance
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

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
  (ref) =>
      FoodRepositoryImpl(networkService: ref.read(networkServicesDi)),
);
