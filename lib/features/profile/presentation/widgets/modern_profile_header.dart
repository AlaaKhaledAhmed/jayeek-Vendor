import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    // استخدام الصور المحلية أو الصور من الشبكة
    final coverImage =
        _coverImagePath ?? widget.vendor.coverImage ?? widget.vendor.logo;
    final logoImage = _logoImagePath ?? widget.vendor.logo;

    return Stack(
      children: [
        // خلفية المطعم
        _buildCoverImage(coverImage),

        // تدرج لوني في الأسفل
        _buildGradientOverlay(),

        // المحتوى
        _buildContent(logoImage),
      ],
    );
  }

  Widget _buildCoverImage(String? imageUrl) {
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.mainColor,
      ),
      child: imageUrl != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                // الصورة
                _isLocalImage(imageUrl)
                    ? Image.file(
                        File(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultCover(),
                      ),

                // زر تحديث الخلفية
                Positioned(
                  top: 50.h,
                  right: 16.w,
                  child: _buildEditButton(
                    icon: Icons.photo_camera_rounded,
                    onTap: _updateCoverImage,
                    tooltip: 'تحديث خلفية المطعم',
                  ),
                ),
              ],
            )
          : _buildDefaultCover(),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.mainColor,
            AppColor.mainColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_rounded,
              size: 80.sp,
              color: Colors.white.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            AppText(
              text: 'اضغط لإضافة خلفية المطعم',
              color: Colors.white.withOpacity(0.7),
              fontSize: AppSize.smallText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 150.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(String? logoImage) {
    return Positioned(
      bottom: 20.h,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // شعار المطعم
          _buildRestaurantLogo(logoImage),

          SizedBox(height: 16.h),

          // اسم المطعم
          AppText(
            text: widget.vendor.restaurantName,
            fontSize: AppSize.heading2,
            fontWeight: AppThem().bold,
            color: Colors.white,
          ),

          SizedBox(height: 8.h),

          // التقييم
          if (widget.vendor.rating != null) _buildRating(),

          SizedBox(height: 24.h),

          // بطاقات الإحصائيات مع Glass Effect
          _buildStatsCards(),
        ],
      ),
    );
  }

  Widget _buildRestaurantLogo(String? logoImage) {
    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
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
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColor.mainColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
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
      color: AppColor.mainColor.withOpacity(0.1),
      child: Icon(
        Icons.restaurant_rounded,
        size: 40.sp,
        color: AppColor.mainColor,
      ),
    );
  }

  Widget _buildRating() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: widget.vendor.rating.toString(),
            fontWeight: AppThem().bold,
            color: Colors.white,
            fontSize: AppSize.normalText,
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.star,
            color: Colors.white,
            size: 18.sp,
          ),
          SizedBox(width: 4.w),
          AppText(
            text: '(${widget.vendor.totalOrders ?? 0} طلب)',
            color: Colors.white,
            fontSize: AppSize.captionText,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: _buildGlassCard(
              icon: Icons.shopping_bag_rounded,
              value: _formatNumber(widget.vendor.totalOrders ?? 0),
              label: 'إجمالي الطلبات',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildGlassCard(
              icon: Icons.payments_rounded,
              value: '${_formatCurrency(widget.vendor.totalSales ?? 0)}K',
              label: 'إجمالي المبيعات',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 12.h),
              AppText(
                text: value,
                fontSize: AppSize.heading2,
                fontWeight: AppThem().bold,
                color: Colors.white,
              ),
              SizedBox(height: 4.h),
              AppText(
                text: label,
                fontSize: AppSize.captionText,
                color: Colors.white.withOpacity(0.9),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
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
                color: Colors.white.withOpacity(0.2),
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

      // تحديث البيانات في MockVendorData
      MockVendorData.updateVendorInfo(coverImage: path);

      // TODO: في التطبيق الحقيقي، رفع الصورة للسيرفر
      // await repository.uploadCoverImage(path);

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

      // تحديث البيانات في MockVendorData
      MockVendorData.updateVendorInfo(logo: path);

      // TODO: في التطبيق الحقيقي، رفع الصورة للسيرفر
      // await repository.uploadLogo(path);

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
}
