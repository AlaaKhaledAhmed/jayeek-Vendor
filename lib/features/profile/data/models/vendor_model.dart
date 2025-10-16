import 'package:equatable/equatable.dart';

/// نموذج بيانات المطعم/البائع
class VendorModel extends Equatable {
  final String id;
  final String restaurantName;
  final String supervisorName;
  final String email;
  final String phone;
  final String? logo;
  final String? licenseNumber;
  final String? address;
  final String? city;
  final double? rating;
  final int? totalOrders;
  final double? totalSales;
  final bool isActive;
  final DateTime? createdAt;
  final WorkingHours? workingHours;

  const VendorModel({
    required this.id,
    required this.restaurantName,
    required this.supervisorName,
    required this.email,
    required this.phone,
    this.logo,
    this.licenseNumber,
    this.address,
    this.city,
    this.rating,
    this.totalOrders,
    this.totalSales,
    this.isActive = true,
    this.createdAt,
    this.workingHours,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id']?.toString() ?? '',
      restaurantName: json['restaurant_name'] ?? '',
      supervisorName: json['supervisor_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      logo: json['logo'],
      licenseNumber: json['license_number'],
      address: json['address'],
      city: json['city'],
      rating: json['rating']?.toDouble(),
      totalOrders: json['total_orders'],
      totalSales: json['total_sales']?.toDouble(),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      workingHours: json['working_hours'] != null
          ? WorkingHours.fromJson(json['working_hours'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_name': restaurantName,
      'supervisor_name': supervisorName,
      'email': email,
      'phone': phone,
      'logo': logo,
      'license_number': licenseNumber,
      'address': address,
      'city': city,
      'rating': rating,
      'total_orders': totalOrders,
      'total_sales': totalSales,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'working_hours': workingHours?.toJson(),
    };
  }

  VendorModel copyWith({
    String? id,
    String? restaurantName,
    String? supervisorName,
    String? email,
    String? phone,
    String? logo,
    String? licenseNumber,
    String? address,
    String? city,
    double? rating,
    int? totalOrders,
    double? totalSales,
    bool? isActive,
    DateTime? createdAt,
    WorkingHours? workingHours,
  }) {
    return VendorModel(
      id: id ?? this.id,
      restaurantName: restaurantName ?? this.restaurantName,
      supervisorName: supervisorName ?? this.supervisorName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      logo: logo ?? this.logo,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSales: totalSales ?? this.totalSales,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      workingHours: workingHours ?? this.workingHours,
    );
  }

  @override
  List<Object?> get props => [
        id,
        restaurantName,
        supervisorName,
        email,
        phone,
        logo,
        licenseNumber,
        address,
        city,
        rating,
        totalOrders,
        totalSales,
        isActive,
        createdAt,
        workingHours,
      ];
}

/// ساعات العمل
class WorkingHours extends Equatable {
  final String openTime;
  final String closeTime;
  final List<int> workingDays; // 1 = Monday, 7 = Sunday

  const WorkingHours({
    required this.openTime,
    required this.closeTime,
    required this.workingDays,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      openTime: json['open_time'] ?? '09:00',
      closeTime: json['close_time'] ?? '23:00',
      workingDays: (json['working_days'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [1, 2, 3, 4, 5, 6, 7],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open_time': openTime,
      'close_time': closeTime,
      'working_days': workingDays,
    };
  }

  @override
  List<Object?> get props => [openTime, closeTime, workingDays];
}
