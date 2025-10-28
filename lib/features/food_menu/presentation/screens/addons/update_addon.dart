import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/util/print_info.dart';
import 'package:jayeek_vendor/core/widgets/app_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_drop_list.dart';
import 'package:jayeek_vendor/core/widgets/app_snack_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/scroll_list.dart';

import '../../../domain/models/custom_addon_model.dart';
import '../../../providers/custom_addon/custom_addon_provider.dart';
import '../../../providers/custom_addon/custom_addon_state.dart';

class UpdateAddon extends ConsumerStatefulWidget {
  final CustomAddonModel? addon;

  const UpdateAddon({super.key, this.addon});

  @override
  ConsumerState<UpdateAddon> createState() => _AddEditAddonScreenState();
}

class _AddEditAddonScreenState extends ConsumerState<UpdateAddon> {
  @override
  void initState() {
    super.initState();
    // Load addon data for editing if provided, otherwise prepare for new addon
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(customAddonProvider.notifier);
      if (widget.addon != null && widget.addon!.id != 0) {
        notifier.loadAddonForEdit(widget.addon!);
      } else {
        notifier.prepareForNewAddon();
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
          text:
              widget.addon != null ? AppMessage.editAddon : AppMessage.addAddon,
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
                  AppText(
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
                  AppText(
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
                  AppText(
                    text: 'صورة الإضافة',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10.h),
                  _buildImageSection(context, notifier, state),
                  SizedBox(height: 20.h),

                  // Addon Price
                  AppText(
                    text: AppMessage.addonPrice,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5.h),
                  AppTextFields(
                    hintText: AppMessage.addonPrice,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: notifier.priceController,
                    validator: (v) {
                      if (v!.isEmpty) return AppMessage.enterAddonPrice;
                      if (double.tryParse(v) == null)
                        return 'يرجى إدخال رقم صحيح';
                      if (double.parse(v) <= 0)
                        return 'السعر يجب أن يكون أكبر من صفر';
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),

                  // Unit Type
                  AppText(
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
                    onPressed: () async {
                      if (!notifier.canSave()) {
                        AppSnackBar.show(
                          message: 'لا توجد تغييرات لحفظها',
                          type: ToastType.info,
                        );
                        return;
                      }

                      if (widget.addon != null) {
                        await notifier.updateAddon(widget.addon!);
                        if (state.error == null && context.mounted) {
                          AppSnackBar.show(
                            message: AppMessage.addonUpdated,
                            type: ToastType.success,
                          );
                          Navigator.pop(context,
                              true); // Return true for successful update
                        }
                      } else {
                        await notifier.createAddon();
                        if (state.error == null && context.mounted) {
                          AppSnackBar.show(
                            message: AppMessage.addonCreated,
                            type: ToastType.success,
                          );
                          Navigator.pop(context,
                              true); // Return true for successful creation
                        }
                      }

                      if (state.error != null && context.mounted) {
                        AppSnackBar.show(
                          message: state.error!,
                          type: ToastType.error,
                        );
                      }
                    },
                    backgroundColor: AppColor.mainColor,
                    showLoader: state.isCreating || state.isUpdating,
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

  Widget _buildImageSection(
      BuildContext context, dynamic notifier, CustomAddonState state) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: AppDecoration.decoration(
        color: AppColor.lightGray,
        radius: 12,
        showBorder: true,
        borderColor: AppColor.borderColor,
      ),
      child: InkWell(
        onTap: () => notifier.pickImage(context),
        borderRadius: BorderRadius.circular(12.r),
        child: state.selectedImagePath != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: state.selectedImagePath!.startsWith('http')
                        ? Image.network(
                            state.selectedImagePath!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildImagePlaceholder(notifier);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColor.mainColor,
                                  ),
                                ),
                              );
                            },
                          )
                        : Image.file(
                            File(state.selectedImagePath!),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildImagePlaceholder(notifier);
                            },
                          ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.red.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          notifier.setImagePath(null);
                          printInfo('Image removed');
                        },
                        icon: Icon(
                          Icons.close,
                          color: AppColor.white,
                          size: AppSize.smallIconSize,
                        ),
                        padding: EdgeInsets.all(4.w),
                        constraints: BoxConstraints(
                          minWidth: 32.w,
                          minHeight: 32.h,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : _buildImagePlaceholder(notifier),
      ),
    );
  }

  Widget _buildImagePlaceholder(dynamic notifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          AppIcons.addon,
          size: AppSize.largeIconSize,
          color: AppColor.mediumGray,
        ),
        SizedBox(height: 8.h),
        AppText(
          text: 'اضغط لاختيار صورة',
          fontSize: AppSize.normalText,
          color: AppColor.mediumGray,
        ),
      ],
    );
  }
}
