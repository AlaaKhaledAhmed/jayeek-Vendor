import 'package:equatable/equatable.dart';
import 'menu_item_model.dart';

/// Branch Response Model
class BranchResponse extends Equatable {
  final bool? success;
  final BranchData? data;
  final String? message;

  const BranchResponse({
    this.success,
    this.data,
    this.message,
  });

  BranchResponse copyWith({
    bool? success,
    BranchData? data,
    String? message,
  }) {
    return BranchResponse(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  factory BranchResponse.fromJson(Map<String, dynamic> json) {
    return BranchResponse(
      success: json['success'] as bool?,
      data: json['data'] != null ? BranchData.fromJson(json['data']) : null,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
        'message': message,
      };

  @override
  List<Object?> get props => [success, data, message];
}

/// Branch Data Model
class BranchData extends Equatable {
  final int? id;
  final int? organizationId;
  final String? name;
  final double? averageRating;
  final int? deliveryTimeMinutes;
  final double? deliveryCost;
  final List<BranchReview>? reviews;
  final List<MenuItemModel>? items;

  const BranchData({
    this.id,
    this.organizationId,
    this.name,
    this.averageRating,
    this.deliveryTimeMinutes,
    this.deliveryCost,
    this.reviews,
    this.items,
  });

  BranchData copyWith({
    int? id,
    int? organizationId,
    String? name,
    double? averageRating,
    int? deliveryTimeMinutes,
    double? deliveryCost,
    List<BranchReview>? reviews,
    List<MenuItemModel>? items,
  }) {
    return BranchData(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      averageRating: averageRating ?? this.averageRating,
      deliveryTimeMinutes: deliveryTimeMinutes ?? this.deliveryTimeMinutes,
      deliveryCost: deliveryCost ?? this.deliveryCost,
      reviews: reviews ?? this.reviews,
      items: items ?? this.items,
    );
  }

  factory BranchData.fromJson(Map<String, dynamic> json) {
    return BranchData(
      id: json['id'] as int?,
      organizationId: json['organizationId'] as int?,
      name: json['name']?.toString(),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      deliveryTimeMinutes: json['deliveryTimeMinutes'] as int?,
      deliveryCost: (json['deliveryCost'] as num?)?.toDouble(),
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
              .map((review) => BranchReview.fromJson(review))
              .toList()
          : null,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => MenuItemModel.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'organizationId': organizationId,
        'name': name,
        'averageRating': averageRating,
        'deliveryTimeMinutes': deliveryTimeMinutes,
        'deliveryCost': deliveryCost,
        'reviews': reviews?.map((review) => review.toJson()).toList(),
        'items': items?.map((item) => item.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        id,
        organizationId,
        name,
        averageRating,
        deliveryTimeMinutes,
        deliveryCost,
        reviews,
        items,
      ];
}

/// Branch Review Model
class BranchReview extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final double? rate;

  const BranchReview({
    this.id,
    this.title,
    this.description,
    this.rate,
  });

  factory BranchReview.fromJson(Map<String, dynamic> json) {
    return BranchReview(
      id: json['id'] as int?,
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      rate: (json['rate'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'rate': rate,
      };

  @override
  List<Object?> get props => [id, title, description, rate];
}
