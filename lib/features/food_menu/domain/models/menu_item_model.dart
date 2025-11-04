import 'package:equatable/equatable.dart';

/// Addon Model للإضافات على الوجبات
class AddonModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final bool isAvailable;

  const AddonModel({
    required this.id,
    required this.name,
    required this.price,
    this.isAvailable = true,
  });

  factory AddonModel.fromJson(Map<String, dynamic> json) {
    return AddonModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isAvailable:
          json['is_available'] as bool? ?? json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'is_available': isAvailable,
    };
  }

  AddonModel copyWith({
    String? id,
    String? name,
    double? price,
    bool? isAvailable,
  }) {
    return AddonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [id, name, price, isAvailable];
}

/// Menu Item Model مع دعم الإضافات (Addons)
class MenuItemModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final bool isAvailable;
  final bool isFeatured;
  final String category;
  final String? branch;
  final bool isCustomizable;
  final List<AddonModel>? availableAddons;

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isAvailable,
    required this.isFeatured,
    required this.category,
    this.branch,
    this.isCustomizable = false,
    this.availableAddons,
  });

  MenuItemModel copyWith({
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    bool? isAvailable,
    bool? isFeatured,
    String? category,
    String? branch,
    bool? isCustomizable,
    List<AddonModel>? availableAddons,
  }) {
    return MenuItemModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      category: category ?? this.category,
      branch: branch ?? this.branch,
      isCustomizable: isCustomizable ?? this.isCustomizable,
      availableAddons: availableAddons ?? this.availableAddons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isAvailable': isAvailable,
      'isFeatured': isFeatured,
      'category': category,
      'branch': branch,
      'isCustomizable': isCustomizable,
      'availableAddons':
          availableAddons?.map((addon) => addon.toJson()).toList(),
    };
  }

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description:
          json['details']?.toString() ?? json['description']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? json['imageUrl']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isAvailable:
          json['isActive'] as bool? ?? json['isAvailable'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      category: json['itemCategoryId']?.toString() ??
          json['category']?.toString() ??
          '',
      branch: json['branch']?.toString(),
      isCustomizable: json['isCustomizable'] as bool? ?? false,
      availableAddons: json['addons'] != null
          ? (json['addons'] as List)
              .map((addon) => AddonModel.fromJson(addon))
              .toList()
          : json['availableAddons'] != null
              ? (json['availableAddons'] as List)
                  .map((addon) => AddonModel.fromJson(addon))
                  .toList()
              : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        price,
        isAvailable,
        isFeatured,
        category,
        branch,
        isCustomizable,
        availableAddons,
      ];
}
