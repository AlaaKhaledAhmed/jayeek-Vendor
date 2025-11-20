import 'package:equatable/equatable.dart';

/// نموذج بيانات المطعم/البائع
class VendorModel extends Equatable {
  final int? id;
  final int? code;
  final String name;
  final String email;
  final String phoneNumber;
  final double? latitude;
  final double? longtitude;
  final String? profileImage;
  final String? coverImage;
  final UserDetails? userDetails;
  
  // Legacy fields for backward compatibility
  final String? restaurantName;
  final String? supervisorName;
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
    this.id,
    this.code,
    this.name = '',
    this.email = '',
    this.phoneNumber = '',
    this.latitude,
    this.longtitude,
    this.profileImage,
    this.coverImage,
    this.userDetails,
    // Legacy fields
    this.restaurantName,
    this.supervisorName,
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
      id: json['id'] as int?,
      code: json['code'] as int?,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longtitude: (json['longtitude'] as num?)?.toDouble(),
      profileImage: json['profileImage']?.toString(),
      coverImage: json['coverImage']?.toString(),
      userDetails: json['userDetails'] != null
          ? UserDetails.fromJson(json['userDetails'])
          : null,
      // Legacy fields - use new fields as fallback
      restaurantName: json['restaurant_name']?.toString() ?? json['name']?.toString() ?? '',
      supervisorName: json['supervisor_name']?.toString(),
      logo: json['logo']?.toString() ?? json['profileImage']?.toString(),
      licenseNumber: json['license_number']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      rating: (json['rating'] as num?)?.toDouble(),
      totalOrders: json['total_orders'] as int?,
      totalSales: (json['total_sales'] as num?)?.toDouble(),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      workingHours: json['working_hours'] != null
          ? WorkingHours.fromJson(json['working_hours'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longtitude': longtitude,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'userDetails': userDetails?.toJson(),
      // Legacy fields
      'restaurant_name': restaurantName ?? name,
      'supervisor_name': supervisorName,
      'phone': phoneNumber,
      'logo': logo ?? profileImage,
      'cover_image': coverImage,
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
    int? id,
    int? code,
    String? name,
    String? email,
    String? phoneNumber,
    double? latitude,
    double? longtitude,
    String? profileImage,
    String? coverImage,
    UserDetails? userDetails,
    String? restaurantName,
    String? supervisorName,
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
      code: code ?? this.code,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      latitude: latitude ?? this.latitude,
      longtitude: longtitude ?? this.longtitude,
      profileImage: profileImage ?? this.profileImage,
      coverImage: coverImage ?? this.coverImage,
      userDetails: userDetails ?? this.userDetails,
      restaurantName: restaurantName ?? this.restaurantName,
      supervisorName: supervisorName ?? this.supervisorName,
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
        code,
        name,
        email,
        phoneNumber,
        latitude,
        longtitude,
        profileImage,
        coverImage,
        userDetails,
        restaurantName,
        supervisorName,
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

/// User Details Model
class UserDetails extends Equatable {
  final int? id;
  final int? code;
  final String? username;
  final int? generalWalletId;
  final String? userType;
  final String? deviceToken;
  final String? countryCode;

  const UserDetails({
    this.id,
    this.code,
    this.username,
    this.generalWalletId,
    this.userType,
    this.deviceToken,
    this.countryCode,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] as int?,
      code: json['code'] as int?,
      username: json['username']?.toString(),
      generalWalletId: json['generalWalletId'] as int?,
      userType: json['userType']?.toString(),
      deviceToken: json['deviceToken']?.toString(),
      countryCode: json['countryCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'username': username,
      'generalWalletId': generalWalletId,
      'userType': userType,
      'deviceToken': deviceToken,
      'countryCode': countryCode,
    };
  }

  @override
  List<Object?> get props => [
        id,
        code,
        username,
        generalWalletId,
        userType,
        deviceToken,
        countryCode,
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
