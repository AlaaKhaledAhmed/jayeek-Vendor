import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/locator_providers.dart';
import 'profile_notifier.dart';
import 'profile_state.dart';

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileNotifier, ProfileState>(
  (ref) {
    final repo = ref.read(profileDi);
    return ProfileNotifier(repo);
  },
);

