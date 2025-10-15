import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/routing/app_routes_methods.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_bar.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../data/models/order_model.dart';
import '../../providers/orders_list/orders_list_provider.dart';
import '../widgets/order_card.dart';
import '../widgets/status_filter_chip.dart';
import 'order_details_screen.dart';

class OrdersListScreen extends ConsumerStatefulWidget {
  const OrdersListScreen({super.key});

  @override
  ConsumerState<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends ConsumerState<OrdersListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load orders on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersListProvider.notifier).loadOrders();
    });

    // Setup pagination
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(ordersListProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ordersListProvider);
    final notifier = ref.read(ordersListProvider.notifier);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBarWidget(
        text: AppMessage.orders,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: AppColor.white,
              size: 24.sp,
            ),
            onPressed: () => notifier.refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Filter Chips
          _buildFilterChips(state.selectedStatus, notifier),

          SizedBox(height: 16.h),

          // Orders List
          Expanded(
            child: _buildOrdersList(state, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(OrderStatus? selectedStatus, notifier) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
        children: [
          StatusFilterChip(
            label: AppMessage.all,
            isSelected: selectedStatus == null,
            onTap: () => notifier.filterByStatus(null),
          ),
          StatusFilterChip(
            label: AppMessage.statusPending,
            isSelected: selectedStatus == OrderStatus.pending,
            onTap: () => notifier.filterByStatus(OrderStatus.pending),
          ),
          StatusFilterChip(
            label: AppMessage.statusConfirmed,
            isSelected: selectedStatus == OrderStatus.confirmed,
            onTap: () => notifier.filterByStatus(OrderStatus.confirmed),
          ),
          StatusFilterChip(
            label: AppMessage.statusPreparing,
            isSelected: selectedStatus == OrderStatus.preparing,
            onTap: () => notifier.filterByStatus(OrderStatus.preparing),
          ),
          StatusFilterChip(
            label: AppMessage.statusReady,
            isSelected: selectedStatus == OrderStatus.ready,
            onTap: () => notifier.filterByStatus(OrderStatus.ready),
          ),
          StatusFilterChip(
            label: AppMessage.statusOnTheWay,
            isSelected: selectedStatus == OrderStatus.onTheWay,
            onTap: () => notifier.filterByStatus(OrderStatus.onTheWay),
          ),
          StatusFilterChip(
            label: AppMessage.statusDelivered,
            isSelected: selectedStatus == OrderStatus.delivered,
            onTap: () => notifier.filterByStatus(OrderStatus.delivered),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(state, notifier) {
    // Loading State
    if (state.isLoading && state.orders.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColor.mainColor,
        ),
      );
    }

    // Error State
    if (state.hasError && state.orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppColor.red,
            ),
            SizedBox(height: 16.h),
            AppText(
              text: state.errorMessage ?? AppMessage.wrong,
              fontSize: AppSize.normalText,
              color: AppColor.textColor,
              align: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => notifier.refresh(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.mainColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: AppText(
                text: AppMessage.tryAgain,
                color: AppColor.white,
                fontSize: AppSize.normalText,
                fontWeight: AppThem().bold,
              ),
            ),
          ],
        ),
      );
    }

    // Empty State
    if (state.orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80.sp,
              color: AppColor.borderColor,
            ),
            SizedBox(height: 16.h),
            AppText(
              text: AppMessage.noOrdersYet,
              fontSize: AppSize.heading3,
              fontWeight: AppThem().bold,
              color: AppColor.textColor,
            ),
            SizedBox(height: 8.h),
            AppText(
              text: AppMessage.noOrdersMessage,
              fontSize: AppSize.normalText,
              color: AppColor.subGrayText,
              align: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Success State
    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      color: AppColor.mainColor,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.horizontalPadding,
          vertical: 8.h,
        ),
        itemCount: state.orders.length + (state.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.orders.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: CircularProgressIndicator(
                  color: AppColor.mainColor,
                ),
              ),
            );
          }

          final order = state.orders[index];
          return OrderCard(
            order: order,
            onTap: () {
              AppRoutes.pushTo(
                context,
                OrderDetailsScreen(orderId: order.id),
              );
            },
          );
        },
      ),
    );
  }
}
