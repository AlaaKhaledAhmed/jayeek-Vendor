import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/locator_providers.dart';

import 'custom_addon_notifier.dart';
import 'custom_addon_state.dart';

final customAddonProvider =
    StateNotifierProvider.autoDispose<CustomAddonNotifier, CustomAddonState>(
  (ref) {
    final repository = ref.read(customAddonDi);
    return CustomAddonNotifier(repository);
  },
);
