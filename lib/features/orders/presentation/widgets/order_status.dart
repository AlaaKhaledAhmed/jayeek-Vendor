import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/features/orders/providers/orders_list/orders_list_state.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/filter_chip_with_icon.dart';
import '../../data/models/order_model.dart';
import '../../providers/orders_list/orders_list_notifier.dart';

class OrderByCategories extends StatelessWidget {
  final OrdersListState state;
  final OrdersListNotifier notifier;

  const OrderByCategories(
      {super.key, required this.notifier, required this.state});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      {'label': AppMessage.all, 'icon': AppIcons.allOrders, 'status': null},
      {
        'label': AppMessage.statusPending,
        'icon': AppIcons.pendingOrder,
        'status': OrderStatus.pending
      },
      {
        'label': AppMessage.statusConfirmed,
        'icon': AppIcons.confirmedOrder,
        'status': OrderStatus.confirmed
      },
      {
        'label': AppMessage.statusPreparing,
        'icon': AppIcons.preparingOrder,
        'status': OrderStatus.preparing
      },
      {
        'label': AppMessage.statusReady,
        'icon': AppIcons.readyOrder,
        'status': OrderStatus.ready
      },
      {
        'label': AppMessage.statusOnTheWay,
        'icon': AppIcons.onTheWayOrder,
        'status': OrderStatus.onTheWay
      },
      {
        'label': AppMessage.statusDelivered,
        'icon': AppIcons.deliveredOrder,
        'status': OrderStatus.delivered
      },
    ];

    return SizedBox(
      height: 50.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: statuses.length,
        separatorBuilder: (_, __) => SizedBox(width: 2.w),
        itemBuilder: (_, i) {
          final item = statuses[i];
          final selected = state.selectedStatus == item['status'];
          final isAll = item['status'] == null;

          return FilterChipWithIcon(
            label: item['label'] as String,
            icon: item['icon'] as IconData,
            isSelected: selected,
            onTap: () =>
                notifier.filterByStatus(item['status'] as OrderStatus?),
            selectedColor: AppColor.subtextColor,
            borderRadius: 25,
            showIcon: !isAll, // اخفِ الأيقونة في "الكل"
            showLabel: isAll, // اعرض النص في "الكل" فقط
          );
        },
      ),
    );
  }
}
