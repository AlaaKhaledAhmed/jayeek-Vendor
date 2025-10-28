import 'package:equatable/equatable.dart';

import '../../domain/models/custom_addon_model.dart';
import '../../../../core/model/data_handel.dart';
import '../../../../core/constants/app_flow_sate.dart';

class CustomAddonState extends Equatable {
  final DataHandle<List<CustomAddonModel>> addonsData;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;
  final String? error;
  final String? selectedImagePath;

  const CustomAddonState({
    this.addonsData = const DataHandle<List<CustomAddonModel>>(),
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.error,
    this.selectedImagePath,
  });

  CustomAddonState copyWith({
    DataHandle<List<CustomAddonModel>>? addonsData,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
    String? error,
    String? selectedImagePath,
  }) {
    return CustomAddonState(
      addonsData: addonsData ?? this.addonsData,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      error: error ?? this.error,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
    );
  }

  // Helper getter for easy access to addons list
  List<CustomAddonModel> get addons => addonsData.data ?? [];

  // Helper getter for loading state
  bool get isLoading => addonsData.result == AppFlowState.loading;

  @override
  List<Object?> get props => [
        addonsData,
        isCreating,
        isUpdating,
        isDeleting,
        error,
        selectedImagePath,
      ];
}
