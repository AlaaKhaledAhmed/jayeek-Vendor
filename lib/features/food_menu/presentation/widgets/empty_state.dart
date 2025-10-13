import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';

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
            const Icon(Icons.restaurant_menu, size: 72),
            SizedBox(height: 12.h),
            const Text(
              'لا توجد أطباق بعد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6.h),
            const Text(
              'أضف أول طبق لبدء عرض قائمتك هنا.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            AppButtons(text: 'إضافة وجبة', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
