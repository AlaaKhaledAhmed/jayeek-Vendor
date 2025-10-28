import 'package:equatable/equatable.dart';

/// Custom Addon Model for managing add-ons
class CustomAddonModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final String unitType;
  final String? imageUrl;
  final bool deleteFlag;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomAddonModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unitType,
    this.imageUrl,
    required this.deleteFlag,
    required this.createdAt,
    required this.updatedAt,
  });

  CustomAddonModel copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? unitType,
    String? imageUrl,
    bool? deleteFlag,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomAddonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      unitType: unitType ?? this.unitType,
      imageUrl: imageUrl ?? this.imageUrl,
      deleteFlag: deleteFlag ?? this.deleteFlag,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unitType': unitType,
      'imageUrl': imageUrl,
      'deleteFlag': deleteFlag,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CustomAddonModel.fromJson(Map<String, dynamic> json) {
    return CustomAddonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      unitType: json['unitType'] as String? ?? 'piece',
      imageUrl: json['imageUrl'] as String?,
      deleteFlag: json['deleteFlag'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        unitType,
        imageUrl,
        deleteFlag,
        createdAt,
        updatedAt,
      ];
}

/// DTO for creating a new addon
class CreateAddonDto extends Equatable {
  final String name;
  final String description;
  final double price;
  final String unitType;
  final String? imageUrl;

  const CreateAddonDto({
    required this.name,
    required this.description,
    required this.price,
    required this.unitType,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'unitType': unitType,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [name, description, price, unitType, imageUrl];
}

/// DTO for updating an existing addon
class UpdateAddonDto extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final String unitType;
  final String? imageUrl;

  const UpdateAddonDto({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unitType,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unitType': unitType,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id, name, description, price, unitType, imageUrl];
}
