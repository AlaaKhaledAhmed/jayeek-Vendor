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
