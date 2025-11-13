import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import 'package:jayeek_vendor/core/routing/app_routes_methods.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_image_placeholder.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import '../../domain/models/menu_item_model.dart';
import '../../providers/menu/menu_provider.dart';
import '../screens/update_food.dart';
import 'customizable_badge.dart';
import 'price_chip.dart';

class MenuItemCard extends ConsumerWidget {
  final MenuItemModel item;
  final bool showCategoryName;

  const MenuItemCard({
    super.key,
    required this.item,
    this.showCategoryName = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(menuProvider.notifier);

    return InkWell(
      onTap: () {
        // Navigate to update page with itemId
        final itemId = int.tryParse(item.id);
        if (itemId != null) {
          AppRoutes.pushTo(context, UpdateFoodPage(itemId: itemId));
        }
      },
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        decoration: AppDecoration.decoration(radius: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image + badges + price chip
            Stack(
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Hero(
                      tag: 'menu-image-${item.id}',
                      child: (item.imageUrl.isEmpty ||
                              item.imageUrl == 'string' ||
                              item.imageUrl.length < 3)
                          ? const AppImagePlaceholder()
                          : Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: const Icon(Icons.image_not_supported),
                              ),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(color: Colors.grey.shade200);
                              },
                            ),
                    ),
                  ),
                ),

                // Price chip
                Positioned(
                  bottom: 8.h,
                  left: 8.w,
                  child: PriceChip(price: item.price),
                ),

                // Customizable banner
                if (item.isCustomizable) const CustomizableBadge(),

                // Out of stock overlay
                if (!item.isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: AppDecoration.decoration(
                        color: Colors.black.resolveOpacity(0.35),
                        shadow: false,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        text: AppMessage.notAvailableTemp,
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppSize.bodyText,
                      ),
                    ),
                  ),
              ],
            ),

            // Title + description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text: item.name,
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis,
                          fontSize: AppSize.bodyText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      // Category chip - show only when showCategoryName is true
                      if (showCategoryName &&
                          (item.categoryName?.isNotEmpty == true ||
                              item.categoryNameAr?.isNotEmpty == true))
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: AppDecoration.decoration(
                            color: AppColor.subtextColor,
                            radius: 24,
                            shadow: false,
                          ),
                          child: AppText(
                            text:
                                item.categoryNameAr ?? item.categoryName ?? '',
                            fontSize: AppSize.smallText,
                            color: AppColor.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    text: item.description,
                    maxLine: 2,
                    overflow: TextOverflow.ellipsis,
                    fontSize: AppSize.smallText,
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color?.withOpacity(0.8),
                  ),
                ],
              ),
            ),

            // Actions row
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              child: Row(
                children: [
                  // Availability toggle
                  Switch(
                    activeColor: AppColor.subtextColor,
                    value: item.isAvailable,
                    onChanged: (_) => notifier.toggleAvailability(item.id),
                  ),
                  const Spacer(),

                  IconButton(
                    tooltip: AppMessage.delete,
                    onPressed: () => _confirmDelete(context, () async {
                      await notifier.deleteItem(item.id);
                    }),
                    icon: Icon(AppIcons.delete, color: AppColor.mediumGray),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const AppText(
          text: AppMessage.deleteMeal,
          fontWeight: FontWeight.bold,
        ),
        content: const AppText(text: AppMessage.deleteMealConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const AppText(text: AppMessage.cancel),
          ),
          AppButtons(
            text: AppMessage.delete,
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
          ),
        ],
      ),
    );
  }
}
