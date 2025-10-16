import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/app_decoration.dart';
import '../../../../core/widgets/gradient_header_card.dart';
import '../../data/models/order_model.dart';
import 'order_card_components/customer_info_card.dart';
import 'order_card_components/items_preview_section.dart';
import 'order_card_components/order_header_section.dart';
import 'order_card_components/order_total_action_footer.dart';
import 'order_status_helper.dart';

/// بطاقة الطلب الرئيسية - تستخدم مكونات منفصلة للوضوح وسهولة الصيانة
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Ink(
        decoration: AppDecoration.decoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderSection(),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  /// قسم الـ Header مع Gradient عصري
  Widget _buildHeaderSection() {
    return GradientHeaderCard(
      primaryColor: OrderStatusHelper.getStatusColor(order.status),
      secondaryColor: OrderStatusHelper.getStatusSecondaryColor(order.status),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderHeaderSection(
              order: order,
              formattedTime: _formatTime(order.createdAt),
            ),
            SizedBox(height: 16.h),
            CustomerInfoCard(order: order),
          ],
        ),
      ),
    );
  }

  /// قسم المحتوى
  Widget _buildContentSection() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          ItemsPreviewSection(order: order),
          SizedBox(height: 12.h),
          Divider(
            color: AppColor.borderColor.withOpacity(0.5),
            height: 1,
          ),
          SizedBox(height: 12.h),
          OrderTotalActionFooter(order: order),
        ],
      ),
    );
  }

  /// تنسيق الوقت
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} ${AppMessage.minutes}';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm', 'ar').format(dateTime);
    }
  }
}
