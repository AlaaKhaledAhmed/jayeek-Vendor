import 'package:equatable/equatable.dart';
import 'menu_item_model.dart';

class MenuItemsResponse extends Equatable {
  const MenuItemsResponse({
    this.success,
    this.data,
    this.message,
  });

  final bool? success;
  final List<MenuItemModel>? data;
  final String? message;

  MenuItemsResponse copyWith({
    bool? success,
    List<MenuItemModel>? data,
    String? message,
  }) {
    return MenuItemsResponse(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  factory MenuItemsResponse.fromJson(Map<String, dynamic> json) {
    return MenuItemsResponse(
      success: json["success"],
      data: json["data"] == null
          ? []
          : List<MenuItemModel>.from(
              json["data"]!.map((x) => MenuItemModel.fromJson(x))),
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
