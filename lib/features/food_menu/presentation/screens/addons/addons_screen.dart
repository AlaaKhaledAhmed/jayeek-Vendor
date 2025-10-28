import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/routing/app_routes_methods.dart';
import 'package:jayeek_vendor/core/widgets/app_refresh_indicator.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/custom_load.dart';
import 'package:jayeek_vendor/core/widgets/data_view_builder.dart';

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
      isDataEmpty: () => state.addonsData.data!.isEmpty,
      successBuilder: (addons) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount: state.addons.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final addon = addons[index];
            return AddonItemCard(
              addon: addon,
              onEdit: () async {
                notifier.loadAddonForEdit(addon);
                AppRoutes.pushTo(context, UpdateAddon(addon: addon));
              },
              onDelete: () => _showDeleteDialog(
                context,
                ref,
                addon,
              ),
            );
          },
        ),
      ),
    );
  }
}

void _showDeleteDialog(
  BuildContext context,
  WidgetRef ref,
  addon,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: AppText(
        text: AppMessage.deleteAddonConfirm,
        fontSize: AppSize.heading3,
        fontWeight: FontWeight.bold,
      ),
      content: AppText(
        text: AppMessage.deleteAddonMessage,
        fontSize: AppSize.normalText,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: AppText(
            text: AppMessage.cancel,
            color: AppColor.mediumGray,
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await ref.read(customAddonProvider.notifier).deleteAddon(addon.id);
            // Data will be refreshed automatically by the notifier
          },
          child: AppText(
            text: AppMessage.delete,
            color: AppColor.red,
          ),
        ),
      ],
    ),
  );
}
