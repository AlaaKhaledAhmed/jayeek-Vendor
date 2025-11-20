import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/util/print_info.dart';
import 'package:jayeek_vendor/core/widgets/custom_load.dart';
import 'package:jayeek_vendor/core/widgets/data_view_builder.dart';
import 'package:jayeek_vendor/core/widgets/app_snack_bar.dart';
import 'package:jayeek_vendor/core/widgets/unified_bottom_sheet.dart';
import 'package:jayeek_vendor/core/widgets/app_drop_list.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/services/shared_preferences_service.dart';
import 'package:jayeek_vendor/core/error/handel_post_response.dart';

import '../../../domain/models/custom_addon_model.dart';
import '../../../providers/custom_addon/custom_addon_provider.dart';
import '../../widgets/addon_item_card.dart';
import '../../widgets/addon_empty_state.dart';

class AddonsScreen extends ConsumerStatefulWidget {
  const AddonsScreen({super.key});

  @override
  ConsumerState<AddonsScreen> createState() => _AddonsListScreenState();
}

class _AddonsListScreenState extends ConsumerState<AddonsScreen> {
  @override
  void initState() {
    super.initState();

    /// Load addons when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customAddonProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customAddonProvider);
    final notifier = ref.read(customAddonProvider.notifier);
    return Scaffold(
      body: DataViewBuilder(
        dataHandle: state.branchAddonsData,
        emptyBuilder: () => const AddonEmptyState(),
        onReload: () async => notifier.loadData(refresh: true),
        loadingBuilder: () => CustomLoad().loadVerticalList(context: context),
        isDataEmpty: () => state.branchAddonsData.data?.data?.isEmpty ?? true,
        successBuilder: (branchAddons) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: branchAddons.data?.length ?? 0,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final branchAddon = branchAddons.data![index];
              // Convert to AddonsData for compatibility with AddonItemCard
              final addon = AddonsData(
                id: branchAddon.id,
                name: branchAddon.customAddonName,
                price: branchAddon.price,
                description: branchAddon.description,
                imageUrl: branchAddon.image,
                deleteFlag: branchAddon.deleteFlag,
              );
              return AddonItemCard(
                addon: addon,
                onEdit: () => _showUpdateAddonDialog(
                  context: context,
                  notifier: notifier,
                  state: state,
                  branchAddon: branchAddon,
                ),
                onDelete: () => _showDeleteDialog(
                  context: context,
                  notifier: notifier,
                  state: state,
                  id: branchAddon.id!,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showUpdateAddonDialog({
    required BuildContext context,
    required notifier,
    required state,
    required BranchCustomAddonModel branchAddon,
  }) async {
    final availableAddons = state.availableAddons;
    if (availableAddons.isEmpty) {
      // Load available addons first
      await notifier.loadAvailableAddons();
    }

    // Find current addon in available list to set as initial value
    AddonsData? selectedAddon;
    try {
      selectedAddon = availableAddons.firstWhere(
        (addon) => addon.id == branchAddon.customAddonId,
      );
    } catch (e) {
      // If not found, use first available addon or null
      selectedAddon = availableAddons.isNotEmpty ? availableAddons.first : null;
    }

    final formKey = GlobalKey<FormState>();

    await UnifiedBottomSheet.showCustom(
      context: context,
      title: 'تعديل الإضافة المخصصة',
      child: StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'اختر الإضافة المخصصة',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 16.h),
                AppDropList<AddonsData>(
                  hintText: 'الإضافة المخصصة',
                  items: state.availableAddons,
                  value: selectedAddon,
                  onChanged: (value) {
                    setState(() {
                      selectedAddon = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'يرجى اختيار إضافة مخصصة';
                    }
                    return null;
                  },
                  customItem: state.availableAddons
                      .map<DropdownMenuItem<AddonsData>>((addon) {
                    return DropdownMenuItem<AddonsData>(
                      value: addon,
                      child: AppText(
                        text: '${addon.name} - ${addon.price} SAR',
                        fontSize: 14.sp,
                        color: AppColor.textColor,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: AppButtons(
                        text: AppMessage.cancel,
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: AppColor.lightGray,
                        textStyleColor: AppColor.textColor,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppButtons(
                        text: 'تحديث',
                        onPressed: () async {
                          if (formKey.currentState!.validate() &&
                              selectedAddon != null) {
                            Navigator.pop(context);
                            final branchId =
                                await SharedPreferencesService.getBranchId();
                            if (branchId != null &&
                                branchAddon.customAddonId != null &&
                                branchAddon.branchId != null) {
                              HandelPostRequest.handlePostRequest(
                                context: context,
                                formKey: null,
                                request: () => notifier.updateBranchCustomAddon(
                                  oldCustomAddonId: branchAddon.customAddonId!,
                                  oldBranchId: branchAddon.branchId!,
                                  newCustomAddonId: selectedAddon!.id!,
                                  newBranchId: branchId,
                                ),
                                onSuccess: (data) {
                                  AppSnackBar.show(
                                    message: 'تم تحديث الإضافة المخصصة بنجاح',
                                    type: ToastType.success,
                                  );
                                },
                                onFailure: (data) {
                                  // If status code is 400, show message as is
                                  if (data.statusCode == 400 &&
                                      data.message != null) {
                                    if (context.mounted) {
                                      AppSnackBar.show(
                                        message: data.message!,
                                        type: ToastType.error,
                                      );
                                    }
                                  }
                                },
                              );
                            }
                          }
                        },
                        backgroundColor: AppColor.mainColor,
                        showLoader: state.isLoading,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showDeleteDialog({
  required BuildContext context,
  required notifier,
  required state,
  required int id,
}) async {
  final confirmed = await UnifiedBottomSheet.showConfirmation(
    context: context,
    title: AppMessage.deleteAddonConfirm,
    message: AppMessage.deleteAddonMessage,
    confirmText: AppMessage.delete,
    confirmColor: AppColor.red,
    barrierDismissible: !state.isLoading,
  );

  if (confirmed == true) {
    HandelPostRequest.handlePostRequest(
      context: context,
      formKey: null,
      request: () => notifier.deleteAddon(id),
      onSuccess: (data) {
        AppSnackBar.show(
          message: AppMessage.addonDeleted,
          type: ToastType.success,
        );
      },
    );
  }
}
