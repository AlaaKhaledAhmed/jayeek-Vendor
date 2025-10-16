import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/widgets/app_decoration.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/vendor_model.dart';

/// رأس صفحة البروفايل مع معلومات المطعم الأساسية
class ProfileHeader extends StatelessWidget {
  final VendorModel vendor;

  const ProfileHeader({
    super.key,
    required this.vendor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.mainColor,
            AppColor.mainColor.resolveOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: 20.h),

            // Logo & Restaurant Name
            _buildRestaurantInfo(),

            SizedBox(height: 24.h),

            // Stats Cards
            _buildStatsRow(),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Column(
      children: [
        // Restaurant Logo
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: AppColor.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColor.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.resolveOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: vendor.logo != null
                ? Image.network(
                    vendor.logo!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildDefaultLogo(),
                  )
                : _buildDefaultLogo(),
          ),
        ),

        SizedBox(height: 16.h),

        // Restaurant Name
        AppText(
          text: vendor.restaurantName,
          fontSize: AppSize.heading2,
          fontWeight: AppThem().bold,
          color: AppColor.white,
        ),

        SizedBox(height: 8.h),

        // Rating
        if (vendor.rating != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: AppDecoration.decoration(
              color: AppColor.white.resolveOpacity(0.2),
              radius: 20,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: AppColor.amber,
                  size: 20.sp,
                ),
                SizedBox(width: 6.w),
                AppText(
                  text: vendor.rating!.toStringAsFixed(1),
                  fontSize: AppSize.normalText,
                  fontWeight: AppThem().bold,
                  color: AppColor.white,
                ),
                SizedBox(width: 4.w),
                AppText(
                  text: '(${vendor.totalOrders ?? 0} طلب)',
                  fontSize: AppSize.captionText,
                  color: AppColor.white.resolveOpacity(0.9),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultLogo() {
    return Container(
      color: AppColor.mainColor.resolveOpacity(0.1),
      child: Icon(
        Icons.restaurant_rounded,
        size: 40.sp,
        color: AppColor.mainColor,
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.receipt_long_rounded,
              label: 'إجمالي الطلبات',
              value: _formatNumber(vendor.totalOrders ?? 0),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              icon: Icons.payments_rounded,
              label: 'إجمالي المبيعات',
              value: _formatCurrency(vendor.totalSales ?? 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppDecoration.decoration(
        color: AppColor.white.resolveOpacity(0.15),
        radius: 16,
        showBorder: true,
        borderColor: AppColor.white.resolveOpacity(0.2),
        shadow: false,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColor.white.resolveOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24.sp,
              color: AppColor.white,
            ),
          ),
          SizedBox(height: 12.h),
          AppText(
            text: value,
            fontSize: AppSize.heading3,
            fontWeight: AppThem().bold,
            color: AppColor.white,
          ),
          SizedBox(height: 4.h),
          AppText(
            text: label,
            fontSize: AppSize.captionText,
            color: AppColor.white.resolveOpacity(0.9),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
