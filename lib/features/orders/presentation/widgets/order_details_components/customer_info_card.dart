import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/extensions/color_extensions.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/order_model.dart';

/// بطاقة معلومات العميل بتصميم عصري مع إمكانية الاتصال
class CustomerInfoCard extends StatelessWidget {
  final OrderModel order;

  const CustomerInfoCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecoration.decoration(),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          const Divider(endIndent: 10,indent: 10,height: 5, ),
          // Content
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              children: [
                _buildInfoItem(
                  icon: Icons.badge_rounded,
                  label: 'الاسم',
                  value: order.customerName,
                  iconColor: AppColor.mainColor,
                ),
                SizedBox(height: 12.h),
                _buildPhoneItem(context, order.customerPhone),
                if (order.customerAddress != null) ...[
                  SizedBox(height: 12.h),
                  _buildInfoItem(
                    icon: Icons.location_on_rounded,
                    label: 'العنوان',
                    value: order.customerAddress!,
                    iconColor: AppColor.red,
                    isMultiline: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Header Section
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColor.subtextColor.resolveOpacity(0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.person_rounded,
              color: AppColor.subtextColor,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: AppMessage.customer,
                fontSize: AppSize.heading3,
                fontWeight: AppThem().bold,
                color: AppColor.textColor,
              ),
              SizedBox(height: 2.h),
              AppText(
                text: 'معلومات التواصل',
                fontSize: AppSize.captionText,
                color: AppColor.subGrayText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Info Item Row
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    bool isMultiline = false,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: AppDecoration.decoration(
        shadow: false,
        showBorder: true,
      ),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 20.sp, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: label,
                  fontSize: AppSize.captionText,
                  color: AppColor.subGrayText,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 4.h),
                AppText(
                  text: value,
                  fontSize: AppSize.normalText,
                  color: AppColor.textColor,
                  fontWeight: AppThem().bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Phone Item with Call Button
  Widget _buildPhoneItem(BuildContext context, String phone) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: AppDecoration.decoration(
        shadow: false,
        showBorder: true,
        borderColor: AppColor.green.withOpacity(0.3),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColor.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.phone_rounded,
              size: 20.sp,
              color: AppColor.green,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'رقم الهاتف',
                  fontSize: AppSize.captionText,
                  color: AppColor.subGrayText,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 4.h),
                AppText(
                  text: phone,
                  fontSize: AppSize.normalText,
                  color: AppColor.textColor,
                  fontWeight: AppThem().bold,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _makePhoneCall(phone),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColor.green,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.call_rounded, color: AppColor.white, size: 18.sp),
                  SizedBox(width: 6.w),
                  AppText(
                    text: 'اتصال',
                    fontSize: AppSize.captionText,
                    color: AppColor.white,
                    fontWeight: AppThem().bold,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Make Phone Call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      debugPrint('Could not launch phone call: $e');
    }
  }
}
