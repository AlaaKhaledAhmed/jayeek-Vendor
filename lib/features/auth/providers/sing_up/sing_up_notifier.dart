import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/model/data_handel.dart';
import '../../../../../core/util/print_info.dart';
import '../../domain/repositories/auth_repository.dart';
import 'sing_up_state.dart';

class SingUpNotifier extends StateNotifier<SingUpState> {
  final AuthRepository _repository;
  SingUpNotifier(this._repository) : super(const SingUpState());
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _supervisorController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get nameController => _nameController;
  TextEditingController get supervisorController => _supervisorController;
  TextEditingController get emailController => _emailController;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _supervisorController.dispose();
    _emailController.dispose();
    printInfo('dispose singup controller');
    super.dispose();
  }

  Future<PostDataHandle> singUp() async {
    ///show loading
    state = state.copyWith(isLoading: true);
    final PostDataHandle result = await _repository.singUp(
      password: _passwordController.text,
      mobile: _phoneController.text,
      name: _nameController.text,
      supervisor: _supervisorController.text,
      email: _emailController.text,
    );
    printInfo('result: ');

    state = state.copyWith(isLoading: false);

    return result;
  }
}
