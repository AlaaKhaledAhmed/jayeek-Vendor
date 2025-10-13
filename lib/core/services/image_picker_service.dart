import 'package:image_picker/image_picker.dart';

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
}
