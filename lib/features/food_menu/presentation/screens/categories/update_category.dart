import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/widgets/app_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_snack_bar.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/app_text_fields.dart';
import 'package:jayeek_vendor/core/widgets/scroll_list.dart';
import 'package:jayeek_vendor/core/widgets/shared_image_picker.dart';
import 'package:jayeek_vendor/core/widgets/food_emoji_picker.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';

import '../../../../../core/error/handel_post_response.dart';
import '../../../providers/categories/categories_provider.dart';
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
  String? selectedEmoji;

  @override
  void initState() {
    super.initState();

    /// Load category data for editing if provided, otherwise prepare for new category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fromUpdate) {
        ref
            .read(categoriesProvider.notifier)
            .loadCategoryForEdit(widget.category!);
        // Check if current image is an emoji (short string of 1-4 characters)
        if (widget.category?.image != null &&
            widget.category!.image!.length <= 4 &&
            widget.category!.image!.isNotEmpty &&
            widget.category!.image != 'string') {
          selectedEmoji = widget.category!.image;
        }
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
          text: widget.fromUpdate
              ? AppMessage.editCategory
              : AppMessage.addCategory,
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

                  // Category Image or Emoji
                  _buildImageOrEmojiSection(notifier),
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

  Widget _buildImageOrEmojiSection(notifier) {
    final currentImagePath = widget.fromUpdate
        ? notifier.editSelectedImagePath
        : notifier.addSelectedImagePath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          text: 'صورة الفئة أو أيقونة',
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 10.h),

        // Selection Tabs
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmoji = null;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: AppDecoration.decoration(
                    radius: 12,
                    color: selectedEmoji == null
                        ? AppColor.mainColor
                        : AppColor.white,
                    showBorder: true,
                    borderColor: AppColor.mainColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: selectedEmoji == null
                            ? AppColor.white
                            : AppColor.mainColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      AppText(
                        text: 'صورة',
                        color: selectedEmoji == null
                            ? AppColor.white
                            : AppColor.mainColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmoji = selectedEmoji ?? '🍔';
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: AppDecoration.decoration(
                    radius: 12,
                    color: selectedEmoji != null
                        ? AppColor.mainColor
                        : AppColor.white,
                    showBorder: true,
                    borderColor: AppColor.mainColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '😊',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      SizedBox(width: 8.w),
                      AppText(
                        text: 'أيقونة',
                        color: selectedEmoji != null
                            ? AppColor.white
                            : AppColor.mainColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Show Image Picker or Emoji Picker based on selection
        if (selectedEmoji == null)
          SharedImagePicker(
            imagePath: currentImagePath,
            onPickImage: () async {
              await notifier.pickCategoryImage(context,
                  isEdit: widget.fromUpdate);
            },
            height: 200.h,
            placeholderText: AppMessage.selectImage,
          )
        else
          _buildEmojiSelector(notifier),
      ],
    );
  }

  Widget _buildEmojiSelector(notifier) {
    return GestureDetector(
      onTap: () async {
        final emoji = await FoodEmojiPicker.showPicker(
          context,
          selectedEmoji: selectedEmoji,
        );

        if (emoji != null) {
          setState(() {
            selectedEmoji = emoji;
          });

          // Set emoji as image in notifier
          if (widget.fromUpdate) {
            notifier.setEditImagePath(emoji);
          } else {
            notifier.setAddImagePath(emoji);
          }
        }
      },
      child: Container(
        height: 200.h,
        decoration: AppDecoration.decoration(
          radius: 16,
          color: AppColor.white,
          showBorder: true,
          borderColor: AppColor.borderColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedEmoji != null)
              Text(
                selectedEmoji!,
                style: TextStyle(fontSize: 80.sp),
              )
            else
              Icon(
                Icons.add_reaction,
                size: 60.sp,
                color: AppColor.mediumGray,
              ),
            SizedBox(height: 16.h),
            AppText(
              text: selectedEmoji != null
                  ? 'اضغط لتغيير الأيقونة'
                  : 'اضغط لاختيار أيقونة',
              color: AppColor.subGrayText,
              fontSize: AppSize.normalText,
            ),
          ],
        ),
      ),
    );
  }
}
