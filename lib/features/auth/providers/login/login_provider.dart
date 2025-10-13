import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/di/locator_providers.dart';
import 'login_notifier.dart';
import 'login_state.dart';

final loginProvider = StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
  ///pass di to notifier
  (ref) {
    final repo = ref.read(loginDi);
    return LoginNotifier(repo);
  },
);
