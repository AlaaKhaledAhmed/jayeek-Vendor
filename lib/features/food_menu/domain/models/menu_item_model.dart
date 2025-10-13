class MenuItemModel {
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
    };
  }

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      category: json['category'] as String,
      branch: json['branch'] as String?,
      isCustomizable: json['isCustomizable'] as bool? ?? false,
    );
  }
}
