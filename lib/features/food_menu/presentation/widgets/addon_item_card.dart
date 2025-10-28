import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/constants/app_icons.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/extensions/color_extensions.dart';
import 'package:jayeek_vendor/core/widgets/app_decoration.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/image_placeholder_widget.dart';
import 'package:jayeek_vendor/generated/assets.dart';

import '../../domain/models/custom_addon_model.dart';

class AddonItemCard extends StatelessWidget {
  final CustomAddonModel addon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddonItemCard({
    super.key,
    required this.addon,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: AppDecoration.decoration(
          color: AppColor.white,
          radius: 12,
          shadowOpacity: 0.1,
          showBorder: true,
          borderColor: AppColor.borderColor,
          borderWidth: 1,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 8.h,
          ),
          leading: _buildImageWidget(),
          title: AppText(
            text: addon.name,
            fontSize: AppSize.normalText,
            fontWeight: FontWeight.bold,
            color: AppColor.textColor,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              AppText(
                text: addon.description,
                fontSize: AppSize.captionText,
                color: AppColor.subGrayText,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              AppText(
                text: '${addon.price.toStringAsFixed(0)} ${AppMessage.sar}',
                fontSize: AppSize.captionText,
                fontWeight: FontWeight.bold,
                color: AppColor.subtextColor,
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: onDelete,
            icon: Icon(
              AppIcons.delete,
              color: AppColor.red,
              size: AppSize.mediumIconSize,
            ),
          ),
        ),
      ),
    );
  }

  ///addon image======================================================================================================
  Widget _buildImageWidget() {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: AppDecoration.decoration(
          shadow: false,
          color: AppColor.lightGray,
          radius: 8,
          image: addon.imageUrl != null && addon.imageUrl!.isNotEmpty
              ? NetworkImage(addon.imageUrl!)
              : const AssetImage(Assets.imagesDefault,) as ImageProvider<Object>,
          cover: addon.imageUrl != null && addon.imageUrl!.isNotEmpty
              ? true
              : false),
    );
  }

  String _getUnitTypeText(String unitType) {
    switch (unitType.toLowerCase()) {
      case 'piece':
        return AppMessage.piece;
      case 'kilogram':
        return AppMessage.kilogram;
      case 'gram':
        return AppMessage.gram;
      default:
        return unitType;
    }
  }
}
