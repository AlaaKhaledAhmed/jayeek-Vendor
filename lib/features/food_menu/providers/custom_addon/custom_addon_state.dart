import 'package:equatable/equatable.dart';

import '../../domain/models/custom_addon_model.dart';
import '../../../../core/model/data_handel.dart';
import '../../../../core/constants/app_flow_sate.dart';

class CustomAddonState extends Equatable {
  final DataHandle<CustomAddonsModels> addonsData;
  final bool isLoading;

  final String? selectedImagePath;

  const CustomAddonState({
    this.addonsData = const DataHandle<CustomAddonsModels>(),
    this.isLoading = false,
    this.selectedImagePath,
  });

  CustomAddonState copyWith({
    DataHandle<CustomAddonsModels>? addonsData,
    bool? isLoading,
    String? selectedImagePath,
  }) {
    return CustomAddonState(
      addonsData: addonsData ?? this.addonsData,
      isLoading: isLoading ?? this.isLoading,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
    );
  }

  /// Helper getter for easy access to addons list
  List<AddonsData> get addons => addonsData.data?.data ?? [];

  @override
  List<Object?> get props => [
        addonsData,
        isLoading,
        selectedImagePath,
      ];
}
