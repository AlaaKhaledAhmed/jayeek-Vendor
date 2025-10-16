import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/photo_permission_service.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/mock/mock_vendor_data.dart';
import '../../data/models/vendor_model.dart';

class ModernProfileHeader extends StatefulWidget {
  final VendorModel vendor;
  final VoidCallback? onRefresh;

  const ModernProfileHeader({
    super.key,
    required this.vendor,
    this.onRefresh,
  });

  @override
  State<ModernProfileHeader> createState() => _ModernProfileHeaderState();
}

class _ModernProfileHeaderState extends State<ModernProfileHeader> {
  String? _coverImagePath;
  String? _logoImagePath;

  @override
  Widget build(BuildContext context) {
    final coverImage =
        _coverImagePath ?? widget.vendor.coverImage ?? widget.vendor.logo;
    final logoImage = _logoImagePath ?? widget.vendor.logo;

    return Container(
      height: 600.h,
      child: Stack(
        children: [
          // الخلفية مع الصورة
          _buildCoverImage(coverImage),

          // طبقة شفافية على الخلفية
          Container(
            height: 600.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // زر تحديث الخلفية
          Positioned(
            top: 50.h,
            right: 16.w,
            child: _buildEditButton(
              icon: Icons.photo_camera_rounded,
              onTap: _updateCoverImage,
            ),
          ),

          // الشعار في المنتصف
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRestaurantLogo(logoImage),
                SizedBox(height: 16.h),
                AppText(
                  text: widget.vendor.restaurantName,
                  fontSize: 24.sp,
                  fontWeight: AppThem().bold,
                  color: Colors.white,
                ),
                SizedBox(height: 12.h),
                _buildRatingBadge(),
              ],
            ),
          ),

          // الإحصائيات في الأسفل
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40.h),
                  _buildStatsRow(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(String? imageUrl) {
    return Container(
      height: 600.h,
      width: double.infinity,
      child: imageUrl != null
          ? _isLocalImage(imageUrl)
              ? Image.file(
                  File(imageUrl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 600.h,
                )
              : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 600.h,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildDefaultCover(),
                )
          : _buildDefaultCover(),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      width: double.infinity,
      height: 600.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.mainColor,
            AppColor.mainColor.resolveOpacity(0.6),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantLogo(String? logoImage) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // دائرة خارجية كبيرة مع تأثير نيون
        Container(
          width: 150.w,
          height: 150.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.amber.withOpacity(0.8),
                Colors.amber.withOpacity(0.3),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.6),
                blurRadius: 30,
                spreadRadius: 8,
              ),
            ],
          ),
        ),

        // دائرة متوسطة بيضاء
        Container(
          width: 140.w,
          height: 140.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),

        // الصورة الفعلية
        Container(
          width: 126.w,
          height: 126.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.mainColor.resolveOpacity(0.1),
          ),
          child: ClipOval(
            child: logoImage != null
                ? (_isLocalImage(logoImage)
                    ? Image.file(
                        File(logoImage),
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        logoImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultLogo(),
                      ))
                : _buildDefaultLogo(),
          ),
        ),

        // زر تحديث الشعار
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _updateLogo,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber, Colors.amber.shade700],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: 18.sp,
                color: Colors.white,
              ),
            ),
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
        size: 60.sp,
        color: AppColor.mainColor,
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber, Colors.amber.shade700],
        ),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Colors.white,
            size: 20.sp,
          ),
          SizedBox(width: 6.w),
          AppText(
            text: widget.vendor.rating?.toString() ?? '0.0',
            fontWeight: AppThem().bold,
            color: Colors.white,
            fontSize: 16.sp,
          ),
          SizedBox(width: 8.w),
          AppText(
            text: '(${_formatNumber(widget.vendor.totalOrders ?? 0)} طلب)',
            color: Colors.white,
            fontSize: 13.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            value: _formatNumber(widget.vendor.totalOrders ?? 0),
            label: 'إجمالي الطلبات',
            icon: Icons.shopping_bag_rounded,
          ),
          _buildStatDivider(),
          _buildStatItem(
            value: '${_formatCurrency(widget.vendor.totalSales ?? 0)}K',
            label: 'إجمالي المبيعات',
            icon: Icons.payments_rounded,
          ),
          _buildStatDivider(),
          _buildStatItem(
            value: _calculateYearsSince(widget.vendor.createdAt),
            label: 'سنوات الخبرة',
            icon: Icons.calendar_today_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
            SizedBox(height: 10.h),
            AppText(
              text: value,
              fontSize: 18.sp,
              fontWeight: AppThem().bold,
              color: Colors.white,
            ),
            SizedBox(height: 3.h),
            AppText(
              text: label,
              fontSize: 10.sp,
              color: Colors.white.withOpacity(0.9),
              align: TextAlign.center,
              maxLine: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1.w,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.4),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
        ),
      ),
    );
  }

  // دوال رفع الصور
  Future<void> _updateCoverImage() async {
    final granted = await AppPermissions.photoPermission(context: context);
    if (!granted) return;

    final path = await AppImagePicker.pickFromGallery(imageQuality: 85);
    if (path != null) {
      setState(() {
        _coverImagePath = path;
      });

      MockVendorData.updateVendorInfo(coverImage: path);

      AppSnackBar.show(
        message: 'تم تحديث خلفية المطعم بنجاح',
        type: ToastType.success,
      );

      widget.onRefresh?.call();
    }
  }

  Future<void> _updateLogo() async {
    final granted = await AppPermissions.photoPermission(context: context);
    if (!granted) return;

    final path = await AppImagePicker.pickFromGallery(imageQuality: 85);
    if (path != null) {
      setState(() {
        _logoImagePath = path;
      });

      MockVendorData.updateVendorInfo(logo: path);

      AppSnackBar.show(
        message: 'تم تحديث شعار المطعم بنجاح',
        type: ToastType.success,
      );

      widget.onRefresh?.call();
    }
  }

  bool _isLocalImage(String path) {
    return path.startsWith('/') || path.startsWith('file://');
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      return (amount / 1000).toStringAsFixed(1);
    }
    return amount.toStringAsFixed(0);
  }

  String _calculateYearsSince(DateTime? date) {
    if (date == null) return '0';
    final now = DateTime.now();
    final difference = now.difference(date);
    final years = (difference.inDays / 365).floor();

    if (years == 0) {
      final months = (difference.inDays / 30).floor();
      return months > 0 ? '${months}شهر' : 'جديد';
    } else if (years == 1) {
      return 'سنة';
    } else if (years == 2) {
      return 'سنتان';
    } else if (years >= 3 && years <= 10) {
      return '$years سنوات';
    } else {
      return '$years سنة';
    }
  }
}
