import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/photo_permission_service.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_decoration.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/info_chip.dart';
import '../../data/mock/mock_vendor_data.dart';
import '../../data/models/vendor_model.dart';

class EditProfileScreen extends StatefulWidget {
  final VendorModel vendor;

  const EditProfileScreen({
    super.key,
    required this.vendor,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? _logoPath;
  String? _coverImagePath;

  @override
  void initState() {
    super.initState();
    _logoPath = widget.vendor.logo;
    _coverImagePath = widget.vendor.coverImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBarWidget(
        text: 'الملف الشخصي',
        hideBackButton: false,
        actions: [
          if (_logoPath != widget.vendor.logo ||
              _coverImagePath != widget.vendor.coverImage)
            TextButton(
              onPressed: _saveChanges,
              child: const AppText(
                text: 'حفظ',
                color: AppColor.mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSize.horizontalPadding),
        children: [
          // صورة الغلاف والشعار
          _buildImagesSection(),

          SizedBox(height: 32.h),

          // معلومات المطعم (للعرض فقط)
          _buildInfoSection(
            title: 'معلومات المطعم',
            icon: Icons.restaurant_rounded,
            color: AppColor.mainColor,
            items: [
              {'label': 'اسم المطعم', 'value': widget.vendor.restaurantName},
              {
                'label': 'رقم الترخيص',
                'value': widget.vendor.licenseNumber ?? 'غير محدد'
              },
              {
                'label': 'العنوان',
                'value': widget.vendor.address ?? 'غير محدد'
              },
              {'label': 'المدينة', 'value': widget.vendor.city ?? 'غير محدد'},
            ],
          ),

          SizedBox(height: 24.h),

          // معلومات المشرف (للعرض فقط)
          _buildInfoSection(
            title: 'معلومات المشرف',
            icon: Icons.person_rounded,
            color: AppColor.blue,
            items: [
              {'label': 'اسم المشرف', 'value': widget.vendor.supervisorName},
              {'label': 'رقم الهاتف', 'value': widget.vendor.phone},
              {'label': 'البريد الإلكتروني', 'value': widget.vendor.email},
            ],
          ),

          SizedBox(height: 24.h),

          // ملاحظة الدعم
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: AppDecoration.decoration(
              radius: 16,
              shadow: true,
              shadowOpacity: 0.08,
              blurRadius: 10,
              showBorder: true,
              borderColor: AppColor.amber.withOpacity(0.2),
              borderWidth: 1,
              isGradient: true,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.amber.withOpacity(0.08),
                  AppColor.amber.withOpacity(0.03),
                ],
              ),
            ),
            child: Row(
              children: [
                // أيقونة
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: AppDecoration.decoration(
                    radius: 12,
                    color: AppColor.amber.withOpacity(0.15),
                    shadow: false,
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    color: AppColor.amber,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: 'تواصل مع الدعم الفني',
                        fontSize: AppSize.normalText,
                        fontWeight: AppThem().bold,
                        color: AppColor.amber,
                      ),
                      SizedBox(height: 3.h),
                      AppText(
                        text: 'لتعديل معلومات المطعم أو المشرف',
                        fontSize: AppSize.captionText - 1,
                        color: AppColor.textColor.withOpacity(0.65),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildImagesSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // صورة الغلاف
          _buildCoverImage(),

          // الشعار (متداخل مع الغلاف)
          Transform.translate(
            offset: Offset(0, -50.h),
            child: Column(
              children: [
                _buildLogoSection(),
                SizedBox(height: 8.h),
                AppText(
                  text: 'صور المطعم',
                  fontSize: AppSize.captionText,
                  color: AppColor.textColor.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage() {
    return GestureDetector(
      onTap: _pickCoverImage,
      child: Container(
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.mainColor.withOpacity(0.8),
              AppColor.mainColor,
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_coverImagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                child: _isLocalImage(_coverImagePath!)
                    ? Image.file(
                        File(_coverImagePath!),
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        _coverImagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultCover(),
                      ),
              )
            else
              _buildDefaultCover(),

            // طبقة شفافة
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),

            // زر تحديث الغلاف
            Positioned(
              top: 16.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: AppColor.mainColor,
                  size: 20.sp,
                ),
              ),
            ),

            // نص إرشادي
            if (_coverImagePath == null)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_rounded,
                      color: Colors.white,
                      size: 40.sp,
                    ),
                    SizedBox(height: 8.h),
                    AppText(
                      text: 'صورة خلفية المطعم',
                      color: Colors.white,
                      fontSize: AppSize.normalText,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.mainColor.withOpacity(0.8),
            AppColor.mainColor,
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Stack(
      children: [
        Container(
          width: 110.w,
          height: 110.w,
          decoration: BoxDecoration(
            color: AppColor.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColor.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: _logoPath != null
                ? (_isLocalImage(_logoPath!)
                    ? Image.file(
                        File(_logoPath!),
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        _logoPath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultLogo(),
                      ))
                : _buildDefaultLogo(),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickLogo,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColor.mainColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.mainColor.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: 18.sp,
                color: AppColor.white,
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
        size: 50.sp,
        color: AppColor.mainColor,
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Map<String, String>> items,
  }) {
    return Container(
      decoration: AppDecoration.decoration(
        radius: 20,
        shadow: true,
        shadowOpacity: 0.08,
        blurRadius: 12,
        showBorder: true,
        borderColor: color.withOpacity(0.12),
        borderWidth: 1,
        isGradient: true,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.04),
            Colors.white,
            Colors.white,
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            decoration: AppDecoration.decoration(
              radiusOnlyTop: true,
              radius: 20,
              shadow: false,
              isGradient: true,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.08),
                  color.withOpacity(0.03),
                ],
              ),
            ),
            child: Row(
              children: [
                // أيقونة
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: AppDecoration.decoration(
                    radius: 12,
                    color: color.withOpacity(0.12),
                    shadow: false,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                // العنوان
                Expanded(
                  child: AppText(
                    text: title,
                    fontSize: AppSize.heading3,
                    fontWeight: AppThem().bold,
                    color: color,
                  ),
                ),
                // Badge
                InfoChip(
                  text: 'للعرض فقط',
                  fontSize: AppSize.captionText - 2,
                  backgroundColor: color.withOpacity(0.1),
                  textColor: color,
                  radius: 18,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  showBorder: true,
                  borderColor: color.withOpacity(0.2),
                ),
              ],
            ),
          ),

          // محتوى القسم
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    _buildModernInfoItem(
                      label: item['label']!,
                      value: item['value']!,
                      color: color,
                    ),
                    if (index < items.length - 1)
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12.h),
                        height: 1,
                        decoration: AppDecoration.decoration(
                          radius: 0,
                          shadow: false,
                          color: color.withOpacity(0.08),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernInfoItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: AppDecoration.decoration(
        radius: 12,
        color: color.withOpacity(0.04),
        shadow: false,
        showBorder: true,
        borderColor: color.withOpacity(0.1),
        borderWidth: 1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // نقطة دائرية
          Container(
            width: 6.w,
            height: 6.w,
            margin: EdgeInsets.only(top: 5.h, left: 8.w),
            decoration: AppDecoration.decoration(
              isCircle: true,
              color: color,
              shadow: true,
              shadowOpacity: 0.3,
              blurRadius: 4,
            ),
          ),
          // المحتوى
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: label,
                  fontSize: AppSize.captionText,
                  color: color.withOpacity(0.65),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 5.h),
                AppText(
                  text: value,
                  fontSize: AppSize.normalText,
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

  Widget _buildInfoItem({required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: label,
            fontSize: AppSize.captionText,
            color: AppColor.textColor.withOpacity(0.6),
          ),
          SizedBox(height: 6.h),
          AppText(
            text: value,
            fontSize: AppSize.normalText,
            fontWeight: FontWeight.w600,
            color: AppColor.textColor,
          ),
        ],
      ),
    );
  }

  Future<void> _pickLogo() async {
    final granted = await AppPermissions.photoPermission(context: context);
    if (!granted) {
      AppSnackBar.show(
        message: 'يجب منح إذن الوصول للصور',
        type: ToastType.error,
      );
      return;
    }

    final path = await AppImagePicker.pickFromGallery(imageQuality: 85);
    if (path != null) {
      setState(() {
        _logoPath = path;
      });
      AppSnackBar.show(
        message: 'تم اختيار الصورة بنجاح',
        type: ToastType.success,
      );
    }
  }

  Future<void> _pickCoverImage() async {
    final granted = await AppPermissions.photoPermission(context: context);
    if (!granted) {
      AppSnackBar.show(
        message: 'يجب منح إذن الوصول للصور',
        type: ToastType.error,
      );
      return;
    }

    final path = await AppImagePicker.pickFromGallery(imageQuality: 85);
    if (path != null) {
      setState(() {
        _coverImagePath = path;
      });
      AppSnackBar.show(
        message: 'تم اختيار صورة الغلاف بنجاح',
        type: ToastType.success,
      );
    }
  }

  bool _isLocalImage(String path) {
    return path.startsWith('/') || path.startsWith('file://');
  }

  void _saveChanges() {
    // تحديث الصور فقط
    MockVendorData.updateVendorInfo(
      logo: _logoPath,
      coverImage: _coverImagePath,
    );

    // عرض رسالة النجاح
    AppSnackBar.show(
      message: 'تم حفظ الصور بنجاح',
      type: ToastType.success,
    );

    // الرجوع للصفحة السابقة مع إرسال true للإشارة للنجاح
    Navigator.pop(context, true);
  }
}
