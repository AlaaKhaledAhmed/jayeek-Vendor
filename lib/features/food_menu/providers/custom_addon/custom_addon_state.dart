import 'package:equatable/equatable.dart';

import '../../domain/models/custom_addon_model.dart';
import '../../../../core/model/data_handel.dart';

class CustomAddonState extends Equatable {
  final DataHandle<CustomAddonsModels> addonsData;
  final DataHandle<BranchCustomAddonsResponse> branchAddonsData;
  final DataHandle<CustomAddonsModels> availableAddonsData; // For dropdown
  final bool isLoading;

  final String? selectedImagePath;

  const CustomAddonState({
    this.addonsData = const DataHandle<CustomAddonsModels>(),
    this.branchAddonsData = const DataHandle<BranchCustomAddonsResponse>(),
    this.availableAddonsData = const DataHandle<CustomAddonsModels>(),
    this.isLoading = false,
    this.selectedImagePath,
  });

  CustomAddonState copyWith({
    DataHandle<CustomAddonsModels>? addonsData,
    DataHandle<BranchCustomAddonsResponse>? branchAddonsData,
    DataHandle<CustomAddonsModels>? availableAddonsData,
    bool? isLoading,
    String? selectedImagePath,
  }) {
    return CustomAddonState(
      addonsData: addonsData ?? this.addonsData,
      branchAddonsData: branchAddonsData ?? this.branchAddonsData,
      availableAddonsData: availableAddonsData ?? this.availableAddonsData,
      isLoading: isLoading ?? this.isLoading,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
    );
  }

  /// Helper getter for easy access to branch addons list
  List<BranchCustomAddonModel> get branchAddons =>
      branchAddonsData.data?.data ?? [];

  /// Helper getter for easy access to available addons list (for dropdown)
  List<AddonsData> get availableAddons => availableAddonsData.data?.data ?? [];

  @override
  List<Object?> get props => [
        addonsData,
        branchAddonsData,
        availableAddonsData,
        isLoading,
        selectedImagePath,
      ];
}
