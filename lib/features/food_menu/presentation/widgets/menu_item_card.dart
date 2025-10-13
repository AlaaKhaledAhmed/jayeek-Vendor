import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/routing/app_routes_methods.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import '../../domain/models/menu_item_model.dart';
import '../../providers/menu/menu_provider.dart';
import '../screens/update_item.dart';
import 'price_chip.dart';

class MenuItemCard extends ConsumerWidget {
  final MenuItemModel item;

  const MenuItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(menuProvider.notifier);

    return InkWell(
      onTap: () {
        // Navigate to update page
        AppRoutes.pushTo(context, UpdateItemPage(item: item));
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
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
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

                // Out of stock overlay
                if (!item.isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'غير متاح مؤقتًا',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      // Category chip small
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.subtextColor,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColor.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(
                        context,
                      ).textTheme.bodySmall?.color?.withOpacity(0.8),
                    ),
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
                  Row(
                    children: [
                      const Icon(Icons.visibility),
                      Switch(
                        activeColor: AppColor.subtextColor,
                        value: item.isAvailable,
                        onChanged: (_) => notifier.toggleAvailability(item.id),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'تعديل',
                    onPressed: () {
                      AppRoutes.pushTo(context, UpdateItemPage(item: item));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    tooltip: 'حذف',
                    onPressed: () => _confirmDelete(context, () {
                      notifier.deleteItem(item.id);
                    }),
                    icon: const Icon(Icons.delete_outline),
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
        title: const Text('حذف الوجبة؟'),
        content: const Text(
          'هل أنت متأكد أنك تريد حذف هذه الوجبة؟ لا يمكن التراجع.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          AppButtons(
            text: 'حذف',
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
