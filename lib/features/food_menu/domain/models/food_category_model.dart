import 'package:equatable/equatable.dart';
import 'menu_item_model.dart';

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
    this.branchId,
    this.name,
    this.nameAr,
    this.image,
    this.iconCode,
    this.deleteFlag,
    this.forSale,
    this.items,
  });

  final int? id;
  final int? organizationId;
  final int? branchId;
  final String? name;
  final String? nameAr;
  final String? image; // Can be null or base64 string
  final String? iconCode; // Unicode code point like "U+1F354"
  final bool? deleteFlag;
  final bool? forSale;
  final List<MenuItemModel>? items;

  FoodCategoryModel copyWith({
    int? id,
    int? organizationId,
    int? branchId,
    String? name,
    String? nameAr,
    String? image,
    String? iconCode,
    bool? deleteFlag,
    bool? forSale,
    List<MenuItemModel>? items,
  }) {
    return FoodCategoryModel(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      image: image ?? this.image,
      iconCode: iconCode ?? this.iconCode,
      deleteFlag: deleteFlag ?? this.deleteFlag,
      forSale: forSale ?? this.forSale,
      items: items ?? this.items,
    );
  }

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) {
    return FoodCategoryModel(
      id: json["id"],
      organizationId: json["organizationId"],
      branchId: json["branchId"],
      name: json["name"],
      nameAr: json["nameAr"],
      image: json["image"],
      iconCode: json["iconCode"],
      deleteFlag: json["deleteFlag"],
      forSale: json["forSale"],
      items: json["items"] != null
          ? (json["items"] as List)
              .map((item) => MenuItemModel.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "organizationId": organizationId,
        "branchId": branchId,
        "name": name,
        "nameAr": nameAr,
        "image": image,
        "iconCode": iconCode,
        "deleteFlag": deleteFlag,
        "forSale": forSale,
        "items": items?.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        id,
        organizationId,
        branchId,
        name,
        nameAr,
        image,
        iconCode,
        deleteFlag,
        forSale,
        items,
      ];
}
