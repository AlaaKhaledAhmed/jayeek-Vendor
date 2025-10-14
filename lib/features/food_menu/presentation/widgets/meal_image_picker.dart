import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';

class MealImagePicker extends StatelessWidget {
  final String? path;
  final VoidCallback onTap;

  const MealImagePicker({super.key, required this.path, required this.onTap});

  bool _isNetworkUrl(String? path) {
    if (path == null) return false;
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.lightGray, width: .6),
        ),
        clipBehavior: Clip.antiAlias,
        child: path == null
            ? const Center(
                child: AppText(
                  text: AppMessage.mealPhoto,
                  color: AppColor.subtextColor,
                ),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  // Display network image or local file
                  _isNetworkUrl(path)
                      ? Image.network(
                          path!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_not_supported),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(color: Colors.grey.shade200);
                          },
                        )
                      : Image.file(File(path!), fit: BoxFit.cover),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: AppDecoration.decoration(
                        shadow: false,
                        color: Colors.black.resolveOpacity(0.35),
                        radiusOnlyTop: true,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      child: const AppText(
                        text: 'اضغط لتغيير الصورة',
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
