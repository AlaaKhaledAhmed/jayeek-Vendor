import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/error/handel_post_response.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_bar.dart';
import '../../../../../core/widgets/app_buttons.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/app_text_fields.dart';
import '../../data/models/order_model.dart';
import '../../providers/order_details/order_details_provider.dart';
import '../widgets/order_item_widget.dart';
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
      appBar: AppBarWidget(
        text: AppMessage.orderDetails,
        centerTitle: true,
        hideBackButton: false,
      ),
      body: state.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColor.mainColor,
              ),
            )
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
            size: 64.sp,
            color: AppColor.red,
          ),
          SizedBox(height: 16.h),
          AppText(
            text: AppMessage.wrong,
            fontSize: AppSize.normalText,
            color: AppColor.textColor,
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
                // Order Header Card
                _buildOrderHeader(order),

                SizedBox(height: 16.h),

                // Order Status Timeline
                _buildStatusSection(order),

                SizedBox(height: 16.h),

                // Customer Information
                _buildCustomerInfo(order),

                SizedBox(height: 16.h),

                // Order Items
                _buildOrderItems(order),

                SizedBox(height: 16.h),

                // Order Notes
                if (order.notes != null && order.notes!.isNotEmpty)
                  _buildOrderNotes(order.notes!),

                SizedBox(height: 16.h),

                // Order Summary
                _buildOrderSummary(order),

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

  Widget _buildOrderHeader(OrderModel order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppDecoration.decoration(
        color: AppColor.white,
        radius: 12.r,
        shadow: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: AppMessage.orderNumber,
                    fontSize: AppSize.captionText,
                    color: AppColor.subGrayText,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    text: '#${order.orderNumber}',
                    fontSize: AppSize.heading3,
                    fontWeight: AppThem().bold,
                    color: AppColor.mainColor,
                  ),
                ],
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColor.borderColor),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 18.sp,
                color: AppColor.subGrayText,
              ),
              SizedBox(width: 8.w),
              AppText(
                text: DateFormat('dd/MM/yyyy - HH:mm', 'ar')
                    .format(order.createdAt),
                fontSize: AppSize.smallText,
                color: AppColor.subGrayText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(OrderModel order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppDecoration.decoration(
        color: AppColor.white,
        radius: 12.r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'حالة الطلب',
            fontSize: AppSize.normalText,
            fontWeight: AppThem().bold,
            color: AppColor.textColor,
          ),
          SizedBox(height: 16.h),
          OrderStatusTimeline(currentStatus: order.status),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo(OrderModel order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppDecoration.decoration(
        color: AppColor.white,
        radius: 12.r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: AppMessage.customer,
            fontSize: AppSize.normalText,
            fontWeight: AppThem().bold,
            color: AppColor.textColor,
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(Icons.person_outline, order.customerName),
          SizedBox(height: 8.h),
          _buildInfoRow(Icons.phone_outlined, order.customerPhone),
          if (order.customerAddress != null) ...[
            SizedBox(height: 8.h),
            _buildInfoRow(Icons.location_on_outlined, order.customerAddress!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: AppColor.mainColor,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AppText(
            text: text,
            fontSize: AppSize.smallText,
            color: AppColor.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems(OrderModel order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppDecoration.decoration(
        color: AppColor.white,
        radius: 12.r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: AppMessage.orderItems,
            fontSize: AppSize.normalText,
            fontWeight: AppThem().bold,
            color: AppColor.textColor,
          ),
          SizedBox(height: 12.h),
          ...order.items.map((item) => OrderItemWidget(item: item)),
        ],
      ),
    );
  }

  Widget _buildOrderNotes(String notes) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppDecoration.decoration(
        color: AppColor.white,
        radius: 12.r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notes,
                size: 20.sp,
                color: AppColor.mainColor,
              ),
              SizedBox(width: 8.w),
              AppText(
                text: AppMessage.orderNotes,
                fontSize: AppSize.normalText,
                fontWeight: AppThem().bold,
                color: AppColor.textColor,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: AppDecoration.decoration(
              color: AppColor.backgroundColor,
              radius: 8.r,
            ),
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

  Widget _buildOrderSummary(OrderModel order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppDecoration.decoration(
        color: AppColor.white,
        radius: 12.r,
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            AppMessage.subtotal,
            '${order.subtotal.toStringAsFixed(2)} ${AppMessage.sar}',
            false,
          ),
          SizedBox(height: 8.h),
          _buildSummaryRow(
            AppMessage.deliveryFee,
            '${order.deliveryFee.toStringAsFixed(2)} ${AppMessage.sar}',
            false,
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColor.borderColor),
          SizedBox(height: 12.h),
          _buildSummaryRow(
            AppMessage.orderTotal,
            '${order.total.toStringAsFixed(2)} ${AppMessage.sar}',
            true,
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: AppDecoration.decoration(
              color: order.isPaid
                  ? AppColor.green.withOpacity(0.1)
                  : AppColor.amber.withOpacity(0.1),
              radius: 8.r,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: AppMessage.paymentMethod,
                  fontSize: AppSize.smallText,
                  color: AppColor.textColor,
                ),
                AppText(
                  text: order.paymentMethod ?? 'كاش',
                  fontSize: AppSize.smallText,
                  fontWeight: AppThem().bold,
                  color: AppColor.textColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isBold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: label,
          fontSize: isBold ? AppSize.normalText : AppSize.smallText,
          fontWeight: isBold ? AppThem().bold : AppThem().regular,
          color: AppColor.textColor,
        ),
        AppText(
          text: value,
          fontSize: isBold ? AppSize.heading3 : AppSize.smallText,
          fontWeight: isBold ? AppThem().bold : AppThem().regular,
          color: isBold ? AppColor.mainColor : AppColor.textColor,
        ),
      ],
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case OrderStatus.pending:
        backgroundColor = const Color(0xFFFFF3CD);
        textColor = const Color(0xFFF59E0B);
        break;
      case OrderStatus.confirmed:
        backgroundColor = const Color(0xFFD1ECF1);
        textColor = const Color(0xFF0C5460);
        break;
      case OrderStatus.preparing:
        backgroundColor = const Color(0xFFE7E5FF);
        textColor = const Color(0xFF6366F1);
        break;
      case OrderStatus.ready:
        backgroundColor = const Color(0xFFD1F4E0);
        textColor = const Color(0xFF10B981);
        break;
      case OrderStatus.onTheWay:
        backgroundColor = const Color(0xFFDCEDFF);
        textColor = const Color(0xFF3B82F6);
        break;
      case OrderStatus.delivered:
        backgroundColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF059669);
        break;
      case OrderStatus.cancelled:
        backgroundColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFEF4444);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: AppDecoration.decoration(
        color: backgroundColor,
        radius: 20.r,
      ),
      child: AppText(
        text: status.arabicLabel,
        fontSize: AppSize.smallText,
        fontWeight: AppThem().bold,
        color: textColor,
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
            color: AppColor.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
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
                side: BorderSide(color: AppColor.red),
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
          borderRadius: BorderRadius.circular(12.r),
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
                borderRadius: BorderRadius.circular(8.r),
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
          borderRadius: BorderRadius.circular(12.r),
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
                borderRadius: BorderRadius.circular(8.r),
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
