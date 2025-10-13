import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/menu_item_model.dart';
import 'menu_item_card.dart';

class GridList extends ConsumerWidget {
  final List<MenuItemModel> items;

  const GridList({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => MenuItemCard(item: items[i]),
    );
  }
}
