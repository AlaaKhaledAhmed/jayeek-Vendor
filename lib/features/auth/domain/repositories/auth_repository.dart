import '../../../../../core/model/data_handel.dart';

abstract interface class AuthRepository {
  ///we add all authentication function here
  Future<PostDataHandle<Map<String, dynamic>>> login({
    required String phone,
    required String password,
  });
  Future<PostDataHandle<bool>> singUp({
    required String name,
    required String supervisor,
    required String mobile,
    required String email,
    required String password,
  });
}
