import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jayeek_vendor/core/util/print_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import '../constants/app_color.dart';
import '../constants/app_string.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_snack_bar.dart';

class AppPermissions {
  //=====================================================================================
  static Future getFile(
      {required BuildContext context, List<String>? allowedExtensions}) async {
    final bool result = await storagePermission(context: context);

    ///if permission done
    if (result) {
      final FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? ['pdf'],
      );
      if (file != null) {
        return File(file.files.single.path!);
      } else {
        return null;
      }
    } else {
      return;
    }
  }

//=========================================================
  static Future getPhoto({required BuildContext context}) async {
    final bool? result = await photoPermission(context: context);
    final ImagePicker picker = ImagePicker();

    ///catch error when pick images
    if (result == null) {
      return AppSnackBar.show(
        message: AppMessage.formatText,
        type: ToastType.error,
      );
    }

    ///if permission is denial
    if (result == false) {
      return permissionDenied(context);
    }

    ///if permission is isGranted
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return File(file.path);

      ///if no file selected
    } else {
      return;
    }
  }

//============================================================================================
  static permissionDenied(context, {String? title, String? subTitle}) {
    return AppDialog.noPermissionDialog(
        context: context,
        message: subTitle ?? AppMessage.accessImage,
        title: title ?? 'تنبيه');
  }

//pick image========================================================================================
  static Future<bool> photoPermission({required BuildContext context}) async {
    try {
      if (Platform.isIOS) {
        // final permissionStatus = await Permission.photos.status;
        // printInfo('value');
        // if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        //   final res = await Permission.photos.request();
        //   if (res.isDenied || res.isPermanentlyDenied) {
        //     printInfo('isPermanentlyDenied');
        //     return false;
        //   }
        // }
        return true;
      } else if (Platform.isAndroid) {
        final device = await DeviceInfoPlugin().androidInfo;
        if (device.version.sdkInt < 33) {
          final permissionStatus = await Permission.storage.status;
          if (permissionStatus.isDenied ||
              permissionStatus.isPermanentlyDenied) {
            final res = await Permission.storage.request();
            if (res.isDenied || res.isPermanentlyDenied) {
              return false;
            }
          }
        }
        return true;
      }
    } catch (e) {
      printInfo('Error picking image: $e');
      return false;
      // return null;
    }
    return false;
    //return null;
  }

//pick image========================================================================================
  static Future recordPermission({required BuildContext context}) async {
    final PermissionStatus recordPermission =
        await Permission.microphone.request();
    if (recordPermission.isGranted) {
      return true;
    } else if (recordPermission.isPermanentlyDenied) {
      AppDialog.noPermissionDialog(
          context: context,
          message: AppMessage.micPermissionMessage,
          title: AppMessage.micPermission);
    }
  }

//pick File form device===================================================================================================
  static Future<bool> storagePermission({required BuildContext context}) async {
    if (Platform.isIOS) {
      final permissionStatus = await Permission.storage.status;
      if (permissionStatus.isDenied) {
        print('isDenied');
        final res = await Permission.storage.request();
        if (res.isDenied || res.isPermanentlyDenied) {
          print('isDenied || isPermanentlyDenied');
          return false;
        }
      } else if (permissionStatus.isPermanentlyDenied) {
        print('isPermanentlyDenied');
        return false;
      } else {
        return true;
      }
    }
//==============================================================
    else if (Platform.isAndroid) {
      final device = await DeviceInfoPlugin().androidInfo;
      printInfo('DeviceInfoPlugin: ${device.version.sdkInt}');
      if (device.version.sdkInt < 33) {
        final permissionStatus = await Permission.storage.status;
        if (permissionStatus.isDenied) {
          print('isDenied');
          final res = await Permission.storage.request();
          if (res.isDenied || res.isPermanentlyDenied) {
            print('isDenied || isPermanentlyDenied');
            return false;
          }
        } else if (permissionStatus.isPermanentlyDenied) {
          print('isPermanentlyDenied');
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

//=====================================================================================
  static Future cropImage(File image) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColor.mainColor,
            toolbarWidgetColor: AppColor.white,
            activeControlsWidgetColor: AppColor.mainColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    return croppedFile == null ? null : File(croppedFile.path);
  }
}
