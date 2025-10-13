import 'package:equatable/equatable.dart';
import '../../domain/models/menu_item_model.dart';

class MenuState extends Equatable {
  final List<MenuItemModel> items;
  final bool isLoading;
  final String query;
  final String? category;
  final bool gridMode;

  const MenuState({
    required this.items,
    required this.isLoading,
    required this.query,
    required this.category,
    required this.gridMode,
  });

  MenuState copyWith({
    List<MenuItemModel>? items,
    bool? isLoading,
    String? query,
    String? category,
    bool? gridMode,
  }) {
    return MenuState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      category: category == '' ? null : (category ?? this.category),
      gridMode: gridMode ?? this.gridMode,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, query, category, gridMode];
}
