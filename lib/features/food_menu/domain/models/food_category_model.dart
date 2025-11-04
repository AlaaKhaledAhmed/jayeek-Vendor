import 'package:equatable/equatable.dart';

class FoodCategoriesResponse extends Equatable {
  const FoodCategoriesResponse({
    this.success,
    this.data,
    this.message,
  });

  final bool? success;
  final List<FoodCategoryModel>? data;
  final String? message;

  FoodCategoriesResponse copyWith({
    bool? success,
    List<FoodCategoryModel>? data,
    String? message,
  }) {
    return FoodCategoriesResponse(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  factory FoodCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return FoodCategoriesResponse(
      success: json["success"],
      data: json["data"] == null
          ? []
          : List<FoodCategoryModel>.from(
              json["data"]!.map((x) => FoodCategoryModel.fromJson(x))),
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

class FoodCategoryModel extends Equatable {
  const FoodCategoryModel({
    this.id,
    this.organizationId,
    this.name,
    this.nameAr,
    this.image,
    this.deleteFlag,
    this.forSale,
  });

  final int? id;
  final int? organizationId;
  final String? name;
  final String? nameAr;
  final String? image; // Can be null or base64 string
  final bool? deleteFlag;
  final bool? forSale;

  FoodCategoryModel copyWith({
    int? id,
    int? organizationId,
    String? name,
    String? nameAr,
    String? image,
    bool? deleteFlag,
    bool? forSale,
  }) {
    return FoodCategoryModel(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      image: image ?? this.image,
      deleteFlag: deleteFlag ?? this.deleteFlag,
      forSale: forSale ?? this.forSale,
    );
  }

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) {
    return FoodCategoryModel(
      id: json["id"],
      organizationId: json["organizationId"],
      name: json["name"],
      nameAr: json["nameAr"],
      image: json["image"],
      deleteFlag: json["deleteFlag"],
      forSale: json["forSale"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "organizationId": organizationId,
        "name": name,
        "nameAr": nameAr,
        "image": image,
        "deleteFlag": deleteFlag,
        "forSale": forSale,
      };

  @override
  List<Object?> get props => [
        id,
        organizationId,
        name,
        nameAr,
        image,
        deleteFlag,
        forSale,
      ];
}
