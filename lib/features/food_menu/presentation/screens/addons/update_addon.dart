import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/widgets/app_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_drop_list.dart';
import 'package:jayeek_vendor/core/widgets/app_snack_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/scroll_list.dart';
import 'package:jayeek_vendor/core/widgets/shared_image_picker.dart';

import '../../../../../core/error/handel_post_response.dart';
import '../../../domain/models/custom_addon_model.dart';
import '../../../providers/custom_addon/custom_addon_provider.dart';

class UpdateAddon extends ConsumerStatefulWidget {
  final AddonsData? addon;
  final bool fromUpdate;

  const UpdateAddon({
    super.key,
    this.addon,
    required this.fromUpdate,
  });

  @override
  ConsumerState<UpdateAddon> createState() => _AddEditAddonScreenState();
}

class _AddEditAddonScreenState extends ConsumerState<UpdateAddon> {
  @override
  void initState() {
    super.initState();

    /// Load addon data for editing if provided, otherwise prepare for new addon
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fromUpdate) {
        ref.read(customAddonProvider.notifier).loadAddonForEdit(widget.addon!);
      } else {
        ref.read(customAddonProvider.notifier).prepareForNewAddon();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(customAddonProvider.notifier);
    final state = ref.watch(customAddonProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarWidget(
          text: widget.fromUpdate ? AppMessage.editAddon : AppMessage.addAddon,
          hideBackButton: false,
        ),
        body: SafeArea(
          child: Form(
            key: notifier.formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 10.h,
              ),
              child: ScrollList(
                children: [
                  // Addon Name
                  const AppText(
                    text: AppMessage.addonName,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5.h),
                  AppTextFields(
                    hintText: AppMessage.addonName,
                    controller: notifier.nameController,
                    validator: (v) =>
                        v!.isEmpty ? AppMessage.enterAddonName : null,
                  ),
                  SizedBox(height: 10.h),

                  // Addon Description
                  const AppText(
                    text: AppMessage.addonDescription,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5.h),
                  AppTextFields(
                    hintText: AppMessage.addonDescription,
                    controller: notifier.descriptionController,
                    minLines: 3,
                    maxLines: 4,
                    validator: (v) =>
                        v!.isEmpty ? AppMessage.enterAddonDescription : null,
                  ),
                  SizedBox(height: 20.h),

                  // Addon Image
                  const AppText(
                    text: 'صورة الإضافة',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10.h),
                  SharedImagePicker(
                    imagePath: state.selectedImagePath,
                    onPickImage: () async {
                      await notifier.pickImage(context);
                    },
                    height: 200.h,
                    placeholderText: AppMessage.selectImage,
                  ),
                  SizedBox(height: 20.h),

                  // Addon Price
                  const AppText(
                    text: AppMessage.addonPrice,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5.h),
                  AppTextFields(
                    hintText: AppMessage.addonPrice,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: notifier.priceController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (v) {
                      if (v!.isEmpty) return AppMessage.enterAddonPrice;
                      if (double.tryParse(v) == null) {
                        return 'يرجى إدخال رقم صحيح';
                      }
                      if (double.parse(v) <= 0) {
                        return 'السعر يجب أن يكون أكبر من صفر';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),

                  // Unit Type
                  const AppText(
                    text: AppMessage.unitType,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5.h),
                  AppDropList(
                    hintText: AppMessage.chooseUnitType,
                    items: notifier.unitTypes,
                    value: notifier.selectedUnitType,
                    onChanged: (value) =>
                        notifier.setUnitType(value ?? 'piece'),
                  ),
                  SizedBox(height: 20.h),

                  // Save Button
                  AppButtons(
                    text: AppMessage.save,
                    showLoader: state.isLoading,
                    onPressed: () {
                      ///handel result
                      HandelPostRequest.handlePostRequest(
                        context: context,
                        formKey: notifier.formKey,
                        request: widget.fromUpdate
                            ? () => notifier.updateAddon(widget.addon!.id!)
                            : notifier.createAddon,
                        onSuccess: (data) {
                          // Show success message
                          AppSnackBar.show(
                            message: widget.fromUpdate
                                ? AppMessage.addonUpdated
                                : AppMessage.addonCreated,
                            type: ToastType.success,
                          );
                          notifier.loadData(refresh: true);
                          Navigator.pop(context);
                        },
                      );
                    },
                    backgroundColor: AppColor.mainColor,
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
