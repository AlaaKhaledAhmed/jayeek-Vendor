import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/photo_permission_service.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/unified_bottom_sheet.dart';
import '../../data/models/vendor_model.dart';
import '../../providers/profile_provider.dart';

class ModernProfileHeader extends ConsumerStatefulWidget {
  final VendorModel vendor;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const ModernProfileHeader({
    super.key,
    required this.vendor,
    this.isLoading = false,
    this.onRefresh,
  });

  @override
  ConsumerState<ModernProfileHeader> createState() =>
      _ModernProfileHeaderState();
}

class _ModernProfileHeaderState extends ConsumerState<ModernProfileHeader> {
  String? _coverImagePath;
  String? _logoImagePath;
  bool _isUpdatingCover = false;
  bool _isUpdatingLogo = false;

  @override
  Widget build(BuildContext context) {
    // Use local path if exists, otherwise use vendor data
    // Cover image should only use coverImage, not profileImage
    final coverImage = _coverImagePath ?? widget.vendor.coverImage;
    // Logo should only use profileImage or logo, not coverImage
    final logoImage =
        _logoImagePath ?? widget.vendor.profileImage ?? widget.vendor.logo;

    return Container(
      height: 600.h,
      child: Stack(
        children: [
          // الخلفية مع الصورة
          _buildCoverImage(coverImage, isLoading: _isUpdatingCover),

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
            child: _isUpdatingCover
                ? Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.mainColor,
                      ),
                    ),
                  )
                : _buildEditButton(
                    icon: Icons.photo_camera_rounded,
                    onTap: _updateCoverImage,
                  ),
          ),

          // الشعار في المنتصف
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRestaurantLogo(logoImage, isLoading: _isUpdatingLogo),
                SizedBox(height: 16.h),
                AppText(
                  text: widget.vendor.restaurantName ?? widget.vendor.name,
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

  Widget _buildCoverImage(String? imageUrl, {bool isLoading = false}) {
    return Container(
      height: 600.h,
      width: double.infinity,
      child: isLoading
          ? Stack(
              children: [
                _buildDefaultCover(),
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : (_isValidImage(imageUrl)
              ? _getImageWidget(imageUrl!,
                  height: 600.h, width: double.infinity)
              : _buildDefaultCover()),
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

  Widget _buildRestaurantLogo(String? logoImage, {bool isLoading = false}) {
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
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.mainColor,
                      strokeWidth: 2,
                    ),
                  )
                : (_isValidImage(logoImage)
                    ? _getImageWidget(logoImage!)
                    : _buildDefaultLogo()),
          ),
        ),

        // زر تحديث الشعار
        Positioned(
          bottom: 0,
          right: 0,
          child: _isUpdatingLogo
              ? Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3.w,
                    ),
                  ),
                  child: SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : GestureDetector(
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

    // Pick image first
    final path = await AppImagePicker.pickFromGallery(imageQuality: 85);
    if (path == null) return;

    // Check file size (1 MB = 1024 * 1024 bytes)
    try {
      final file = File(path);
      final fileSize = await file.length();
      const maxSize = 1024 * 1024; // 1 MB in bytes

      if (fileSize > maxSize) {
        AppSnackBar.show(
          message: AppMessage.imageSizeExceedsLimit,
          type: ToastType.error,
        );
        return;
      }
    } catch (e) {
      AppSnackBar.show(
        message: AppMessage.errorCheckingImageSize,
        type: ToastType.error,
      );
      return;
    }

    // Show confirmation bottom sheet with image preview
    final confirmed = await UnifiedBottomSheet.showCustom<bool>(
      context: context,
      title: 'تغيير صورة الخلفية',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: 'هل تريد استخدام هذه الصورة كصورة خلفية؟',
              fontSize: AppSize.normalText,
              color: AppColor.subGrayText,
              align: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.file(
                File(path),
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: AppButtons(
                    text: AppMessage.cancel,
                    onPressed: () => Navigator.pop(context, false),
                    backgroundColor: AppColor.lightGray,
                    textStyleColor: AppColor.textColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppButtons(
                    text: AppMessage.confirm,
                    onPressed: () => Navigator.pop(context, true),
                    backgroundColor: AppColor.mainColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    // Update image
    setState(() {
      _coverImagePath = path;
      _isUpdatingCover = true;
    });

    // Convert image to base64
    try {
      final file = File(path);
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      // Update cover image via API
      final success = await ref.read(profileProvider.notifier).updateCoverImage(
            coverBase64: base64String,
          );

      setState(() {
        _isUpdatingCover = false;
      });

      if (success) {
        AppSnackBar.show(
          message: 'تم تحديث صورة الخلفية بنجاح',
          type: ToastType.success,
        );
        // Clear local path after successful update - data will come from API
        setState(() {
          _coverImagePath = null;
        });
        // Refresh profile data
        ref.read(profileProvider.notifier).refreshProfile();
        widget.onRefresh?.call();
      } else {
        AppSnackBar.show(
          message: 'فشل تحديث الصورة',
          type: ToastType.error,
        );
        // Revert to original
        setState(() {
          _coverImagePath = null;
        });
      }
    } catch (e) {
      setState(() {
        _isUpdatingCover = false;
        _coverImagePath = null;
      });
      AppSnackBar.show(
        message: 'حدث خطأ أثناء تحديث الصورة',
        type: ToastType.error,
      );
    }
  }

  Future<void> _updateLogo() async {
    final granted = await AppPermissions.photoPermission(context: context);
    if (!granted) return;

    // Pick image first
    final path = await AppImagePicker.pickFromGallery(imageQuality: 85);
    if (path == null) return;

    // Check file size (1 MB = 1024 * 1024 bytes)
    try {
      final file = File(path);
      final fileSize = await file.length();
      const maxSize = 1024 * 1024; // 1 MB in bytes

      if (fileSize > maxSize) {
        AppSnackBar.show(
          message: AppMessage.imageSizeExceedsLimit,
          type: ToastType.error,
        );
        return;
      }
    } catch (e) {
      AppSnackBar.show(
        message: AppMessage.errorCheckingImageSize,
        type: ToastType.error,
      );
      return;
    }

    // Show confirmation bottom sheet with image preview
    final confirmed = await UnifiedBottomSheet.showCustom<bool>(
      context: context,
      title: 'تغيير صورة المطعم',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: 'هل تريد استخدام هذه الصورة كصورة المطعم؟',
              fontSize: AppSize.normalText,
              color: AppColor.subGrayText,
              align: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(
                  File(path),
                  width: 200.w,
                  height: 200.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: AppButtons(
                    text: AppMessage.cancel,
                    onPressed: () => Navigator.pop(context, false),
                    backgroundColor: AppColor.lightGray,
                    textStyleColor: AppColor.textColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppButtons(
                    text: AppMessage.confirm,
                    onPressed: () => Navigator.pop(context, true),
                    backgroundColor: AppColor.mainColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    // Update image
    setState(() {
      _logoImagePath = path;
      _isUpdatingLogo = true;
    });

    // Convert image to base64
    try {
      final file = File(path);
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      // Update logo image via API
      final success = await ref.read(profileProvider.notifier).updateLogoImage(
            imageBase64: base64String,
          );

      setState(() {
        _isUpdatingLogo = false;
      });

      if (success) {
        AppSnackBar.show(
          message: 'تم تحديث صورة المطعم بنجاح',
          type: ToastType.success,
        );
        // Clear local path after successful update - data will come from API
        setState(() {
          _logoImagePath = null;
        });
        // Refresh profile data
        ref.read(profileProvider.notifier).refreshProfile();
        widget.onRefresh?.call();
      } else {
        AppSnackBar.show(
          message: 'فشل تحديث الصورة',
          type: ToastType.error,
        );
        // Revert to original
        setState(() {
          _logoImagePath = null;
        });
      }
    } catch (e) {
      setState(() {
        _isUpdatingLogo = false;
        _logoImagePath = null;
      });
      AppSnackBar.show(
        message: 'حدث خطأ أثناء تحديث الصورة',
        type: ToastType.error,
      );
    }
  }

  bool _isLocalImage(String path) {
    // Check if it's a real file path (not base64)
    return (path.startsWith('/') || path.startsWith('file://')) &&
        !_isBase64Image(path);
  }

  bool _isBase64Image(String data) {
    // Check if it's base64 encoded image
    // Base64 images usually start with /9j/ (JPEG) or iVBORw0KGgo (PNG) or R0lGODlh (GIF)
    // Or they might start with data:image
    if (data.startsWith('data:image')) {
      return true;
    }

    // Check for base64 patterns
    if (data.startsWith('/9j/') ||
        data.startsWith('iVBORw0KGgo') ||
        data.startsWith('R0lGODlh') ||
        data.startsWith('UklGR')) {
      // Check if it's long enough to be base64 (at least 100 chars)
      if (data.length > 100) {
        return true;
      }
    }

    return false;
  }

  bool _isValidImage(String? path) {
    return path != null &&
        path.isNotEmpty &&
        path != 'string' &&
        path.length >= 3;
  }

  Widget _getImageWidget(String imageData, {double? height, double? width}) {
    try {
      // Check if it's base64
      if (_isBase64Image(imageData)) {
        String base64String = imageData;

        // Remove data URL prefix if present
        if (base64String.contains(',')) {
          base64String = base64String.split(',').last;
        }

        // Decode base64
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          height: height,
          width: width,
          errorBuilder: (context, error, stackTrace) =>
              height != null ? _buildDefaultCover() : _buildDefaultLogo(),
        );
      }

      // Check if it's a local file
      if (_isLocalImage(imageData)) {
        return Image.file(
          File(imageData),
          fit: BoxFit.cover,
          height: height,
          width: width,
          errorBuilder: (context, error, stackTrace) =>
              height != null ? _buildDefaultCover() : _buildDefaultLogo(),
        );
      }

      // Otherwise, treat as network image
      return Image.network(
        imageData,
        fit: BoxFit.cover,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) =>
            height != null ? _buildDefaultCover() : _buildDefaultLogo(),
      );
    } catch (e) {
      // If any error occurs, return default
      return height != null ? _buildDefaultCover() : _buildDefaultLogo();
    }
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
