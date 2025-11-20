import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/features/auth/presentation/screens/login_page.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/routing/app_routes_methods.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/vendor_model.dart';
import '../../providers/profile_provider.dart';
import '../widgets/modern_profile_header.dart';
import '../widgets/profile_action_tile.dart';
import '../widgets/profile_section_title.dart';
import 'edit_profile_screen.dart';
import 'notifications_settings_screen.dart';
import 'wallet_screen.dart';
import 'working_hours_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  void _refreshData() {
    ref.read(profileProvider.notifier).refreshProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final vendor = profileState.vendor ?? const VendorModel();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(profileProvider.notifier).refreshProfile();
        },
        child: CustomScrollView(
          slivers: [
            // Header عصري مع معلومات المطعم الأساسية
            SliverToBoxAdapter(
              child: ModernProfileHeader(
                vendor: vendor,
                isLoading: profileState.isLoading,
                onRefresh: _refreshData,
              ),
            ),

          // المحتوى
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  // 1️⃣ قسم الحساب
                  const ProfileSectionTitle(
                    title: 'الحساب',
                    icon: Icons.account_circle_rounded,
                  ),
                  _buildAccountSection(context),

                  SizedBox(height: 32.h),

                  // 2️⃣ قسم الإعدادات
                  const ProfileSectionTitle(
                    title: 'الإعدادات',
                    icon: Icons.settings_rounded,
                  ),
                  _buildSettings(context),

                  SizedBox(height: 32.h),

                  // 3️⃣ قسم المالية
                  const ProfileSectionTitle(
                    title: 'المالية',
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  _buildFinanceSection(context),

                  SizedBox(height: 32.h),

                  // 4️⃣ قسم المساعدة
                  const ProfileSectionTitle(
                    title: 'المساعدة والدعم',
                    icon: Icons.help_rounded,
                  ),
                  _buildHelpSection(context),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  // 1️⃣ قسم الحساب
  Widget _buildAccountSection(BuildContext context) {
    final vendor = ref.watch(profileProvider).vendor ?? const VendorModel();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
      child: Column(
        children: [
          ProfileActionTile(
            icon: Icons.edit_rounded,
            title: 'تعديل الملف الشخصي',
            subtitle: 'تعديل صور المطعم',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(vendor: vendor),
                ),
              );
              if (result == true && mounted) {
                _refreshData();
              }
            },
            iconColor: AppColor.mainColor,
          ),
          SizedBox(height: 12.h),
          ProfileActionTile(
            icon: Icons.lock_rounded,
            title: 'تغيير كلمة المرور',
            subtitle: 'تحديث كلمة المرور الخاصة بك',
            onTap: () {
              AppSnackBar.show(
                message: 'قريباً',
                type: ToastType.info,
              );
            },
            iconColor: AppColor.amber,
          ),
          SizedBox(height: 12.h),
          ProfileActionTile(
            icon: Icons.logout_rounded,
            title: 'تسجيل الخروج',
            subtitle: 'الخروج من حسابك',
            onTap: () {
              _showLogoutDialog(context);
            },
            iconColor: AppColor.red,
          ),
        ],
      ),
    );
  }

  // 2️⃣ قسم الإعدادات
  Widget _buildSettings(BuildContext context) {
    final vendor = ref.watch(profileProvider).vendor ?? const VendorModel();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
      child: Column(
        children: [
          ProfileActionTile(
            icon: Icons.schedule_rounded,
            title: 'ساعات العمل',
            subtitle: vendor.workingHours != null
                ? '${vendor.workingHours!.openTime} - ${vendor.workingHours!.closeTime}'
                : 'غير محدد',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkingHoursScreen(vendor: vendor),
                ),
              );
              if (result == true && mounted) {
                _refreshData();
              }
            },
            iconColor: AppColor.mainColor,
          ),
          SizedBox(height: 12.h),
          ProfileActionTile(
            icon: Icons.toggle_on_rounded,
            title: 'حالة المطعم',
            subtitle: vendor.isActive
                ? 'نشط - يمكن قبول طلبات جديدة'
                : 'غير نشط - لا يمكن قبول طلبات جديدة',
            onTap: () {
              _toggleRestaurantStatus(!vendor.isActive);
            },
            iconColor: vendor.isActive ? AppColor.green : AppColor.red,
            trailing: Switch(
              value: vendor.isActive,
              onChanged: (value) {
                _toggleRestaurantStatus(value);
              },
              activeColor: AppColor.green,
              inactiveThumbColor: AppColor.red,
            ),
            showArrow: false,
          ),
          SizedBox(height: 12.h),
          ProfileActionTile(
            icon: Icons.notifications_rounded,
            title: 'الإشعارات',
            subtitle: 'إدارة إشعارات الطلبات',
            onTap: () {
              AppRoutes.pushTo(context, const NotificationsSettingsScreen());
            },
            iconColor: AppColor.blue,
          ),
          SizedBox(height: 12.h),
          ProfileActionTile(
            icon: Icons.language_rounded,
            title: 'اللغة',
            subtitle: 'العربية',
            onTap: () {
              AppSnackBar.show(
                message: 'قريباً',
                type: ToastType.info,
              );
            },
            iconColor: AppColor.textColor,
          ),
        ],
      ),
    );
  }

  // 3️⃣ قسم المالية
  Widget _buildFinanceSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
      child: Column(
        children: [
          ProfileActionTile(
            icon: Icons.account_balance_wallet_rounded,
            title: AppMessage.wallet,
            subtitle: 'عرض الرصيد وسجل المعاملات',
            onTap: () {
              AppRoutes.pushTo(context, const WalletScreen());
            },
            iconColor: AppColor.green,
          ),
          SizedBox(height: 12.h),
          ProfileActionTile(
            icon: Icons.receipt_long_rounded,
            title: 'التقارير المالية',
            subtitle: 'عرض تقارير المبيعات والأرباح',
            onTap: () {
              AppSnackBar.show(
                message: 'قريباً',
                type: ToastType.info,
              );
            },
            iconColor: AppColor.blue,
          ),
          SizedBox(height: 12.h),
          ProfileActionTile(
            icon: Icons.monetization_on_rounded,
            title: 'طلبات السحب',
            subtitle: 'إدارة طلبات سحب الأرباح',
            onTap: () {
              AppSnackBar.show(
                message: 'قريباً',
                type: ToastType.info,
              );
            },
            iconColor: AppColor.amber,
          ),
        ],
      ),
    );
  }

  // 4️⃣ قسم المساعدة
  Widget _buildHelpSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
      child: Column(
        children: [
          ProfileActionTile(
            icon: Icons.help_outline_rounded,
            title: 'مركز المساعدة',
            subtitle: 'الأسئلة الشائعة والإرشادات',
            onTap: () {
              AppSnackBar.show(
                message: 'قريباً',
                type: ToastType.info,
              );
            },
            iconColor: AppColor.blue,
          ),
          SizedBox(height: 12.h),
          ProfileActionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'تواصل معنا',
            subtitle: 'الدردشة المباشرة مع الدعم الفني',
            onTap: () {
              AppSnackBar.show(
                message: 'قريباً',
                type: ToastType.info,
              );
            },
            iconColor: AppColor.green,
          ),
          SizedBox(height: 12.h),
          ProfileActionTile(
            icon: Icons.bug_report_outlined,
            title: 'الإبلاغ عن مشكلة',
            subtitle: 'أخبرنا إذا واجهت أي مشكلة',
            onTap: () {
              AppSnackBar.show(
                message: 'قريباً',
                type: ToastType.info,
              );
            },
            iconColor: AppColor.red,
          ),
          SizedBox(height: 12.h),
          ProfileActionTile(
            icon: Icons.info_outline_rounded,
            title: 'عن التطبيق',
            subtitle: 'الإصدار 1.0.0',
            onTap: () {
              _showAboutDialog(context);
            },
            iconColor: AppColor.textColor,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: AppColor.red,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            const Text('تسجيل الخروج'),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await SharedPreferencesService.clearCache();
              AppRoutes.pushAndRemoveAllPageTo(context, const LoginScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: AppColor.mainColor,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            const Text('عن التطبيق'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تطبيق جايك للمطاعم'),
            SizedBox(height: 8.h),
            const Text('الإصدار: 1.0.0'),
            SizedBox(height: 8.h),
            const Text('© 2024 جميع الحقوق محفوظة'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: const Text(
              'حسناً',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleRestaurantStatus(bool isActive) {
    // عرض تأكيد قبل التغيير
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: AppText(
          text: isActive ? 'تفعيل المطعم' : 'إيقاف المطعم',
          fontSize: AppSize.heading2,
          fontWeight: FontWeight.bold,
        ),
        content: AppText(
          text: isActive
              ? 'هل أنت متأكد من تفعيل المطعم؟ سيتمكن العملاء من إرسال طلبات جديدة.'
              : 'هل أنت متأكد من إيقاف المطعم؟ لن يتمكن العملاء من إرسال طلبات جديدة.',
          fontSize: AppSize.normalText,
          color: AppColor.textColor.withOpacity(0.8),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const AppText(
              text: 'إلغاء',
              color: AppColor.textColor,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateRestaurantStatus(isActive);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? AppColor.green : AppColor.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: AppText(
              text: isActive ? 'تفعيل' : 'إيقاف',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _updateRestaurantStatus(bool isActive) {
    // TODO: Call API to update restaurant status
    // For now, just show a message
    AppSnackBar.show(
      message: isActive
          ? 'تم تفعيل المطعم بنجاح. يمكنك الآن قبول الطلبات الجديدة.'
          : 'تم إيقاف المطعم بنجاح. لن تصلك طلبات جديدة.',
      type: isActive ? ToastType.success : ToastType.warning,
    );

    // تحديث البيانات
    _refreshData();
  }
}
