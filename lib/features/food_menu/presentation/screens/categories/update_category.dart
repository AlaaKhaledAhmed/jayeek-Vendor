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
import 'package:jayeek_vendor/core/widgets/food_emoji_picker.dart';

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
        // Load iconCode and convert to emoji
        if (widget.category?.iconCode != null &&
            widget.category!.iconCode!.isNotEmpty) {
          try {
            String code = widget.category!.iconCode!.trim();
            if (code.startsWith('U+')) {
              code = code.substring(2);
            }
            final codePoint = int.parse(code, radix: 16);
            
            // Handle emoji that require surrogate pairs (code points > 0xFFFF)
            if (codePoint > 0xFFFF) {
              final high = 0xD800 + ((codePoint - 0x10000) >> 10);
              final low = 0xDC00 + ((codePoint - 0x10000) & 0x3FF);
              selectedEmoji = String.fromCharCodes([high, low]);
            } else {
              selectedEmoji = String.fromCharCode(codePoint);
            }
          } catch (e) {
            selectedEmoji = '🍔'; // Default emoji if conversion fails
          }
        } else {
          selectedEmoji = '🍔'; // Default emoji for new category
        }
      } else {
        ref.read(categoriesProvider.notifier).resetAddForm();
        selectedEmoji = '🍔'; // Default emoji for new category
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
                    validator: (v) =>
                        v!.isEmpty ? AppMessage.enterCategoryNameAr : null,
                  ),
                  SizedBox(height: 10.h),

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
                  SizedBox(height: 20.h),

                  // Category Icon
                  _buildEmojiSection(notifier),
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

  Widget _buildEmojiSection(notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          text: 'أيقونة الفئة',
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 15.h),
        _buildModernEmojiSelector(notifier),
      ],
    );
  }

  Widget _buildModernEmojiSelector(notifier) {
    return GestureDetector(
      key: const ValueKey('emoji_selector'),
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
        height: 220.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.mainColor.withOpacity(0.05),
              AppColor.mainColor.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColor.mainColor.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Background Pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _DottedPatternPainter(
                  color: AppColor.mainColor.withOpacity(0.05),
                ),
              ),
            ),

            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Emoji Display with Animation
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (value * 0.2),
                        child: Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.mainColor.withOpacity(0.15),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              selectedEmoji ?? '🍔',
                              style: TextStyle(fontSize: 65.sp),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Action Text
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.mainColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 18.sp,
                          color: AppColor.mainColor,
                        ),
                        SizedBox(width: 8.w),
                        AppText(
                          text: 'اضغط لتغيير الأيقونة',
                          color: AppColor.mainColor,
                          fontSize: AppSize.captionText,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for Dotted Pattern Background
class _DottedPatternPainter extends CustomPainter {
  final Color color;

  _DottedPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
