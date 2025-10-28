import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/routing/app_routes_methods.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/features/food_menu/presentation/screens/add_food.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_menu, size: AppSize.veryLargeIconSize),
            SizedBox(height: 12.h),
            AppText(
              text: AppMessage.noDishesYet,
              fontWeight: FontWeight.bold,
              fontSize: AppSize.heading2,
            ),
            SizedBox(height: 6.h),
            AppText(
              text: AppMessage.addFirstDish,
              align: TextAlign.center,
              fontSize: AppSize.captionText,
            ),
            SizedBox(height: 16.h),
            AppButtons(
              text: AppMessage.addMeal,
              onPressed: () {
                AppRoutes.pushTo(context, const AddFoodPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
