import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/widgets/app_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_snack_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/scroll_list.dart';
import 'package:jayeek_vendor/generated/assets.dart';

import '../../../../../core/error/handel_post_response.dart';
import '../../../providers/categories/categories_provider.dart';
import '../../../providers/categories/categories_notifier.dart';
import '../../../providers/categories/categories_state.dart';
import '../../../domain/models/food_category_model.dart';

class UpdateCategory extends ConsumerStatefulWidget {
  final FoodCategoryModel? category;
  final bool fromUpdate;

  const UpdateCategory({
    super.key,
    this.category,
    required this.fromUpdate,
  });

  @override
  ConsumerState<UpdateCategory> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends ConsumerState<UpdateCategory> {
  @override
  void initState() {
    super.initState();

    /// Load category data for editing if provided, otherwise prepare for new category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fromUpdate) {
        ref.read(categoriesProvider.notifier).loadCategoryForEdit(widget.category!);
      } else {
        ref.read(categoriesProvider.notifier).resetAddForm();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(categoriesProvider.notifier);
    final state = ref.watch(categoriesProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarWidget(
          text: widget.fromUpdate ? AppMessage.editCategory : AppMessage.addCategory,
          hideBackButton: false,
        ),
        body: SafeArea(
          child: Form(
            key: widget.fromUpdate ? notifier.editFormKey : notifier.addFormKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 10.h,
              ),
              child: ScrollList(
                children: [
                  // Category Name (English)
                  const AppText(
                    text: 'اسم الفئة (الإنجليزية)',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5.h),
                  AppTextFields(
                    hintText: 'اسم الفئة (الإنجليزية)',
                    controller: widget.fromUpdate 
                        ? notifier.editNameController 
                        : notifier.addNameController,
                    validator: (v) =>
                        v!.isEmpty ? AppMessage.enterCategoryName : null,
                  ),
                  SizedBox(height: 10.h),

                  // Category Name (Arabic)
                  const AppText(
                    text: 'اسم الفئة (العربية)',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5.h),
                  AppTextFields(
                    hintText: 'اسم الفئة (العربية)',
                    controller: widget.fromUpdate 
                        ? notifier.editNameArController 
                        : notifier.addNameArController,
                    validator: (v) => null,
                  ),
                  SizedBox(height: 20.h),

                  // Category Image
                  const AppText(
                    text: 'صورة الفئة',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10.h),
                  _buildImageSection(context, notifier, state, widget.fromUpdate),
                  SizedBox(height: 20.h),

                  // Save Button
                  AppButtons(
                    text: AppMessage.save,
                    showLoader: state.isLoading,
                    onPressed: () {
                      ///handel result
                      HandelPostRequest.handlePostRequest(
                        context: context,
                        formKey: widget.fromUpdate 
                            ? notifier.editFormKey 
                            : notifier.addFormKey,
                        request: widget.fromUpdate
                            ? notifier.updateCategory
                            : notifier.createCategory,
                        onSuccess: (data) {
                          // Show success message
                          AppSnackBar.show(
                            message: widget.fromUpdate
                                ? AppMessage.categoryUpdated
                                : AppMessage.categoryCreated,
                            type: ToastType.success,
                          );
                          notifier.loadData(refresh: true);
                          Navigator.pop(context);
                        },
                        onFailure: (data) {
                          // Do nothing - error message already shown by HandelPostRequest
                          // Don't close the page on failure
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

  Widget _buildImageSection(
      BuildContext context, CategoriesNotifier notifier, CategoriesState state, bool isEdit) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: AppDecoration.decoration(
        radius: 12,
        color: AppColor.lightGray,
      ),
      child: Stack(
        children: [
          // Image Preview
          if ((isEdit ? notifier.editSelectedImagePath : notifier.addSelectedImagePath) != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: _buildImageWidget(
                isEdit ? notifier.editSelectedImagePath! : notifier.addSelectedImagePath!,
              ),
            )
          else
            Center(
              child: Icon(
                Icons.add_photo_alternate,
                size: 60.sp,
                color: AppColor.mediumGray,
              ),
            ),

          // Pick Image Button
          Positioned(
            bottom: 10.h,
            right: 10.w,
            child: AppButtons(
              text: (isEdit ? notifier.editSelectedImagePath : notifier.addSelectedImagePath) != null
                  ? AppMessage.changeImage
                  : AppMessage.selectImage,
              onPressed: () => notifier.pickCategoryImage(context, isEdit: isEdit),
              height: 40.h,
              backgroundColor: AppColor.mainColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    // Check if it's a network URL first
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: double.infinity,
        height: 200.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            Assets.imagesDefault,
            width: double.infinity,
            height: 200.h,
            fit: BoxFit.cover,
          );
        },
      );
    }

    // Check if it's a base64 string (must check before file path check)
    // Base64 strings typically start with /9j/ (JPEG) or data:image, or are very long without file path structure
    bool isBase64 = imagePath.startsWith('/9j/') ||
        imagePath.startsWith('data:image') ||
        (imagePath.length > 500 && !imagePath.contains('/tmp/') && !imagePath.contains('/storage/') && !imagePath.contains('/data/'));

    if (isBase64) {
      try {
        String base64String = imagePath;
        if (base64String.contains(',')) {
          base64String = base64String.split(',').last;
        }
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: double.infinity,
          height: 200.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              Assets.imagesDefault,
              width: double.infinity,
              height: 200.h,
              fit: BoxFit.cover,
            );
          },
        );
      } catch (e) {
        // If base64 decode fails, try as file path
        return _tryAsFile(imagePath);
      }
    }

    // Check if it's a file path (must be a valid file path)
    return _tryAsFile(imagePath);
  }

  Widget _tryAsFile(String imagePath) {
    // Only try as file if it looks like a file path and file exists
    if (imagePath.startsWith('/') && !imagePath.startsWith('http')) {
      try {
        final file = File(imagePath);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: double.infinity,
            height: 200.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                Assets.imagesDefault,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
              );
            },
          );
        }
      } catch (e) {
        // If file access fails, return default
      }
    }

    // Default image
    return Image.asset(
      Assets.imagesDefault,
      width: double.infinity,
      height: 200.h,
      fit: BoxFit.cover,
    );
  }
}

