import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/menu_item_model.dart';
import 'menu_item_card.dart';

class VerticalList extends ConsumerWidget {
  final List<MenuItemModel> items;

  const VerticalList({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemBuilder: (_, i) => MenuItemCard(item: items[i]),
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemCount: items.length,
    );
  }
}
