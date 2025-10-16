import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/image_placeholder_widget.dart';

/// قسم الصورة في عنصر الطلب
class ItemImageSection extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const ItemImageSection({
    super.key,
    this.imageUrl,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Image.network(
          imageUrl!,
          width: size.w,
          height: size.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return ImagePlaceholderWidget(
              width: size,
              height: size,
              radius: 10,
            );
          },
        ),
      );
    }

    return ImagePlaceholderWidget(
      width: size,
      height: size,
      radius: 10,
    );
  }
}
