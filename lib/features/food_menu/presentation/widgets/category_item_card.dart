import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/services/language_service.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/generated/assets.dart';

import '../../domain/models/food_category_model.dart';

class CategoryItemCard extends StatelessWidget {
  final FoodCategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryItemCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
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

      // Check if it's an emoji (short string of 1-4 characters)
      if (imageString.length <= 4) {
        return null; // Will handle emoji separately
      }

      // Check if it's a network URL
      if (imageString.startsWith('http://') ||
          imageString.startsWith('https://')) {
        return NetworkImage(imageString);
      }

      // Check if it's a base64 string
      if (imageString.startsWith('/9j/') ||
          imageString.startsWith('data:image') ||
          imageString.length > 100) {
        try {
          String base64String = imageString;
          if (base64String.contains(',')) {
            base64String = base64String.split(',').last;
          }
          final bytes = base64Decode(base64String);
          return MemoryImage(bytes);
        } catch (e) {
          return null;
        }
      }
    }
    return null;
  }

  bool _isEmoji() {
    if (category.image != null &&
        category.image!.isNotEmpty &&
        category.image != 'string' &&
        category.image!.length <= 4) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _getImageProvider();
    final categoryName = _getCategoryName();

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: AppDecoration.decoration(
          color: AppColor.white,
          radius: 12,
          shadowOpacity: 0.1,
          showBorder: true,
          borderColor: AppColor.borderColor,
          borderWidth: 1,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 8.h,
          ),
          leading: _isEmoji()
              ? Container(
                  width: 60.w,
                  height: 60.h,
                  alignment: Alignment.center,
                  decoration: AppDecoration.decoration(
                    shadow: false,
                    color: AppColor.lightGray,
                    radius: 8,
                  ),
                  child: Text(
                    category.image!,
                    style: TextStyle(fontSize: 36.sp),
                  ),
                )
              : Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: AppDecoration.decoration(
                    shadow: false,
                    color: AppColor.lightGray,
                    radius: 8,
                    image: imageProvider ??
                        const AssetImage(Assets.imagesDefault)
                            as ImageProvider<Object>,
                    cover: imageProvider != null,
                  ),
                ),
          title: AppText(
            text: categoryName,
            fontSize: AppSize.normalText,
            fontWeight: FontWeight.bold,
            color: AppColor.textColor,
          ),
          trailing: IconButton(
            onPressed: onDelete,
            icon: Icon(
              AppIcons.delete,
              color: AppColor.red,
              size: AppSize.mediumIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
