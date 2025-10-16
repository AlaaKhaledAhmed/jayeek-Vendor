import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_decoration.dart';
import '../../../../core/widgets/app_text.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  // حالات الإشعارات (Mock Data)
  bool _newOrdersEnabled = true;
  bool _orderStatusEnabled = true;
  bool _paymentEnabled = true;
  bool _promotionsEnabled = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const AppBarWidget(
        text: 'إعدادات الإشعارات',
        hideBackButton: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSize.horizontalPadding),
        children: [
          // وصف
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: AppDecoration.decoration(
              color: AppColor.blue.withOpacity(0.1),
              showBorder: true,
              borderColor: AppColor.blue.withOpacity(0.3),
              shadow: false,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: AppColor.blue,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppText(
                    text: 'تحكم في الإشعارات التي تريد استلامها من التطبيق',
                    fontSize: AppSize.smallText,
                    color: AppColor.textColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // إشعارات الطلبات
          _buildSectionTitle('إشعارات الطلبات'),
          SizedBox(height: 16.h),

          _buildSettingTile(
            icon: Icons.shopping_bag_rounded,
            title: 'طلبات جديدة',
            subtitle: 'إشعار عند استلام طلب جديد',
            value: _newOrdersEnabled,
            onChanged: (value) {
              setState(() => _newOrdersEnabled = value);
            },
          ),
          SizedBox(height: 12.h),

          _buildSettingTile(
            icon: Icons.update_rounded,
            title: 'تحديثات الطلبات',
            subtitle: 'إشعار عند تغيير حالة الطلب',
            value: _orderStatusEnabled,
            onChanged: (value) {
              setState(() => _orderStatusEnabled = value);
            },
          ),

          SizedBox(height: 24.h),

          // إشعارات المدفوعات
          _buildSectionTitle('إشعارات المدفوعات'),
          SizedBox(height: 16.h),

          _buildSettingTile(
            icon: Icons.payment_rounded,
            title: 'المدفوعات',
            subtitle: 'إشعار عند استلام أو سحب أموال',
            value: _paymentEnabled,
            onChanged: (value) {
              setState(() => _paymentEnabled = value);
            },
          ),

          SizedBox(height: 24.h),

          // إشعارات عامة
          _buildSectionTitle('إشعارات عامة'),
          SizedBox(height: 16.h),

          _buildSettingTile(
            icon: Icons.campaign_rounded,
            title: 'العروض والتحديثات',
            subtitle: 'أخبار التطبيق والعروض الخاصة',
            value: _promotionsEnabled,
            onChanged: (value) {
              setState(() => _promotionsEnabled = value);
            },
          ),

          SizedBox(height: 24.h),

          // تنبيهات
          _buildSectionTitle('التنبيهات'),
          SizedBox(height: 16.h),

          _buildSettingTile(
            icon: Icons.volume_up_rounded,
            title: 'الصوت',
            subtitle: 'تشغيل صوت عند استلام إشعار',
            value: _soundEnabled,
            onChanged: (value) {
              setState(() => _soundEnabled = value);
            },
          ),
          SizedBox(height: 12.h),

          _buildSettingTile(
            icon: Icons.vibration_rounded,
            title: 'الاهتزاز',
            subtitle: 'اهتزاز الجهاز عند استلام إشعار',
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() => _vibrationEnabled = value);
            },
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return AppText(
      text: title,
      fontSize: AppSize.normalText,
      fontWeight: AppThem().bold,
      color: AppColor.textColor,
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppDecoration.decoration(
        showBorder: true,
        borderColor: AppColor.borderColor,
        shadow: false,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColor.mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              size: 22.sp,
              color: AppColor.mainColor,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: title,
                  fontSize: AppSize.normalText,
                  fontWeight: AppThem().bold,
                  color: AppColor.textColor,
                ),
                SizedBox(height: 4.h),
                AppText(
                  text: subtitle,
                  fontSize: AppSize.captionText,
                  color: AppColor.subGrayText,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.green,
          ),
        ],
      ),
    );
  }
}
