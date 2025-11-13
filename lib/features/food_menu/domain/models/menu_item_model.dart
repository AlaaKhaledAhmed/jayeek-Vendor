import 'package:equatable/equatable.dart';

/// Addon Option Model للخيارات داخل كل Addon
class AddonOption extends Equatable {
  final int id;
  final String name;
  final double price;

  const AddonOption({
    required this.id,
    required this.name,
    required this.price,
  });

  factory AddonOption.fromJson(Map<String, dynamic> json) {
    return AddonOption(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [id, name, price];
}

/// Addon Model للإضافات على الوجبات
class AddonModel extends Equatable {
  final String id;
  final String itemId;
  final String name;
  final double price;
  final String addonType;
  final String? image;
  final List<AddonOption> addonOptions;

  const AddonModel({
    required this.id,
    required this.itemId,
    required this.name,
    required this.price,
    this.addonType = 'none',
    this.image,
    this.addonOptions = const [],
  });

  factory AddonModel.fromJson(Map<String, dynamic> json) {
    // Parse addonOptions
    List<AddonOption> options = [];
    if (json['addonOptions'] != null && json['addonOptions'] is List) {
      options = (json['addonOptions'] as List)
          .map((option) => AddonOption.fromJson(option as Map<String, dynamic>))
          .toList();
    }

    return AddonModel(
      id: json['id']?.toString() ?? '',
      itemId: json['itemId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      addonType: json['addonType']?.toString() ?? 'none',
      image: json['image']?.toString() ?? json['contentBase64']?.toString(),
      addonOptions: options,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'name': name,
      'price': price,
      'addonType': addonType,
      'image': image,
      'addonOptions': addonOptions.map((option) => option.toJson()).toList(),
    };
  }

  AddonModel copyWith({
    String? id,
    String? itemId,
    String? name,
    double? price,
    String? addonType,
    String? image,
    List<AddonOption>? addonOptions,
  }) {
    return AddonModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      price: price ?? this.price,
      addonType: addonType ?? this.addonType,
      image: image ?? this.image,
      addonOptions: addonOptions ?? this.addonOptions,
    );
  }

  @override
  List<Object?> get props =>
      [id, itemId, name, price, addonType, image, addonOptions];
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
  final String category; // itemCategoryId
  final String? categoryName; // itemCategoryName
  final String? categoryNameAr; // itemCategoryNameAr
  final String? branch;
  final bool isCustomizable;
  final List<AddonModel>? availableAddons;
  final double? averageRating;

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isAvailable,
    required this.isFeatured,
    required this.category,
    this.categoryName,
    this.categoryNameAr,
    this.branch,
    this.isCustomizable = false,
    this.availableAddons,
    this.averageRating,
  });

  MenuItemModel copyWith({
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    bool? isAvailable,
    bool? isFeatured,
    String? category,
    String? categoryName,
    String? categoryNameAr,
    String? branch,
    bool? isCustomizable,
    List<AddonModel>? availableAddons,
    double? averageRating,
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
      categoryName: categoryName ?? this.categoryName,
      categoryNameAr: categoryNameAr ?? this.categoryNameAr,
      branch: branch ?? this.branch,
      isCustomizable: isCustomizable ?? this.isCustomizable,
      availableAddons: availableAddons ?? this.availableAddons,
      averageRating: averageRating ?? this.averageRating,
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
      'categoryName': categoryName,
      'categoryNameAr': categoryNameAr,
      'branch': branch,
      'isCustomizable': isCustomizable,
      'availableAddons':
          availableAddons?.map((addon) => addon.toJson()).toList(),
      'averageRating': averageRating,
    };
  }

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    final addons = json['addons'] != null
        ? (json['addons'] as List)
            .map((addon) => AddonModel.fromJson(addon))
            .toList()
        : json['availableAddons'] != null
            ? (json['availableAddons'] as List)
                .map((addon) => AddonModel.fromJson(addon))
                .toList()
            : <AddonModel>[];

    return MenuItemModel(
      id: json['itemId']?.toString() ?? json['id']?.toString() ?? '',
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
      categoryName: json['itemCategoryName']?.toString(),
      categoryNameAr: json['itemCategoryNameAr']?.toString(),
      branch: json['branchId']?.toString() ?? json['branch']?.toString(),
      isCustomizable: addons.isNotEmpty,
      availableAddons: addons.isNotEmpty ? addons : null,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
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
        categoryName,
        categoryNameAr,
        branch,
        isCustomizable,
        availableAddons,
        averageRating,
      ];
}
