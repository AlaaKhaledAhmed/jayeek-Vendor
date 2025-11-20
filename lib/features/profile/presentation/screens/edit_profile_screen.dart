import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_decoration.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/info_chip.dart';
import '../../data/models/vendor_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final VendorModel vendor;

  const EditProfileScreen({
    super.key,
    required this.vendor,
  });

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const AppBarWidget(
        text: 'الملف الشخصي',
        hideBackButton: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSize.horizontalPadding),
        children: [
          // معلومات المطعم (للعرض فقط)
          _buildInfoSection(
            title: 'معلومات المطعم',
            icon: Icons.restaurant_rounded,
            color: AppColor.mainColor,
            vendor: widget.vendor,
            items: [
              {
                'label': 'اسم المطعم',
                'value': widget.vendor.restaurantName ?? widget.vendor.name
              },
              {
                'label': 'رقم الترخيص',
                'value': widget.vendor.licenseNumber ?? 'غير محدد'
              },
              {
                'label': 'موقع المطعم',
                'value': 'عرض الموقع على الخريطة',
                'isLocation': 'true',
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
            vendor: widget.vendor,
            items: [
              {
                'label': 'اسم المشرف',
                'value': widget.vendor.supervisorName ?? ''
              },
              {'label': 'رقم الهاتف', 'value': widget.vendor.phoneNumber},
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

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required Color color,
    required VendorModel vendor,
    required List<Map<String, dynamic>> items,
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
                      isLocation: item['isLocation'] == 'true',
                      vendor: vendor,
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
    bool isLocation = false,
    required VendorModel vendor,
  }) {
    return GestureDetector(
      onTap: isLocation ? () => _openLocationOnMap(vendor) : null,
      child: Container(
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
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text: value,
                          fontSize: AppSize.normalText,
                          fontWeight: AppThem().bold,
                          color: isLocation
                              ? AppColor.mainColor
                              : AppColor.textColor,
                        ),
                      ),
                      if (isLocation)
                        Icon(
                          Icons.map_rounded,
                          size: 20.sp,
                          color: AppColor.mainColor,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLocationOnMap(VendorModel vendor) async {
    if (vendor.latitude == null || vendor.longtitude == null) {
      AppSnackBar.show(
        message: 'إحداثيات الموقع غير متوفرة',
        type: ToastType.error,
      );
      return;
    }

    try {
      // Google Maps URL format: https://www.google.com/maps?q=latitude,longitude
      final url = Uri.parse(
        'https://www.google.com/maps?q=${vendor.latitude},${vendor.longtitude}',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        AppSnackBar.show(
          message: 'لا يمكن فتح الخريطة',
          type: ToastType.error,
        );
      }
    } catch (e) {
      AppSnackBar.show(
        message: 'حدث خطأ أثناء فتح الخريطة',
        type: ToastType.error,
      );
    }
  }
}
