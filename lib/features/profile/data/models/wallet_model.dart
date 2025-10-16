import 'package:equatable/equatable.dart';

/// نموذج المحفظة
class WalletModel extends Equatable {
  final String id;
  final String vendorId;
  final double balance;
  final double totalEarnings;
  final double totalWithdrawals;
  final double pendingAmount;
  final String currency;
  final DateTime? lastUpdated;

  const WalletModel({
    required this.id,
    required this.vendorId,
    required this.balance,
    required this.totalEarnings,
    required this.totalWithdrawals,
    required this.pendingAmount,
    this.currency = 'SAR',
    this.lastUpdated,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id']?.toString() ?? '',
      vendorId: json['vendor_id']?.toString() ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
      totalWithdrawals: (json['total_withdrawals'] ?? 0).toDouble(),
      pendingAmount: (json['pending_amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'SAR',
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor_id': vendorId,
      'balance': balance,
      'total_earnings': totalEarnings,
      'total_withdrawals': totalWithdrawals,
      'pending_amount': pendingAmount,
      'currency': currency,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  WalletModel copyWith({
    String? id,
    String? vendorId,
    double? balance,
    double? totalEarnings,
    double? totalWithdrawals,
    double? pendingAmount,
    String? currency,
    DateTime? lastUpdated,
  }) {
    return WalletModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      balance: balance ?? this.balance,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      totalWithdrawals: totalWithdrawals ?? this.totalWithdrawals,
      pendingAmount: pendingAmount ?? this.pendingAmount,
      currency: currency ?? this.currency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        id,
        vendorId,
        balance,
        totalEarnings,
        totalWithdrawals,
        pendingAmount,
        currency,
        lastUpdated,
      ];
}

/// نوع المعاملة
enum TransactionType {
  earning('earning', 'إيراد', 'من طلب'),
  withdrawal('withdrawal', 'سحب', 'تحويل إلى حسابك'),
  commission('commission', 'عمولة', 'عمولة المنصة'),
  refund('refund', 'استرجاع', 'استرجاع مبلغ');

  final String value;
  final String arabicLabel;
  final String description;
  const TransactionType(this.value, this.arabicLabel, this.description);

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => TransactionType.earning,
    );
  }
}

/// حالة المعاملة
enum TransactionStatus {
  pending('pending', 'قيد المعالجة'),
  completed('completed', 'مكتمل'),
  failed('failed', 'فشل'),
  cancelled('cancelled', 'ملغي');

  final String value;
  final String arabicLabel;
  const TransactionStatus(this.value, this.arabicLabel);

  static TransactionStatus fromString(String value) {
    return TransactionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TransactionStatus.pending,
    );
  }
}

/// نموذج المعاملة/العملية
class TransactionModel extends Equatable {
  final String id;
  final String walletId;
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final double? commissionAmount;
  final String? orderId;
  final String? orderNumber;
  final String? reference;
  final String? description;
  final DateTime createdAt;
  final DateTime? completedAt;

  const TransactionModel({
    required this.id,
    required this.walletId,
    required this.type,
    required this.status,
    required this.amount,
    this.commissionAmount,
    this.orderId,
    this.orderNumber,
    this.reference,
    this.description,
    required this.createdAt,
    this.completedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString() ?? '',
      walletId: json['wallet_id']?.toString() ?? '',
      type: TransactionType.fromString(json['type'] ?? 'earning'),
      status: TransactionStatus.fromString(json['status'] ?? 'pending'),
      amount: (json['amount'] ?? 0).toDouble(),
      commissionAmount: json['commission_amount']?.toDouble(),
      orderId: json['order_id']?.toString(),
      orderNumber: json['order_number'],
      reference: json['reference'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_id': walletId,
      'type': type.value,
      'status': status.value,
      'amount': amount,
      'commission_amount': commissionAmount,
      'order_id': orderId,
      'order_number': orderNumber,
      'reference': reference,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  TransactionModel copyWith({
    String? id,
    String? walletId,
    TransactionType? type,
    TransactionStatus? status,
    double? amount,
    double? commissionAmount,
    String? orderId,
    String? orderNumber,
    String? reference,
    String? description,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      reference: reference ?? this.reference,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        walletId,
        type,
        status,
        amount,
        commissionAmount,
        orderId,
        orderNumber,
        reference,
        description,
        createdAt,
        completedAt,
      ];
}
