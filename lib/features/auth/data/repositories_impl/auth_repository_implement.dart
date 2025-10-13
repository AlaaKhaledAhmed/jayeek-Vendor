import '../../../../../core/constants/app_end_points.dart';
import '../../../../../core/model/data_handel.dart';
import '../../../../../core/services/network/inetwork_services.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImplementing implements AuthRepository {
  final INetworkServices networkService;
  AuthRepositoryImplementing({required this.networkService});

  ///Example of post data
  @override
  Future<PostDataHandle<bool>> login({
    required String phone,
    required String password,
  }) {
    return networkService.post<bool>(
      url: ApiEndPoints.loginUrl,
      requiresToken: false,
      body: {'mobile': phone, 'password': password},
    );
  }

  @override
  Future<PostDataHandle<bool>> singUp({
    required String name,
    required String supervisor,
    required String mobile,
    required String email,
    required String password,
  }) {
    return networkService.post<bool>(
      url: ApiEndPoints.singUpUrl,
      requiresToken: false,
      body: {
        "name": name,
        "supervisor": supervisor,
        "mobile": mobile,
        "email": email,
        "password": password,
      },
    );
  }
}
