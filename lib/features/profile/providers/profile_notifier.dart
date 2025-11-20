import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const ProfileState());

  Future<void> loadProfile() async {
    state = state.copyWith(
      isLoading: true,
    );

    final response = await _repository.getVendorProfile();

    if (!response.hasError && response.data != null) {
      state = state.copyWith(
        isLoading: false,
        vendor: response.data,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.message ?? 'Failed to load profile',
      );
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }

  Future<bool> updateLogoImage({
    required String imageBase64,
  }) async {
    state = state.copyWith(isLoading: true);

    final response = await _repository.updateLogoImage(
      imageBase64: imageBase64,
    );

    state = state.copyWith(isLoading: false);

    if (!response.hasError && response.data != null) {
      // Update vendor data with new logo
      state = state.copyWith(
        vendor: response.data,
        error: null,
      );
      return true;
    } else {
      state = state.copyWith(
        error: response.message ?? 'Failed to update logo image',
      );
      return false;
    }
  }

  Future<bool> updateCoverImage({
    required String coverBase64,
  }) async {
    state = state.copyWith(isLoading: true);

    final response = await _repository.updateCoverImage(
      coverBase64: coverBase64,
    );

    state = state.copyWith(isLoading: false);

    if (!response.hasError && response.data != null) {
      // Update vendor data with new cover image
      state = state.copyWith(
        vendor: response.data,
        error: null,
      );
      return true;
    } else {
      state = state.copyWith(
        error: response.message ?? 'Failed to update cover image',
      );
      return false;
    }
  }
}
