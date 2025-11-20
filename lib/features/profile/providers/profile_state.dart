import 'package:equatable/equatable.dart';
import '../data/models/vendor_model.dart';

class ProfileState extends Equatable {
  final VendorModel? vendor;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.vendor,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    VendorModel? vendor,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      vendor: vendor ?? this.vendor,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [vendor, isLoading, error];
}

