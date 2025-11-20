import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_fields.dart';
import '../../../../core/widgets/unified_bottom_sheet.dart';
import '../../data/models/wallet_model.dart';
import 'package:intl/intl.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Load wallet data from API
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Load wallet data from API
    final wallet = WalletModel(
      id: '',
      vendorId: '',
      balance: 0.0,
      currency: 'SAR',
      totalEarnings: 0.0,
      totalWithdrawals: 0.0,
      pendingAmount: 0.0,
    );
    final allTransactions = <TransactionModel>[];

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const AppBarWidget(
        text: AppMessage.wallet,
        hideBackButton: false,
      ),
      body: Column(
        children: [
          // بطاقة الرصيد العصري
          _buildModernBalanceCard(wallet),

          SizedBox(height: 24.h),

          // قائمة المعاملات
          Expanded(
            child: allTransactions.isEmpty
                ? _buildEmptyState()
                : _buildTransactionsList(allTransactions, wallet),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBalanceCard(WalletModel wallet) {
    return Container(
      margin: EdgeInsets.all(AppSize.horizontalPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.mainColor,
            AppColor.mainColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.mainColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'المحفظة',
                  fontSize: AppSize.heading3,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6.w),
                      AppText(
                        text: 'مباشر',
                        fontSize: AppSize.captionText,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            // الرصيد المتاح
            AppText(
              text: 'الرصيد المتاح',
              fontSize: AppSize.normalText,
              color: Colors.white.withOpacity(0.9),
            ),
            SizedBox(height: 8.h),
            // المبلغ
            AppText(
              text: '${wallet.balance.toStringAsFixed(2)} ${wallet.currency}',
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            SizedBox(height: 32.h),
            // زر سحب الرصيد
            AppButtons(
              text: 'طلب سحب الرصيد',
              onPressed: () => _showWithdrawalBottomSheet(wallet),
              width: double.infinity,
              backgroundColor: Colors.white,
              textStyleColor: AppColor.mainColor,
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(
      List<TransactionModel> transactions, WalletModel wallet) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildModernTransactionCard(transaction, wallet);
      },
    );
  }

  Widget _buildModernTransactionCard(
      TransactionModel transaction, WalletModel wallet) {
    // تحديد إذا كانت العملية سحب أو إيداع
    final isWithdrawal = transaction.type == TransactionType.withdrawal;
    final isEarning = transaction.type == TransactionType.earning;

    // تحديد اللون والأيقونة
    final iconColor = isWithdrawal ? AppColor.red : AppColor.green;
    final icon = isWithdrawal
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;
    final title = isWithdrawal
        ? 'عملية سحب'
        : isEarning
            ? 'عملية إيداع'
            : transaction.type.arabicLabel;

    // تنسيق التاريخ
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm', 'ar');
    final formattedDate = dateFormat.format(transaction.createdAt);

    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTransactionDetails(transaction, wallet),
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // الأيقونة
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                // التفاصيل
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: title,
                        fontSize: AppSize.normalText,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textColor,
                      ),
                      SizedBox(height: 4.h),
                      AppText(
                        text: formattedDate,
                        fontSize: AppSize.captionText,
                        color: AppColor.subGrayText,
                      ),
                    ],
                  ),
                ),
                // المبلغ
                AppText(
                  text:
                      '${isWithdrawal ? '-' : '+'}${transaction.amount.toStringAsFixed(2)} ${wallet.currency}',
                  fontSize: AppSize.normalText,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 80.sp,
            color: AppColor.subGrayText.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          AppText(
            text: AppMessage.noTransactions,
            fontSize: AppSize.normalText,
            fontWeight: FontWeight.bold,
            color: AppColor.textColor,
          ),
          SizedBox(height: 8.h),
          AppText(
            text: AppMessage.noTransactionsMessage,
            fontSize: AppSize.smallText,
            color: AppColor.subGrayText,
          ),
        ],
      ),
    );
  }

  void _showWithdrawalBottomSheet(WalletModel wallet) {
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    UnifiedBottomSheet.showCustom(
      context: context,
      title: 'طلب سحب الرصيد',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الرصيد المتاح
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      color: AppColor.mainColor,
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'الرصيد المتاح',
                            fontSize: AppSize.captionText,
                            color: AppColor.subGrayText,
                          ),
                          SizedBox(height: 4.h),
                          AppText(
                            text:
                                '${wallet.balance.toStringAsFixed(2)} ${wallet.currency}',
                            fontSize: AppSize.heading3,
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // حقل المبلغ
              AppTextFields(
                controller: amountController,
                hintText: 'أدخل المبلغ',
                labelText: 'مبلغ السحب',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                suffix: AppText(
                  text: wallet.currency,
                  fontSize: AppSize.normalText,
                  color: AppColor.subGrayText,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال المبلغ';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'يرجى إدخال مبلغ صحيح';
                  }
                  if (amount > wallet.balance) {
                    return 'المبلغ أكبر من الرصيد المتاح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              // الأزرار
              Row(
                children: [
                  Expanded(
                    child: AppButtons(
                      text: AppMessage.cancel,
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: AppColor.lightGray,
                      textStyleColor: AppColor.textColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButtons(
                      text: 'إرسال الطلب',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          // TODO: Call API to request withdrawal
                          AppSnackBar.show(
                            message: 'تم إرسال طلب السحب بنجاح',
                            type: ToastType.success,
                          );
                        }
                      },
                      backgroundColor: AppColor.mainColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(TransactionModel transaction, WalletModel wallet) {
    final isWithdrawal = transaction.type == TransactionType.withdrawal;
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm', 'ar');
    final formattedDate = dateFormat.format(transaction.createdAt);

    UnifiedBottomSheet.showCustom(
      context: context,
      title: 'تفاصيل العملية',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // نوع العملية
            _buildDetailRow(
              'نوع العملية',
              isWithdrawal ? 'عملية سحب' : 'عملية إيداع',
            ),
            SizedBox(height: 16.h),
            // المبلغ
            _buildDetailRow(
              'المبلغ',
              '${transaction.amount.toStringAsFixed(2)} ${wallet.currency}',
            ),
            SizedBox(height: 16.h),
            // التاريخ
            _buildDetailRow(
              'التاريخ',
              formattedDate,
            ),
            SizedBox(height: 16.h),
            // الحالة
            _buildDetailRow(
              'الحالة',
              transaction.status.arabicLabel,
            ),
            if (transaction.orderNumber != null) ...[
              SizedBox(height: 16.h),
              _buildDetailRow(
                'رقم الطلب',
                transaction.orderNumber!,
              ),
            ],
            if (transaction.reference != null) ...[
              SizedBox(height: 16.h),
              _buildDetailRow(
                'المرجع',
                transaction.reference!,
              ),
            ],
            SizedBox(height: 24.h),
            // زر الإغلاق
            AppButtons(
              text: AppMessage.ok,
              onPressed: () => Navigator.pop(context),
              backgroundColor: AppColor.mainColor,
              width: double.infinity,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: label,
          fontSize: AppSize.normalText,
          color: AppColor.subGrayText,
        ),
        AppText(
          text: value,
          fontSize: AppSize.normalText,
          fontWeight: FontWeight.bold,
          color: AppColor.textColor,
        ),
      ],
    );
  }
}
