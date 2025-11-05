import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/services/language_service.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/widgets/app_decoration.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../generated/assets.dart';
import '../../domain/models/food_category_model.dart';

/// Widget لعرض فئة الطعام مع صورة
class CategoryChipWithImage extends StatelessWidget {
  final FoodCategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? borderRadius;

  const CategoryChipWithImage({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.borderRadius,
  });

  /// Get category name based on current language
  String _getCategoryName() {
    final lang = LanguageService.getLang();
    if (lang == 'ar' &&
        category.nameAr != null &&
        category.nameAr!.isNotEmpty) {
      return category.nameAr!;
    }
    return category.name ?? '';
  }

  /// Get image provider from category image
  ImageProvider<Object>? _getImageProvider() {
    if (category.image != null && category.image!.isNotEmpty) {
      final imageString = category.image!;

      // Validate that image is not an invalid placeholder string
      if (imageString == 'string' || imageString.length < 3) {
        return null;
      }

      // Check if it's a network URL
      if (imageString.startsWith('http://') ||
          imageString.startsWith('https://')) {
        return NetworkImage(imageString);
      }

      // Check if it's a base64 string (starts with /9j/ or data:image or is very long)
      if (imageString.startsWith('/9j/') ||
          imageString.startsWith('data:image') ||
          imageString.length > 100) {
        try {
          // Remove data URL prefix if present (data:image/png;base64,)
          String base64String = imageString;
          if (base64String.contains(',')) {
            base64String = base64String.split(',').last;
          }
          // Decode base64 string
          final bytes = base64Decode(base64String);
          return MemoryImage(bytes);
        } catch (e) {
          // If decoding fails, return null to use default image
          return null;
        }
      }
    }
    // Return null to use default image
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedColor = selectedColor ?? AppColor.subtextColor;
    final effectiveUnselectedColor = unselectedColor ?? AppColor.white;
    final effectiveBorderRadius = borderRadius ?? 25;
    final imageProvider = _getImageProvider();
    final categoryName = _getCategoryName();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.only(
            start: 10.w, top: 10.h, bottom: 10.h, end: 20.w),
        margin: EdgeInsets.only(left: 8.w),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    effectiveSelectedColor,
                    effectiveSelectedColor.resolveOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : effectiveUnselectedColor,
          borderRadius: BorderRadius.circular(effectiveBorderRadius.r),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColor.borderColor.resolveOpacity(0.3),
            width: isSelected ? 0 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: effectiveSelectedColor.resolveOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category Image
            AnimatedScale(
              scale: isSelected ? 1.25 : 1.0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              child: Container(
                width: 30.spMin,
                height: 30.spMin,
                decoration: AppDecoration.decoration(
                  isCircle: true,
                  shadow: false,
                  color: isSelected ? AppColor.white : AppColor.lightGray,
                  image: imageProvider ??
                      const AssetImage(Assets.imagesDefault)
                          as ImageProvider<Object>,
                  cover: imageProvider != null,
                ),
              ),
            ),
            SizedBox(width: 10.w),

            // Category Name
            AppText(
              text: categoryName,
              color: isSelected ? AppColor.white : AppColor.textColor,
              fontSize: 13.sp,
              fontWeight: isSelected ? AppThem().bold : FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
