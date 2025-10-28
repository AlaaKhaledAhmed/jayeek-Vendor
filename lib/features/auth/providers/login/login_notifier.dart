import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayeek_vendor/core/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/model/data_handel.dart';
import '../../../../../core/util/print_info.dart';
import '../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthRepository _repository;
  LoginNotifier(this._repository) : super(const LoginState());
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get passwordController => _passwordController;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    printInfo('dispose phone');
    super.dispose();
  }

  Future<PostDataHandle<Map<String, dynamic>>> login() async {
    ///show loading
    state = state.copyWith(isLoading: true);
    final PostDataHandle<Map<String, dynamic>> result = await _repository.login(
      phone: _phoneController.text,
      password: _passwordController.text,
    );
    state = state.copyWith(isLoading: false);

    ///save token
    if (!result.hasError) {
      SharedPreferencesService.saveToken(token: result.data?['data']['token']);
    }

    return result;
  }

  ///logout function
  Future<void> logout() async {
    await SharedPreferencesService.clearCache();
  }
}
