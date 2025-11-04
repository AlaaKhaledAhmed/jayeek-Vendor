import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/menu_item_model.dart';
import 'menu_item_card.dart';

class VerticalList extends ConsumerWidget {
  const VerticalList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (_, i) => SizedBox(height: 20,),
      separatorBuilder: (_, __) => SizedBox(height: 10.h,width: 20,), itemCount: 4,

    );
  }
}
