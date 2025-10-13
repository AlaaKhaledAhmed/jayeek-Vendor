import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_decoration.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final double? minChildSize, maxChildSize, initialChildSize;

  final VoidCallback? onClose;

  const CustomBottomSheet({
    super.key,
    required this.child,
    this.minChildSize,
    this.maxChildSize,
    this.initialChildSize,
    this.onClose,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? minChildSize,
    double? maxChildSize,
    double? initialChildSize,

    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      isDismissible: false,
      elevation: 3,
      showDragHandle: true,
      builder: (context) => CustomBottomSheet(
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        initialChildSize: initialChildSize,
        onClose: onClose,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: initialChildSize ?? 0.5,
        minChildSize: minChildSize ?? 0.5,
        maxChildSize: maxChildSize ?? 0.99,
        expand: false,

        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              decoration: AppDecoration.decoration(
                radiusOnlyTop: true,
                shadow: false,
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
