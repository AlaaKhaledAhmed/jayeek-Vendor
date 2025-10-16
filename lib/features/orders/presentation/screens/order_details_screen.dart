import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/custom_load.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/error/handel_post_response.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_bar.dart';
import '../../../../../core/widgets/app_buttons.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_fields.dart';
import '../../data/models/order_model.dart';
import '../../providers/order_details/order_details_provider.dart';
import '../widgets/order_details_components/customer_info_card.dart';
import '../widgets/order_details_components/order_header_card.dart';
import '../widgets/order_details_components/order_items_card.dart';
import '../widgets/order_details_components/order_summary_card.dart';
import '../widgets/order_status_timeline.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderDetailsProvider.notifier).loadOrderDetails(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderDetailsProvider);
    final notifier = ref.read(orderDetailsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const AppBarWidget(
        text: AppMessage.orderDetails,
        centerTitle: true,
        hideBackButton: false,
      ),
      body: state.isLoading
          ? CustomLoad().loadVerticalList(context: context)
          : state.hasError || state.order == null
              ? _buildErrorState()
              : _buildOrderDetails(state.order!, notifier),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80.sp,
            color: AppColor.red.withOpacity(0.5),
          ),
          SizedBox(height: 24.h),
          AppText(
            text: AppMessage.wrong,
            fontSize: AppSize.heading3,
            fontWeight: AppThem().bold,
            color: AppColor.textColor,
          ),
          SizedBox(height: 8.h),
          AppText(
            text: 'لم نتمكن من تحميل تفاصيل الطلب',
            fontSize: AppSize.normalText,
            color: AppColor.subGrayText,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(OrderModel order, notifier) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSize.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // استخدام OrderHeaderCard Component
                OrderHeaderCard(order: order),
                SizedBox(height: 16.h),

                // استخدام CustomerInfoCard Component
                CustomerInfoCard(order: order),
                SizedBox(height: 16.h),

                // استخدام OrderItemsCard Component
                OrderItemsCard(order: order),
                SizedBox(height: 16.h),

                // Order Notes
                if (order.notes != null && order.notes!.isNotEmpty)
                  _buildModernOrderNotes(order.notes!),

                if (order.notes != null && order.notes!.isNotEmpty)
                  SizedBox(height: 16.h),

                // استخدام OrderSummaryCard Component
                OrderSummaryCard(order: order),

                SizedBox(height: 100.h), // Space for bottom buttons
              ],
            ),
          ),
        ),

        // Action Buttons
        if (order.status != OrderStatus.cancelled &&
            order.status != OrderStatus.delivered)
          _buildActionButtons(order, notifier),
      ],
    );
  }

  /// Modern Order Notes بتصميم عصري
  Widget _buildModernOrderNotes(String notes) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: AppDecoration.decoration(

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColor.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.speaker_notes_rounded,
                  size: 20.sp,
                  color: AppColor.amber,
                ),
              ),
              SizedBox(width: 12.w),
              AppText(
                text: AppMessage.orderNotes,
                fontSize: AppSize.normalText,
                fontWeight: AppThem().bold,
                color: AppColor.textColor,
              ),
            ],
          ),
          const Divider(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            decoration:
                AppDecoration.decoration(shadow: false, showBorder: true),
            child: AppText(
              text: notes,
              fontSize: AppSize.smallText,
              color: AppColor.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(OrderModel order, notifier) {
    final state = ref.watch(orderDetailsProvider);

    return Container(
      padding: EdgeInsets.all(AppSize.horizontalPadding),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: _buildButtonsForStatus(order, notifier, state.isUpdating),
      ),
    );
  }

  Widget _buildButtonsForStatus(OrderModel order, notifier, bool isUpdating) {
    switch (order.status) {
      case OrderStatus.pending:
        return Row(
          children: [
            Expanded(
              child: AppButtons(
                text: AppMessage.rejectOrder,
                onPressed: () => _showRejectDialog(notifier),
                backgroundColor: AppColor.white,
                textStyleColor: AppColor.red,
                side: BorderSide(color: AppColor.red, width: 1.5),
                showLoader: isUpdating,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 2,
              child: AppButtons(
                text: AppMessage.acceptOrder,
                onPressed: () => _showAcceptDialog(notifier),
                backgroundColor: AppColor.mainColor,
                showLoader: isUpdating,
              ),
            ),
          ],
        );

      case OrderStatus.confirmed:
        return AppButtons(
          text: AppMessage.markAsPreparing,
          onPressed: () => _updateStatus(notifier, OrderStatus.preparing),
          width: double.infinity,
          backgroundColor: AppColor.mainColor,
          showLoader: isUpdating,
        );

      case OrderStatus.preparing:
        return AppButtons(
          text: AppMessage.markAsReady,
          onPressed: () => _updateStatus(notifier, OrderStatus.ready),
          width: double.infinity,
          backgroundColor: AppColor.mainColor,
          showLoader: isUpdating,
        );

      case OrderStatus.ready:
        return AppButtons(
          text: AppMessage.markAsOnTheWay,
          onPressed: () => _updateStatus(notifier, OrderStatus.onTheWay),
          width: double.infinity,
          backgroundColor: AppColor.mainColor,
          showLoader: isUpdating,
        );

      case OrderStatus.onTheWay:
        return AppButtons(
          text: AppMessage.markAsDelivered,
          onPressed: () => _updateStatus(notifier, OrderStatus.delivered),
          width: double.infinity,
          backgroundColor: AppColor.green,
          showLoader: isUpdating,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void _showAcceptDialog(notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: AppText(
          text: AppMessage.confirmAccept,
          fontSize: AppSize.heading3,
          fontWeight: AppThem().bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: AppMessage.acceptOrderMessage,
              fontSize: AppSize.normalText,
              color: AppColor.subGrayText,
            ),
            SizedBox(height: 16.h),
            AppTextFields(
              hintText: AppMessage.enterEstimatedTime,
              controller: notifier.estimatedTimeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => null,
              suffix: AppText(
                text: AppMessage.minutes,
                fontSize: AppSize.captionText,
                color: AppColor.subGrayText,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(
              text: AppMessage.cancel,
              color: AppColor.subGrayText,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HandelPostRequest.handlePostRequest(
                context: context,
                request: notifier.acceptOrder,
                formKey: null,
                onSuccess: (data) {
                  // Success handled
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: AppText(
              text: AppMessage.confirmAccept,
              color: AppColor.white,
              fontWeight: AppThem().bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: AppText(
          text: AppMessage.confirmReject,
          fontSize: AppSize.heading3,
          fontWeight: AppThem().bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: AppMessage.rejectOrderMessage,
              fontSize: AppSize.normalText,
              color: AppColor.subGrayText,
            ),
            SizedBox(height: 16.h),
            AppTextFields(
              hintText: AppMessage.enterRejectionReason,
              controller: notifier.rejectionReasonController,
              maxLines: 3,
              validator: (value) => null,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(
              text: AppMessage.cancel,
              color: AppColor.subGrayText,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HandelPostRequest.handlePostRequest(
                context: context,
                request: notifier.rejectOrder,
                formKey: null,
                onSuccess: (data) {
                  Navigator.pop(context); // Go back to orders list
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: AppText(
              text: AppMessage.confirmReject,
              color: AppColor.white,
              fontWeight: AppThem().bold,
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatus(notifier, OrderStatus newStatus) {
    HandelPostRequest.handlePostRequest(
      context: context,
      request: () => notifier.updateStatus(newStatus),
      formKey: null,
      onSuccess: (data) {
        // Status updated successfully
      },
    );
  }
}
