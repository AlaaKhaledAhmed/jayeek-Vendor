import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/extensions/color_extensions.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/wallet_model.dart';

/// بطاقة الرصيد في المحفظة
class WalletBalanceCard extends StatelessWidget {
  final WalletModel wallet;

  const WalletBalanceCard({
    super.key,
    required this.wallet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.mainColor,
            AppColor.mainColor.resolveOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.mainColor.resolveOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppColor.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  AppText(
                    text: AppMessage.wallet,
                    fontSize: AppSize.normalText,
                    color: AppColor.white.resolveOpacity(0.9),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: AppDecoration.decoration(
                  color: AppColor.white.resolveOpacity(0.2),
                  radius: 20,
                  shadow: false,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14.sp,
                      color: AppColor.white,
                    ),
                    SizedBox(width: 4.w),
                    AppText(
                      text: 'مباشر',
                      fontSize: AppSize.captionText,
                      color: AppColor.white,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // الرصيد الرئيسي
          AppText(
            text: AppMessage.balance,
            fontSize: AppSize.smallText,
            color: AppColor.white.resolveOpacity(0.8),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: _formatCurrency(wallet.balance),
                fontSize: AppSize.heading1,
                fontWeight: AppThem().bold,
                color: AppColor.white,
              ),
              SizedBox(width: 8.w),
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: AppText(
                  text: wallet.currency,
                  fontSize: AppSize.normalText,
                  color: AppColor.white.resolveOpacity(0.8),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // الإحصائيات
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  label: AppMessage.totalEarnings,
                  value: _formatCurrency(wallet.totalEarnings),
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildStatItem(
                  label: AppMessage.totalWithdrawals,
                  value: _formatCurrency(wallet.totalWithdrawals),
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),

          if (wallet.pendingAmount > 0) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: AppDecoration.decoration(
                color: AppColor.amber.resolveOpacity(0.2),
                radius: 12,
                shadow: false,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.pending_rounded,
                    size: 18.sp,
                    color: AppColor.amber,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: AppText(
                      text: AppMessage.pendingAmount,
                      fontSize: AppSize.captionText,
                      color: AppColor.white,
                    ),
                  ),
                  AppText(
                    text:
                        '${_formatCurrency(wallet.pendingAmount)} ${wallet.currency}',
                    fontSize: AppSize.smallText,
                    fontWeight: AppThem().bold,
                    color: AppColor.white,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: AppDecoration.decoration(
        color: AppColor.white.resolveOpacity(0.1),
        radius: 12,
        shadow: false,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: AppColor.white.resolveOpacity(0.8),
          ),
          SizedBox(height: 8.h),
          AppText(
            text: value,
            fontSize: AppSize.normalText,
            fontWeight: AppThem().bold,
            color: AppColor.white,
          ),
          SizedBox(height: 2.h),
          AppText(
            text: label,
            fontSize: AppSize.captionText,
            color: AppColor.white.resolveOpacity(0.7),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}
