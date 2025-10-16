import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../data/mock/mock_wallet_data.dart';
import '../../data/models/wallet_model.dart';
import '../widgets/wallet/transaction_card.dart';
import '../widgets/wallet/wallet_balance_card.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // استخدام البيانات التجريبية
  final WalletModel wallet = MockWalletData.mockWallet;
  final List<TransactionModel> allTransactions =
      MockWalletData.mockTransactions;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const AppBarWidget(
        text: AppMessage.wallet,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // بطاقة الرصيد
          Padding(
            padding: EdgeInsets.all(AppSize.horizontalPadding),
            child: WalletBalanceCard(wallet: wallet),
          ),

          SizedBox(height: 16.h),

          // زر طلب سحب
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
            child: AppButtons(
              text: AppMessage.requestWithdrawal,
              onPressed: _showWithdrawalDialog,
              width: double.infinity,
              backgroundColor: AppColor.mainColor,
            ),
          ),

          SizedBox(height: 24.h),

          // التبويبات
          _buildTabs(),

          SizedBox(height: 16.h),

          // قائمة المعاملات
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionsList(allTransactions),
                _buildTransactionsList(_getEarnings()),
                _buildTransactionsList(_getWithdrawals()),
                _buildTransactionsList(_getCommissions()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 45.h,
      margin: EdgeInsets.symmetric(horizontal: AppSize.horizontalPadding),
      decoration: BoxDecoration(
        color: AppColor.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColor.mainColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColor.white,
        unselectedLabelColor: AppColor.subGrayText,
        labelStyle: TextStyle(
          fontSize: AppSize.captionText,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppSize.captionText,
        ),
        tabs: const [
          Tab(text: AppMessage.allTransactions),
          Tab(text: AppMessage.earnings),
          Tab(text: AppMessage.withdrawals),
          Tab(text: AppMessage.commissions),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
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
            Text(
              AppMessage.noTransactions,
              style: TextStyle(
                fontSize: AppSize.normalText,
                fontWeight: FontWeight.bold,
                color: AppColor.textColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppMessage.noTransactionsMessage,
              style: TextStyle(
                fontSize: AppSize.smallText,
                color: AppColor.subGrayText,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppSize.horizontalPadding),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionCard(
          transaction: transaction,
          onTap: () => _showTransactionDetails(transaction),
        );
      },
    );
  }

  List<TransactionModel> _getEarnings() {
    return allTransactions
        .where((txn) => txn.type == TransactionType.earning)
        .toList();
  }

  List<TransactionModel> _getWithdrawals() {
    return allTransactions
        .where((txn) => txn.type == TransactionType.withdrawal)
        .toList();
  }

  List<TransactionModel> _getCommissions() {
    return allTransactions
        .where((txn) =>
            txn.type == TransactionType.commission ||
            txn.type == TransactionType.refund)
        .toList();
  }

  void _showWithdrawalDialog() {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.upload_rounded,
              color: AppColor.mainColor,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            const Text(AppMessage.requestWithdrawal),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الرصيد المتاح: ${wallet.balance.toStringAsFixed(2)} ${wallet.currency}',
              style: TextStyle(
                fontSize: AppSize.smallText,
                color: AppColor.subGrayText,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppMessage.withdrawalAmount,
                hintText: 'أدخل المبلغ',
                suffixText: wallet.currency,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              decoration: InputDecoration(
                labelText: AppMessage.bankAccount,
                hintText: 'رقم الحساب البنكي',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppMessage.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال طلب السحب بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: const Text(
              'إرسال الطلب',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(TransactionModel transaction) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColor.borderColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppMessage.transactionDetails,
              style: TextStyle(
                fontSize: AppSize.heading3,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
            _buildDetailRow(
              'المبلغ',
              '${transaction.amount.toStringAsFixed(2)} ${wallet.currency}',
            ),
            _buildDetailRow(
              AppMessage.transactionType,
              transaction.type.arabicLabel,
            ),
            _buildDetailRow(
              AppMessage.transactionStatus,
              transaction.status.arabicLabel,
            ),
            if (transaction.orderNumber != null)
              _buildDetailRow(
                'رقم الطلب',
                transaction.orderNumber!,
              ),
            if (transaction.reference != null)
              _buildDetailRow(
                AppMessage.reference,
                transaction.reference!,
              ),
            if (transaction.commissionAmount != null)
              _buildDetailRow(
                'العمولة',
                '${transaction.commissionAmount!.toStringAsFixed(2)} ${wallet.currency}',
              ),
            _buildDetailRow(
              AppMessage.transactionDate,
              transaction.createdAt.toString().split('.')[0],
            ),
            if (transaction.description != null) ...[
              SizedBox(height: 12.h),
              Text(
                'الوصف:',
                style: TextStyle(
                  fontSize: AppSize.smallText,
                  color: AppColor.subGrayText,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                transaction.description!,
                style: TextStyle(
                  fontSize: AppSize.normalText,
                ),
              ),
            ],
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppSize.smallText,
              color: AppColor.subGrayText,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSize.normalText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
