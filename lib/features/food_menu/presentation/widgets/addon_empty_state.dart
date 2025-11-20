import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/services/shared_preferences_service.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_snack_bar.dart';
import 'package:jayeek_vendor/core/widgets/unified_bottom_sheet.dart';
import 'package:jayeek_vendor/core/error/handel_post_response.dart';

import '../../providers/custom_addon/custom_addon_provider.dart';

class AddonEmptyState extends ConsumerWidget {
  const AddonEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(customAddonProvider.notifier);
    final state = ref.watch(customAddonProvider);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.addon,
              size: AppSize.veryLargeIconSize,
              color: AppColor.mediumGray,
            ),
            SizedBox(height: 24.h),
            AppText(
              text: AppMessage.noAddonsYet,
              fontSize: AppSize.heading2,
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
            SizedBox(height: 12.h),
            AppText(
              text: AppMessage.noAddonsMessage,
              fontSize: AppSize.normalText,
              color: AppColor.subGrayText,
            ),
            SizedBox(height: 24.h),
            AppButtons(
              text: AppMessage.addAddon,
              onPressed: () => _showAddAddonDialog(context, notifier, state),
              backgroundColor: AppColor.mainColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddonDialog(BuildContext context, notifier, state) async {
    final availableAddons = state.availableAddons;
    if (availableAddons.isEmpty) {
      // Load available addons first
      await notifier.loadAvailableAddons();
    }

    int? selectedAddonId;
    final formKey = GlobalKey<FormState>();

    await UnifiedBottomSheet.showCustom(
      context: context,
      title: 'إضافة إضافة مخصصة',
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
                DropdownButtonFormField<int>(
                  value: selectedAddonId,
                  decoration: InputDecoration(
                    labelText: 'الإضافة المخصصة',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                  items: state.availableAddons.map((addon) {
                    return DropdownMenuItem<int>(
                      value: addon.id,
                      child: Text('${addon.name} - ${addon.price} SAR'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAddonId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'يرجى اختيار إضافة مخصصة';
                    }
                    return null;
                  },
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
                        text: 'إضافة',
                        onPressed: () async {
                          if (formKey.currentState!.validate() &&
                              selectedAddonId != null) {
                            Navigator.pop(context);
                            final branchId =
                                await SharedPreferencesService.getBranchId();
                            if (branchId != null) {
                              HandelPostRequest.handlePostRequest(
                                context: context,
                                formKey: null,
                                request: () => notifier.assignAddonToBranch(
                                  branchId: branchId,
                                  customAddonId: selectedAddonId!,
                                ),
                                onSuccess: (data) {
                                  AppSnackBar.show(
                                    message: 'تم إضافة الإضافة المخصصة بنجاح',
                                    type: ToastType.success,
                                  );
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
