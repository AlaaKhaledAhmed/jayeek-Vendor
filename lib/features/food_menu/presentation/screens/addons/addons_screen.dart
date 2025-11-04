import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/routing/app_routes_methods.dart';
import 'package:jayeek_vendor/core/widgets/custom_load.dart';
import 'package:jayeek_vendor/core/widgets/data_view_builder.dart';
import 'package:jayeek_vendor/core/widgets/app_snack_bar.dart';
import 'package:jayeek_vendor/core/widgets/unified_bottom_sheet.dart';
import 'package:jayeek_vendor/core/error/handel_post_response.dart';

import '../../../providers/custom_addon/custom_addon_provider.dart';
import '../../widgets/addon_item_card.dart';
import '../../widgets/addon_empty_state.dart';
import 'update_addon.dart';

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

    return DataViewBuilder(
      dataHandle: state.addonsData,
      emptyBuilder: () => const AddonEmptyState(),
      onReload: () async => notifier.loadData(refresh: true),
      loadingBuilder: () => CustomLoad().loadVerticalList(context: context),
      isDataEmpty: () => state.addonsData.data?.data?.isEmpty ?? true,
      successBuilder: (addons) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount: addons.data!.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final addon = addons.data![index];
            return AddonItemCard(
              addon: addon,
              onEdit: () async {
                notifier.loadAddonForEdit(addon);
                AppRoutes.pushTo(
                    context,
                    UpdateAddon(
                      addon: addon,
                      fromUpdate: true,
                    ));
              },
              onDelete: () => _showDeleteDialog(
                context: context,
                notifier: notifier,
                state: state,
                id: addon.id!,
              ),
            );
          },
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
