import 'package:flutter/material.dart';
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
    return SingleChildScrollView(
      child: Row(
        children: [
          FilterChipWithIcon(
            label: AppMessage.all,
            icon: AppIcons.allOrders,
            isSelected: state.selectedStatus == null,
            onTap: () => notifier.filterByStatus(null),
            selectedColor: AppColor.mainColor,
          ),
          FilterChipWithIcon(
            label: AppMessage.statusPending,
            icon: AppIcons.pendingOrder,
            isSelected: state.selectedStatus == OrderStatus.pending,
            onTap: () => notifier.filterByStatus(OrderStatus.pending),
            selectedColor: AppColor.mainColor,
          ),
          FilterChipWithIcon(
            label: AppMessage.statusConfirmed,
            icon: AppIcons.confirmedOrder,
            isSelected: state.selectedStatus == OrderStatus.confirmed,
            onTap: () => notifier.filterByStatus(OrderStatus.confirmed),
            selectedColor: AppColor.mainColor,
          ),
          FilterChipWithIcon(
            label: AppMessage.statusPreparing,
            icon: AppIcons.preparingOrder,
            isSelected: state.selectedStatus == OrderStatus.preparing,
            onTap: () => notifier.filterByStatus(OrderStatus.preparing),
            selectedColor: AppColor.mainColor,
          ),
          FilterChipWithIcon(
            label: AppMessage.statusReady,
            icon: AppIcons.readyOrder,
            isSelected: state.selectedStatus == OrderStatus.ready,
            onTap: () => notifier.filterByStatus(OrderStatus.ready),
            selectedColor: AppColor.mainColor,
          ),
          FilterChipWithIcon(
            label: AppMessage.statusOnTheWay,
            icon: AppIcons.onTheWayOrder,
            isSelected: state.selectedStatus == OrderStatus.onTheWay,
            onTap: () => notifier.filterByStatus(OrderStatus.onTheWay),
            selectedColor: AppColor.mainColor,
          ),
          FilterChipWithIcon(
            label: AppMessage.statusDelivered,
            icon: AppIcons.deliveredOrder,
            isSelected: state.selectedStatus == OrderStatus.delivered,
            onTap: () => notifier.filterByStatus(OrderStatus.delivered),
            selectedColor: AppColor.mainColor,
          ),
        ],
      ),
    );
  }
}
