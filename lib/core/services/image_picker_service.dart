import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_color.dart';
import '../constants/app_icons.dart';
import '../constants/app_size.dart';
import '../constants/app_string.dart';
import '../widgets/app_text.dart';
import '../widgets/app_buttons.dart';

class AppImagePicker {
  AppImagePicker._();

  static final ImagePicker _picker = ImagePicker();

  /// يفتح الاستديو لاختيار صورة ويعيد المسار المحلي للملف أو null لو ألغى.
  static Future<String?> pickFromGallery({int imageQuality = 85}) async {
    final XFile? x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
    return x?.path;
  }

  /// يفتح dialog لاختيار المصدر (مكتبة الصور أو الملفات) ويعيد المسار المحلي للملف أو null لو ألغى.
  /// على iOS يظهر خيارين: مكتبة الصور والملفات
  static Future<String?> pickImageWithSource({
    required BuildContext context,
    int imageQuality = 85,
  }) async {
    // Show dialog to choose source
    final source = await _showImageSourceDialog(context);
    if (source == null) return null;

    if (source == ImageSourceType.gallery) {
      // Pick from gallery
      final XFile? x = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );
      return x?.path;
    } else if (source == ImageSourceType.files) {
      // Pick from files app (iOS Files app)
      // Use FileType.custom with image extensions to force opening Files app instead of photo library
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic'],
      );
      if (result != null && result.files.single.path != null) {
        return result.files.single.path;
      }
    }

    return null;
  }

  /// Shows dialog to choose image source
  static Future<ImageSourceType?> _showImageSourceDialog(
      BuildContext context) async {
    return showDialog<ImageSourceType>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: AppText(
              text: AppMessage.selectImageSource,
              fontSize: AppSize.heading3,
              fontWeight: FontWeight.bold,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gallery option
                ListTile(
                  leading: Icon(
                    AppIcons.image,
                    color: AppColor.mainColor,
                    size: AppSize.largeIconSize,
                  ),
                  title: AppText(
                    text: AppMessage.photoLibrary,
                    fontSize: AppSize.normalText,
                  ),
                  onTap: () => Navigator.pop(context, ImageSourceType.gallery),
                ),
                // Files option
                ListTile(
                  leading: Icon(
                    AppIcons.folder,
                    color: AppColor.mainColor,
                    size: AppSize.largeIconSize,
                  ),
                  title: AppText(
                    text: AppMessage.files,
                    fontSize: AppSize.normalText,
                  ),
                  onTap: () => Navigator.pop(context, ImageSourceType.files),
                ),
              ],
            ),
            actions: [
              AppButtons(
                text: AppMessage.cancel,
                onPressed: () => Navigator.pop(context),
                backgroundColor: AppColor.lightGray,
              ),
            ],
          ),
        );
      },
    );
  }
}

enum ImageSourceType {
  gallery,
  files,
}
