import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_size.dart';
import '../../../../../core/extensions/color_extensions.dart';
import '../../../../../core/theme/app_them.dart';
import '../../../../../core/widgets/app_decoration.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../data/models/wallet_model.dart';

/// بطاقة عرض معاملة/عملية واحدة
class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount > 0 &&
        transaction.type != TransactionType.commission;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: AppDecoration.decoration(
          showBorder: true,
          borderColor: AppColor.borderColor,
          shadow: false,
        ),
        child: Row(
          children: [
            // الأيقونة
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: _getTypeColor(transaction.type).resolveOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                _getTypeIcon(transaction.type),
                size: 24.sp,
                color: _getTypeColor(transaction.type),
              ),
            ),

            SizedBox(width: 16.w),

            // المعلومات
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text: transaction.description ??
                              transaction.type.arabicLabel,
                          fontSize: AppSize.normalText,
                          fontWeight: AppThem().bold,
                          color: AppColor.textColor,
                        ),
                      ),
                      _buildStatusBadge(transaction.status),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      if (transaction.orderNumber != null) ...[
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 14.sp,
                          color: AppColor.subGrayText,
                        ),
                        SizedBox(width: 4.w),
                        AppText(
                          text: transaction.orderNumber!,
                          fontSize: AppSize.captionText,
                          color: AppColor.subGrayText,
                        ),
                        SizedBox(width: 12.w),
                      ],
                      Icon(
                        Icons.access_time_rounded,
                        size: 14.sp,
                        color: AppColor.subGrayText,
                      ),
                      SizedBox(width: 4.w),
                      AppText(
                        text: _formatDate(transaction.createdAt),
                        fontSize: AppSize.captionText,
                        color: AppColor.subGrayText,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // المبلغ
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  text:
                      '${isPositive ? '+' : ''}${_formatAmount(transaction.amount)}',
                  fontSize: AppSize.normalText,
                  fontWeight: AppThem().bold,
                  color: isPositive ? AppColor.green : AppColor.red,
                ),
                if (transaction.commissionAmount != null) ...[
                  SizedBox(height: 4.h),
                  AppText(
                    text:
                        'عمولة: ${_formatAmount(transaction.commissionAmount!)}',
                    fontSize: AppSize.captionText,
                    color: AppColor.subGrayText,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    Color color;
    switch (status) {
      case TransactionStatus.completed:
        color = AppColor.green;
        break;
      case TransactionStatus.pending:
        color = AppColor.amber;
        break;
      case TransactionStatus.failed:
        color = AppColor.red;
        break;
      case TransactionStatus.cancelled:
        color = AppColor.subGrayText;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: AppDecoration.decoration(
        color: color.resolveOpacity(0.1),
        radius: 6,
        shadow: false,
      ),
      child: AppText(
        text: status.arabicLabel,
        fontSize: 10.sp,
        color: color,
      ),
    );
  }

  IconData _getTypeIcon(TransactionType type) {
    switch (type) {
      case TransactionType.earning:
        return Icons.arrow_downward_rounded;
      case TransactionType.withdrawal:
        return Icons.arrow_upward_rounded;
      case TransactionType.commission:
        return Icons.percent_rounded;
      case TransactionType.refund:
        return Icons.undo_rounded;
    }
  }

  Color _getTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.earning:
        return AppColor.green;
      case TransactionType.withdrawal:
        return AppColor.blue;
      case TransactionType.commission:
        return AppColor.amber;
      case TransactionType.refund:
        return AppColor.red;
    }
  }

  String _formatAmount(double amount) {
    return amount.abs().toStringAsFixed(2);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return DateFormat('yyyy/MM/dd').format(date);
    }
  }
}
