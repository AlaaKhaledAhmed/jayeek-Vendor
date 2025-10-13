import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

// Widgets الخاصة بك:
import '../widgets/app_text.dart';
import '../widgets/app_buttons.dart';
import '../constants/app_color.dart';
import '../theme/app_them.dart';
import '../widgets/bottom_sheet.dart';

class PhotoPermissionService {
  PhotoPermissionService._();

  /// يتأكد من صلاحية الوصول للصور ويطلبها إن لزم.
  /// يعرض BottomSheet في حالة الرفض النهائي لفتح الإعدادات.
  /// يعيد true إذا أصبح الوصول متاحًا، false خلاف ذلك.
  static Future<bool> ensurePhotosPermission(BuildContext context) async {
    final Permission permission = await _platformPhotoPermission();

    // 1) الحالة الحالية
    PermissionStatus status = await permission.status;
    if (_isUsable(status)) return true;

    // 2) اطلب إذن
    status = await permission.request();
    if (_isUsable(status)) return true;

    // 3) الرفض النهائي -> اسأل المستخدم فتح الإعدادات
    if (status.isPermanentlyDenied) {
      final wants = await _askOpenSettings(context);
      if (wants == true) {
        final opened = await openSettings();
        if (!opened) return false; // ما قدر نفتح الإعدادات

        // بعد العودة، أعد الفحص بهدوء
        final PermissionStatus recheck = await permission.status;
        return _isUsable(recheck);
      }
    }

    return false;
  }

  /// فتح إعدادات التطبيق. يعيد true إذا تم فتح الإعدادات بنجاح.
  static Future<bool> openSettings() async => await openAppSettings();

  // ----------------- Helpers -----------------

  /// إذن الصور المناسب حسب النظام/النسخة:
  /// - iOS: Permission.photos
  /// - Android 13+: Permission.photos (READ_MEDIA_IMAGES)
  /// - Android <=12: Permission.storage (READ_EXTERNAL_STORAGE)
  static Future<Permission> _platformPhotoPermission() async {
    if (Platform.isIOS) return Permission.photos;

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      final sdk = info.version.sdkInt;
      if (sdk >= 33) {
        // Android 13+
        return Permission
            .photos; // يدعمها permission_handler كـ READ_MEDIA_IMAGES
      } else {
        // Android 12 وأقل
        return Permission.storage;
      }
    }

    // منصات أخرى: اعتبرها غير مدعومة -> اختر photos كافتراضي.
    return Permission.photos;
  }

  /// نعتبر الإذن usable لو Granted (وعلى iOS: Limited تُترجم إلى granted من النظام).
  static bool _isUsable(PermissionStatus s) => s.isGranted;

  /// BottomSheet يسأل فتح الإعدادات
  static Future<bool?> _askOpenSettings(BuildContext context) {
    return CustomBottomSheet.show<bool>(
      context: context,

      child: const _SettingsPrompt(),
    );
  }
}

/// محتوى رسالة التأكيد قبل فتح الإعدادات
class _SettingsPrompt extends StatelessWidget {
  const _SettingsPrompt();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(text: 'لا يمكن الوصول إلى الصور', fontWeight: AppThem().bold),
        const SizedBox(height: 8),
        const AppText(
          text:
              'لتتمكّن من اختيار صورة للمنتج، يرجى منح الإذن للوصول إلى الصور.\n'
              'هل ترغب في فتح الإعدادات الآن وتمكين الإذن؟',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppButtons(
                text: 'فتح الإعدادات',
                onPressed: () => Navigator.of(context).pop(true),
                backgroundColor: AppColor.mainColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppButtons(
                text: 'لاحقًا',
                onPressed: () => Navigator.of(context).pop(false),
                backgroundColor: AppColor.subtextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
