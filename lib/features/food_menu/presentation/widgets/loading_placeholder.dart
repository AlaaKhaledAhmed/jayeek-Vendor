import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(12.w),
      itemBuilder: (_, __) => Container(
        height: 160.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemCount: 5,
    );
  }
}
