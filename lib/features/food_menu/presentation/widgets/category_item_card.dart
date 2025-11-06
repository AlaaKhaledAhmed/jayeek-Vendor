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

  bool _isEmoji() {
    if (widget.category.image != null &&
        widget.category.image!.isNotEmpty &&
        widget.category.image != 'string' &&
        widget.category.image!.length <= 4) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _getImageProvider();
    final categoryName = _getCategoryName();
    final isEmoji = _isEmoji();

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
                // Modern Image/Emoji Container
                Hero(
                  tag: 'category_${widget.category.id}',
                  child: Container(
                    width: 75.w,
                    height: 75.w,
                    decoration: AppDecoration.decoration(
                      shadow: false,
                      showBorder: true,
                      color: isEmoji
                          ? null
                          : AppColor.lightGray.resolveOpacity(0.5),
                      borderRadius: BorderRadius.circular(18.r),
                      image: isEmoji
                          ? null
                          : (imageProvider ??
                              const AssetImage(Assets.imagesDefault)),
                    ),
                    child: isEmoji
                        ? Center(
                            child: AppText(
                              text: widget.category.image!,
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
