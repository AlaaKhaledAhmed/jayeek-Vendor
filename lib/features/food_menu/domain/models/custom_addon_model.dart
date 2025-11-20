import 'package:equatable/equatable.dart';

class CustomAddonsModels extends Equatable {
  const CustomAddonsModels({
    this.success,
    this.data,
    this.message,
  });

  final bool? success;
  final List<AddonsData>? data;
  final String? message;

  CustomAddonsModels copyWith({
    bool? success,
    List<AddonsData>? data,
    String? message,
  }) {
    return CustomAddonsModels(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  factory CustomAddonsModels.fromJson(Map<String, dynamic> json) {
    return CustomAddonsModels(
      success: json["success"],
      data: json["data"] == null
          ? []
          : List<AddonsData>.from(
              json["data"]!.map((x) => AddonsData.fromJson(x))),
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.map((x) => x.toJson()).toList(),
        "message": message,
      };

  @override
  List<Object?> get props => [
        success,
        data,
        message,
      ];
}

class AddonsData extends Equatable {
  const AddonsData(
      {this.id,
      this.name,
      this.price,
      this.description,
      this.deleteFlag,
      this.createdAt,
      this.updatedAt,
      this.imageUrl});

  final int? id;
  final String? name;
  final double? price;
  final String? description;
  final bool? deleteFlag;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;

  AddonsData copyWith(
      {int? id,
      String? name,
      double? price,
      String? description,
      bool? deleteFlag,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? imageUrl}) {
    return AddonsData(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      deleteFlag: deleteFlag ?? this.deleteFlag,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory AddonsData.fromJson(Map<String, dynamic> json) {
    return AddonsData(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      description: json["description"],
      deleteFlag: json["deleteFlag"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      imageUrl: json["imageUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "deleteFlag": deleteFlag,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "imageUrl": imageUrl,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        description,
        deleteFlag,
        createdAt,
        updatedAt,
      ];
}

class SingleAddon extends Equatable {
  const SingleAddon({
    this.success,
    this.data,
    this.message,
  });

  final bool? success;
  final AddonsData? data;
  final dynamic message;

  SingleAddon copyWith({
    bool? success,
    AddonsData? data,
    String? message,
  }) {
    return SingleAddon(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  factory SingleAddon.fromJson(Map<String, dynamic> json) {
    return SingleAddon(
      success: json["success"],
      data: json["data"] == null ? null : AddonsData.fromJson(json["data"]),
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };

  @override
  List<Object?> get props => [
        success,
        data,
        message,
      ];
}

/// Branch Custom Addon Model
class BranchCustomAddonModel extends Equatable {
  const BranchCustomAddonModel({
    this.id,
    this.branchId,
    this.customAddonId,
    this.customAddonName,
    this.branchName,
    this.image,
    this.description,
    this.price,
    this.deleteFlag,
    this.allowQuantitySelection,
  });

  final int? id;
  final int? branchId;
  final int? customAddonId;
  final String? customAddonName;
  final String? branchName;
  final String? image;
  final String? description;
  final double? price;
  final bool? deleteFlag;
  final bool? allowQuantitySelection;

  factory BranchCustomAddonModel.fromJson(Map<String, dynamic> json) {
    return BranchCustomAddonModel(
      id: json['id'] as int?,
      branchId: json['branchId'] as int?,
      customAddonId: json['customAddonId'] as int?,
      customAddonName: json['customAddonName']?.toString(),
      branchName: json['branchName']?.toString(),
      image: json['image']?.toString(),
      description: json['description']?.toString(),
      price: (json['price'] as num?)?.toDouble(),
      deleteFlag: json['deleteFlag'] as bool?,
      allowQuantitySelection: json['allowQuantitySelection'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'branchId': branchId,
        'customAddonId': customAddonId,
        'customAddonName': customAddonName,
        'branchName': branchName,
        'image': image,
        'description': description,
        'price': price,
        'deleteFlag': deleteFlag,
        'allowQuantitySelection': allowQuantitySelection,
      };

  @override
  List<Object?> get props => [
        id,
        branchId,
        customAddonId,
        customAddonName,
        branchName,
        image,
        description,
        price,
        deleteFlag,
        allowQuantitySelection,
      ];
}

/// Branch Custom Addons Response Model
class BranchCustomAddonsResponse extends Equatable {
  const BranchCustomAddonsResponse({
    this.success,
    this.data,
    this.message,
  });

  final bool? success;
  final List<BranchCustomAddonModel>? data;
  final String? message;

  factory BranchCustomAddonsResponse.fromJson(Map<String, dynamic> json) {
    return BranchCustomAddonsResponse(
      success: json['success'] as bool?,
      data: json['data'] == null
          ? []
          : List<BranchCustomAddonModel>.from(
              json['data']!.map((x) => BranchCustomAddonModel.fromJson(x))),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((x) => x.toJson()).toList(),
        'message': message,
      };

  @override
  List<Object?> get props => [success, data, message];
}
