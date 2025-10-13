import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/di/locator_providers.dart';
import 'sing_up_notifier.dart';
import 'sing_up_state.dart';

final singUpProvider = StateNotifierProvider.autoDispose<SingUpNotifier, SingUpState>(
  ///pass di to notifier
  (ref) {
    final repo = ref.read(loginDi);
    return SingUpNotifier(repo);
  },
);
