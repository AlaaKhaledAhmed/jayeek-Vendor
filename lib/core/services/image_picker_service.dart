import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_color.dart';
import '../constants/app_icons.dart';
import '../constants/app_size.dart';
import '../constants/app_string.dart';
import '../widgets/app_text.dart';

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

  /// Shows bottom sheet to choose image source
  static Future<ImageSourceType?> _showImageSourceDialog(
      BuildContext context) async {
    return showModalBottomSheet<ImageSourceType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColor.black.withOpacity(0.5),
      isDismissible: true,
      enableDrag: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28.r),
              topRight: Radius.circular(28.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: 12.h,
            left: 20.w,
            right: 20.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 48.w,
                height: 5.h,
                margin: EdgeInsets.only(bottom: 24.h),
                decoration: BoxDecoration(
                  color: AppColor.mediumGray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
              // Title
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: AppText(
                  text: AppMessage.selectImageSource,
                  fontSize: AppSize.heading2,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textColor,
                ),
              ),
              SizedBox(height: 24.h),
              // Gallery option
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context, ImageSourceType.gallery),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.mainColor.withOpacity(0.15),
                          AppColor.mainColor.withOpacity(0.08),
                        ],
                        begin: AlignmentDirectional.centerStart,
                        end: AlignmentDirectional.centerEnd,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColor.mainColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.mainColor,
                                AppColor.mainColor.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.mainColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            AppIcons.image,
                            color: AppColor.white,
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: AppText(
                            text: AppMessage.photoLibrary,
                            fontSize: AppSize.bodyText,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textColor,
                          ),
                        ),
                        Icon(
                          Icons.arrow_back_ios,
                          size: 18.sp,
                          color: AppColor.mediumGray,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Files option
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context, ImageSourceType.files),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.withOpacity(0.15),
                          Colors.orange.withOpacity(0.08),
                        ],
                        begin: AlignmentDirectional.centerStart,
                        end: AlignmentDirectional.centerEnd,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade600,
                                Colors.orange.shade400,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            AppIcons.folder,
                            color: AppColor.white,
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: AppText(
                            text: AppMessage.files,
                            fontSize: AppSize.bodyText,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textColor,
                          ),
                        ),
                        Icon(
                          Icons.arrow_back_ios,
                          size: 18.sp,
                          color: AppColor.mediumGray,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              // Cancel button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: AppColor.lightGray.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColor.lightGray,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: AppText(
                        text: AppMessage.cancel,
                        fontSize: AppSize.bodyText,
                        fontWeight: FontWeight.w600,
                        color: AppColor.subGrayText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ImageSourceType {
  gallery,
  files,
}
