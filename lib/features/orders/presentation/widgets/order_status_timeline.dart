import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../data/models/order_model.dart';

class OrderStatusTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const OrderStatusTimeline({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.onTheWay,
      OrderStatus.delivered,
    ];

    final currentIndex = statuses.indexOf(currentStatus);

    // If order is cancelled, show different timeline
    if (currentStatus == OrderStatus.cancelled) {
      return _buildCancelledTimeline();
    }

    return Column(
      children: List.generate(statuses.length, (index) {
        final status = statuses[index];
        final isCompleted = index <= currentIndex;
        final isActive = index == currentIndex;
        final isLast = index == statuses.length - 1;

        return _buildTimelineItem(
          status: status,
          isCompleted: isCompleted,
          isActive: isActive,
          isLast: isLast,
        );
      }),
    );
  }

  Widget _buildTimelineItem({
    required OrderStatus status,
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: AppDecoration.decoration(
                color: isCompleted ? AppColor.mainColor : AppColor.white,
                radius: 16.w,
                showBorder: true,
                borderColor:
                    isCompleted ? AppColor.mainColor : AppColor.borderColor,
                borderWidth: 2,
                shadow: false,
              ),
              child: Center(
                child: Icon(
                  isCompleted ? Icons.check : Icons.circle,
                  size: isCompleted ? 18.sp : 8.sp,
                  color: isCompleted ? AppColor.white : AppColor.borderColor,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40.h,
                color: isCompleted ? AppColor.mainColor : AppColor.borderColor,
              ),
          ],
        ),

        SizedBox(width: 16.w),

        // Status label
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 6.h, bottom: isLast ? 0 : 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: status.arabicLabel,
                  fontSize: AppSize.normalText,
                  fontWeight: isActive ? AppThem().bold : AppThem().regular,
                  color:
                      isCompleted ? AppColor.textColor : AppColor.subGrayText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelledTimeline() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: AppDecoration.decoration(
            color: const Color(0xFFEF4444),
            radius: 16.w,
          ),
          child: Center(
            child: Icon(
              Icons.close,
              size: 18.sp,
              color: AppColor.white,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: AppText(
              text: OrderStatus.cancelled.arabicLabel,
              fontSize: AppSize.normalText,
              fontWeight: AppThem().bold,
              color: const Color(0xFFEF4444),
            ),
          ),
        ),
      ],
    );
  }
}
