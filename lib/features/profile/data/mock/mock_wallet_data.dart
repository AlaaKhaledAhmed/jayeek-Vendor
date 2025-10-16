import '../models/wallet_model.dart';

/// بيانات تجريبية للمحفظة
class MockWalletData {
  static WalletModel get mockWallet => WalletModel(
        id: 'wallet_1',
        vendorId: '1',
        balance: 45680.50,
        totalEarnings: 156789.50,
        totalWithdrawals: 111109.00,
        pendingAmount: 3250.00,
        currency: 'SAR',
        lastUpdated: DateTime.now(),
      );

  static List<TransactionModel> get mockTransactions => [
        // إيرادات من الطلبات
        TransactionModel(
          id: 'txn_001',
          walletId: 'wallet_1',
          type: TransactionType.earning,
          status: TransactionStatus.completed,
          amount: 131.00,
          commissionAmount: 13.10,
          orderId: '1',
          orderNumber: 'ORD-2024-001',
          description: 'طلب من أحمد محمد',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          completedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        TransactionModel(
          id: 'txn_002',
          walletId: 'wallet_1',
          type: TransactionType.earning,
          status: TransactionStatus.completed,
          amount: 122.00,
          commissionAmount: 12.20,
          orderId: '2',
          orderNumber: 'ORD-2024-002',
          description: 'طلب من سارة خالد',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          completedAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        TransactionModel(
          id: 'txn_003',
          walletId: 'wallet_1',
          type: TransactionType.earning,
          status: TransactionStatus.completed,
          amount: 102.00,
          commissionAmount: 10.20,
          orderId: '3',
          orderNumber: 'ORD-2024-003',
          description: 'طلب من محمد عبدالله',
          createdAt: DateTime.now().subtract(const Duration(hours: 8)),
          completedAt: DateTime.now().subtract(const Duration(hours: 7)),
        ),

        // سحب
        TransactionModel(
          id: 'txn_004',
          walletId: 'wallet_1',
          type: TransactionType.withdrawal,
          status: TransactionStatus.completed,
          amount: 50000.00,
          reference: 'WD-2024-001',
          description: 'تحويل إلى حساب البنك الأهلي',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          completedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),

        // إيرادات أخرى
        TransactionModel(
          id: 'txn_005',
          walletId: 'wallet_1',
          type: TransactionType.earning,
          status: TransactionStatus.completed,
          amount: 113.00,
          commissionAmount: 11.30,
          orderId: '4',
          orderNumber: 'ORD-2024-004',
          description: 'طلب من فاطمة أحمد',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          completedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        TransactionModel(
          id: 'txn_006',
          walletId: 'wallet_1',
          type: TransactionType.earning,
          status: TransactionStatus.completed,
          amount: 91.00,
          commissionAmount: 9.10,
          orderId: '5',
          orderNumber: 'ORD-2024-005',
          description: 'طلب من خالد سعيد',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          completedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),

        // عمولة المنصة
        TransactionModel(
          id: 'txn_007',
          walletId: 'wallet_1',
          type: TransactionType.commission,
          status: TransactionStatus.completed,
          amount: -65.90,
          description: 'عمولة المنصة - أسبوع 15',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          completedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),

        // قيد المعالجة
        TransactionModel(
          id: 'txn_008',
          walletId: 'wallet_1',
          type: TransactionType.earning,
          status: TransactionStatus.pending,
          amount: 107.00,
          commissionAmount: 10.70,
          orderId: '8',
          orderNumber: 'ORD-2024-008',
          description: 'طلب من ياسر حسن',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),

        // سحب قيد المعالجة
        TransactionModel(
          id: 'txn_009',
          walletId: 'wallet_1',
          type: TransactionType.withdrawal,
          status: TransactionStatus.pending,
          amount: 25000.00,
          reference: 'WD-2024-002',
          description: 'طلب سحب إلى حساب الراجحي',
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),

        // استرجاع
        TransactionModel(
          id: 'txn_010',
          walletId: 'wallet_1',
          type: TransactionType.refund,
          status: TransactionStatus.completed,
          amount: -113.00,
          orderId: '6',
          orderNumber: 'ORD-2024-006',
          description: 'استرجاع مبلغ طلب ملغي',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          completedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

  /// الحصول على المعاملات حسب النوع
  static List<TransactionModel> getTransactionsByType(TransactionType type) {
    return mockTransactions.where((txn) => txn.type == type).toList();
  }

  /// الحصول على المعاملات حسب الحالة
  static List<TransactionModel> getTransactionsByStatus(
      TransactionStatus status) {
    return mockTransactions.where((txn) => txn.status == status).toList();
  }

  /// الحصول على المعاملات المكتملة فقط
  static List<TransactionModel> get completedTransactions {
    return mockTransactions
        .where((txn) => txn.status == TransactionStatus.completed)
        .toList();
  }

  /// الحصول على المعاملات القيد المعالجة
  static List<TransactionModel> get pendingTransactions {
    return mockTransactions
        .where((txn) => txn.status == TransactionStatus.pending)
        .toList();
  }
}
