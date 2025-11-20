import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import 'package:jayeek_vendor/core/services/language_service.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/generated/assets.dart';

import '../../domain/models/food_category_model.dart';

class CategoryItemCard extends StatefulWidget {
  final FoodCategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryItemCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<CategoryItemCard> createState() => _CategoryItemCardState();
}

class _CategoryItemCardState extends State<CategoryItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Get category name based on current language
  String _getCategoryName() {
    final lang = LanguageService.getLang();
    if (lang == 'ar' &&
        widget.category.nameAr != null &&
        widget.category.nameAr!.isNotEmpty) {
      return widget.category.nameAr!;
    }
    return widget.category.name ?? '';
  }

  /// Convert iconCode (like "U+1F354") to emoji character
  String? _getIconFromCode() {
    if (widget.category.iconCode == null || widget.category.iconCode!.isEmpty) {
      return null;
    }

    try {
      String code = widget.category.iconCode!.trim();
      // Handle format like "U+1F354" or "1F354"
      if (code.startsWith('U+')) {
        code = code.substring(2);
      }

      // Parse hex value and convert to emoji
      final codePoint = int.parse(code, radix: 16);

      // Handle emoji that require surrogate pairs (code points > 0xFFFF)
      if (codePoint > 0xFFFF) {
        // Convert to UTF-16 surrogate pair
        final high = 0xD800 + ((codePoint - 0x10000) >> 10);
        final low = 0xDC00 + ((codePoint - 0x10000) & 0x3FF);
        return String.fromCharCodes([high, low]);
      } else {
        return String.fromCharCode(codePoint);
      }
    } catch (e) {
      return null;
    }
  }

  /// Get image provider from category image
  ImageProvider<Object>? _getImageProvider() {
    if (widget.category.image != null && widget.category.image!.isNotEmpty) {
      final imageString = widget.category.image!;

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

  @override
  Widget build(BuildContext context) {
    final imageProvider = _getImageProvider();
    final categoryName = _getCategoryName();
    final iconEmoji = _getIconFromCode();
    final hasIcon = iconEmoji != null;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) {
          _controller.forward();
        },
        onTapUp: (_) {
          _controller.reverse();
          widget.onEdit();
        },
        onTapCancel: () {
          _controller.reverse();
        },
        child: DecoratedBox(
          decoration: AppDecoration.decoration(showBorder: true),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Modern Image/Icon Container
                Hero(
                  tag: 'category_${widget.category.id}',
                  child: Container(
                    width: 75.w,
                    height: 75.w,
                    decoration: AppDecoration.decoration(
                      shadow: false,
                      showBorder: true,
                      color: hasIcon
                          ? null
                          : AppColor.lightGray.resolveOpacity(0.5),
                      borderRadius: BorderRadius.circular(18.r),
                      image: hasIcon
                          ? null
                          : (imageProvider ??
                              const AssetImage(Assets.imagesDefault)),
                    ),
                    child: hasIcon
                        ? Center(
                            child: AppText(
                              text: iconEmoji,
                              fontSize: 32.sp,
                            ),
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 16.w),

                // Category Name
                Expanded(
                  child: AppText(
                    text: categoryName,
                    fontSize: AppSize.bodyText,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textColor,
                  ),
                ),

                // Action Buttons
                _buildActionButton(
                  icon: Icons.delete_rounded,
                  color: AppColor.red,
                  onTap: widget.onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 22.sp,
        ),
      ),
    );
  }
}
