import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import '../constants/app_color.dart';
import '../constants/app_size.dart';
import '../constants/app_string.dart';
import '../widgets/app_decoration.dart';
import '../widgets/app_text.dart';
import 'app_image_placeholder.dart';

/// Unified image picker widget used throughout the application
/// Supports network images, local files, and base64 strings
class SharedImagePicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPickImage;
  final double? height;
  final double? width;
  final String? placeholderText;
  final BoxFit fit;
  final double borderRadius;

  const SharedImagePicker({
    super.key,
    required this.imagePath,
    required this.onPickImage,
    this.height = 200,
    this.width,
    this.placeholderText,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: AppDecoration.decoration(
          radius: borderRadius,
          color: AppColor.lightGray.resolveOpacity(0.5),
          showBorder: true,
          borderColor: AppColor.borderColor,
          shadow: false),
      child: InkWell(
        onTap: onPickImage,
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: imagePath != null && imagePath!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius.r),
                child: _buildImageWidget(imagePath!),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    // Validate imagePath is not empty or invalid
    if (imagePath.isEmpty || imagePath == 'string' || imagePath.length < 3) {
      return const AppImagePlaceholder();
    }

    // Check if it's a network URL first
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: width ?? double.infinity,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return const AppImagePlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColor.mainColor),
            ),
          );
        },
      );
    }

    // Check if it's a base64 string
    final bool isBase64 = imagePath.startsWith('/9j/') ||
        imagePath.startsWith('data:image') ||
        (imagePath.length > 500 &&
            !imagePath.contains('/tmp/') &&
            !imagePath.contains('/storage/') &&
            !imagePath.contains('/data/'));

    if (isBase64) {
      try {
        String base64String = imagePath;
        if (base64String.contains(',')) {
          base64String = base64String.split(',').last;
        }
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: width ?? double.infinity,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return const AppImagePlaceholder();
          },
        );
      } catch (e) {
        return _tryAsFile(imagePath);
      }
    }

    // Check if it's a file path
    return _tryAsFile(imagePath);
  }

  Widget _tryAsFile(String imagePath) {
    if (imagePath.startsWith('/') && !imagePath.startsWith('http')) {
      try {
        final file = File(imagePath);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: width ?? double.infinity,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return const AppImagePlaceholder();
            },
          );
        }
      } catch (e) {
        // If file access fails, return default
      }
    }

    return const AppImagePlaceholder();
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          size: AppSize.veryLargeIconSize,
          color: AppColor.mediumGray,
        ),
        SizedBox(height: 12.h),
        AppText(
          text: placeholderText ?? AppMessage.selectImage,
          fontSize: AppSize.normalText,
          color: AppColor.mediumGray,
        ),
      ],
    );
  }
}
