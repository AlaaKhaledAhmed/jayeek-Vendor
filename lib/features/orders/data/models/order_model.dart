import 'package:equatable/equatable.dart';

/// Order Status Enum
enum OrderStatus {
  pending('pending', 'جديد'),
  confirmed('confirmed', 'مؤكد'),
  preparing('preparing', 'قيد التحضير'),
  ready('ready', 'جاهز'),
  onTheWay('on_the_way', 'في الطريق'),
  delivered('delivered', 'تم التوصيل'),
  cancelled('cancelled', 'ملغي');

  final String value;
  final String arabicLabel;
  const OrderStatus(this.value, this.arabicLabel);

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

/// Order Item Model
class OrderItemModel extends Equatable {
  final String id;
  final String name;
  final String? image;
  final double price;
  final int quantity;
  final String? notes;
  final List<OrderAddonModel>? addons;

  const OrderItemModel({
    required this.id,
    required this.name,
    this.image,
    required this.price,
    required this.quantity,
    this.notes,
    this.addons,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      notes: json['notes'],
      addons: json['addons'] != null
          ? (json['addons'] as List)
              .map((addon) => OrderAddonModel.fromJson(addon))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'notes': notes,
      'addons': addons?.map((addon) => addon.toJson()).toList(),
    };
  }

  double get totalPrice {
    double addonTotal = 0;
    if (addons != null) {
      for (var addon in addons!) {
        addonTotal += addon.price;
      }
    }
    return (price + addonTotal) * quantity;
  }

  @override
  List<Object?> get props => [id, name, image, price, quantity, notes, addons];
}

/// Order Addon Model
class OrderAddonModel extends Equatable {
  final String name;
  final double price;

  const OrderAddonModel({
    required this.name,
    required this.price,
  });

  factory OrderAddonModel.fromJson(Map<String, dynamic> json) {
    return OrderAddonModel(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [name, price];
}

/// Order Model
class OrderModel extends Equatable {
  final String id;
  final String orderNumber;
  final OrderStatus status;
  final String customerName;
  final String customerPhone;
  final String? customerAddress;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? notes;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;
  final String? branchName;
  final String? paymentMethod;
  final bool isPaid;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    this.customerAddress,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.notes,
    required this.createdAt,
    this.estimatedDeliveryTime,
    this.branchName,
    this.paymentMethod,
    this.isPaid = false,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number'] ?? '',
      status: OrderStatus.fromString(json['status'] ?? 'pending'),
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      customerAddress: json['customer_address'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => OrderItemModel.fromJson(item))
              .toList()
          : [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      deliveryFee: (json['delivery_fee'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      notes: json['notes'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      estimatedDeliveryTime: json['estimated_delivery_time'] != null
          ? DateTime.parse(json['estimated_delivery_time'])
          : null,
      branchName: json['branch_name'],
      paymentMethod: json['payment_method'],
      isPaid: json['is_paid'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status.value,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_address': customerAddress,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'total': total,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'estimated_delivery_time': estimatedDeliveryTime?.toIso8601String(),
      'branch_name': branchName,
      'payment_method': paymentMethod,
      'is_paid': isPaid,
    };
  }

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    OrderStatus? status,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    List<OrderItemModel>? items,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? notes,
    DateTime? createdAt,
    DateTime? estimatedDeliveryTime,
    String? branchName,
    String? paymentMethod,
    bool? isPaid,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      branchName: branchName ?? this.branchName,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        status,
        customerName,
        customerPhone,
        customerAddress,
        items,
        subtotal,
        deliveryFee,
        total,
        notes,
        createdAt,
        estimatedDeliveryTime,
        branchName,
        paymentMethod,
        isPaid,
      ];
}
