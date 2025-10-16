import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/util/validator.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_fields.dart';
import '../../data/models/vendor_model.dart';

class EditProfileScreen extends StatefulWidget {
  final VendorModel vendor;

  const EditProfileScreen({
    super.key,
    required this.vendor,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _restaurantNameController;
  late final TextEditingController _supervisorNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _licenseNumberController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _restaurantNameController =
        TextEditingController(text: widget.vendor.restaurantName);
    _supervisorNameController =
        TextEditingController(text: widget.vendor.supervisorName);
    _emailController = TextEditingController(text: widget.vendor.email);
    _phoneController = TextEditingController(text: widget.vendor.phone);
    _licenseNumberController =
        TextEditingController(text: widget.vendor.licenseNumber);
    _addressController = TextEditingController(text: widget.vendor.address);
    _cityController = TextEditingController(text: widget.vendor.city);
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _supervisorNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const AppBarWidget(
        text: 'تعديل الملف الشخصي',
        hideBackButton: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppSize.horizontalPadding),
          children: [
            // شعار المطعم
            _buildLogoSection(),

            SizedBox(height: 32.h),

            // معلومات المطعم
            _buildSectionTitle('معلومات المطعم'),
            SizedBox(height: 16.h),

            AppTextFields(
              hintText: AppMessage.name,
              controller: _restaurantNameController,
              validator: AppValidator.validatorEmpty,
            ),
            SizedBox(height: 16.h),

            AppTextFields(
              hintText: 'رقم الترخيص',
              controller: _licenseNumberController,
              validator: AppValidator.validatorEmpty,
            ),
            SizedBox(height: 16.h),

            AppTextFields(
              hintText: 'العنوان',
              controller: _addressController,
              validator: AppValidator.validatorEmpty,
            ),
            SizedBox(height: 16.h),

            AppTextFields(
              hintText: 'المدينة',
              controller: _cityController,
              validator: AppValidator.validatorEmpty,
            ),

            SizedBox(height: 32.h),

            // معلومات المشرف
            _buildSectionTitle('معلومات المشرف'),
            SizedBox(height: 16.h),

            AppTextFields(
              hintText: AppMessage.supervisor,
              controller: _supervisorNameController,
              validator: AppValidator.validatorEmpty,
            ),
            SizedBox(height: 16.h),

            AppTextFields(
              hintText: AppMessage.phone,
              controller: _phoneController,
              validator: AppValidator.validatorPhone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
              ltr: true,
            ),
            SizedBox(height: 16.h),

            AppTextFields(
              hintText: AppMessage.email,
              controller: _emailController,
              validator: AppValidator.validatorEmpty,
              keyboardType: TextInputType.emailAddress,
              ltr: true,
            ),

            SizedBox(height: 32.h),

            // زر الحفظ
            AppButtons(
              text: AppMessage.saveChanges,
              onPressed: _saveChanges,
              width: double.infinity,
              backgroundColor: AppColor.mainColor,
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.borderColor,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: widget.vendor.logo != null
                  ? Image.network(
                      widget.vendor.logo!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildDefaultLogo(),
                    )
                  : _buildDefaultLogo(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                // فتح معرض الصور
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('اختيار صورة جديدة')),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColor.mainColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.white,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 20.sp,
                  color: AppColor.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLogo() {
    return Container(
      color: AppColor.mainColor.withOpacity(0.1),
      child: Icon(
        Icons.restaurant_rounded,
        size: 50.sp,
        color: AppColor.mainColor,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return AppText(
      text: title,
      fontSize: AppSize.heading3,
      fontWeight: AppThem().bold,
      color: AppColor.textColor,
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // TODO: حفظ التعديلات في الـ API أو الـ Local Storage

      // عرض رسالة النجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم حفظ التعديلات بنجاح'),
          backgroundColor: AppColor.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // الرجوع للصفحة السابقة
      Navigator.pop(context);
    }
  }
}
