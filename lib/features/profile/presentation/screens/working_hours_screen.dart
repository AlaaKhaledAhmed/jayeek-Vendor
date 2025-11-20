import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/theme/app_them.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_decoration.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/vendor_model.dart';

class WorkingHoursScreen extends StatefulWidget {
  final VendorModel vendor;

  const WorkingHoursScreen({
    super.key,
    required this.vendor,
  });

  @override
  State<WorkingHoursScreen> createState() => _WorkingHoursScreenState();
}

class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  late TimeOfDay _openTime;
  late TimeOfDay _closeTime;
  late List<bool> _selectedDays;

  final List<String> _daysOfWeek = [
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  @override
  void initState() {
    super.initState();

    // تحويل ساعات العمل من String إلى TimeOfDay
    if (widget.vendor.workingHours != null) {
      final openParts = widget.vendor.workingHours!.openTime.split(':');
      _openTime = TimeOfDay(
        hour: int.parse(openParts[0]),
        minute: int.parse(openParts[1]),
      );

      final closeParts = widget.vendor.workingHours!.closeTime.split(':');
      _closeTime = TimeOfDay(
        hour: int.parse(closeParts[0]),
        minute: int.parse(closeParts[1]),
      );
    } else {
      // قيم افتراضية
      _openTime = const TimeOfDay(hour: 9, minute: 0);
      _closeTime = const TimeOfDay(hour: 23, minute: 0);
    }

    // تهيئة أيام العمل (افتراضياً جميع الأيام مفعلة)
    _selectedDays = List.generate(7, (index) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const AppBarWidget(
        text: 'ساعات العمل',
        hideBackButton: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSize.horizontalPadding),
        children: [
          // معلومات توضيحية
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: AppDecoration.decoration(
              color: AppColor.blue.withOpacity(0.1),
              showBorder: true,
              borderColor: AppColor.blue.withOpacity(0.3),
              shadow: false,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: AppColor.blue,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppText(
                    text: 'حدد ساعات عمل مطعمك وأيام العمل الأسبوعية',
                    fontSize: AppSize.smallText,
                    color: AppColor.textColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32.h),

          // وقت الفتح
          _buildSectionTitle('وقت الفتح'),
          SizedBox(height: 16.h),
          _buildTimePicker(
            label: 'وقت الفتح',
            time: _openTime,
            icon: Icons.wb_sunny_rounded,
            iconColor: AppColor.green,
            onTap: () => _selectTime(context, isOpenTime: true),
          ),

          SizedBox(height: 24.h),

          // وقت الإغلاق
          _buildSectionTitle('وقت الإغلاق'),
          SizedBox(height: 16.h),
          _buildTimePicker(
            label: 'وقت الإغلاق',
            time: _closeTime,
            icon: Icons.nights_stay_rounded,
            iconColor: AppColor.mainColor,
            onTap: () => _selectTime(context, isOpenTime: false),
          ),

          SizedBox(height: 32.h),

          // أيام العمل
          _buildSectionTitle('أيام العمل'),
          SizedBox(height: 16.h),
          _buildDaysSelector(),

          SizedBox(height: 32.h),

          // ملخص ساعات العمل
          _buildSummaryCard(),

          SizedBox(height: 32.h),

          // زر الحفظ
          AppButtons(
            text: AppMessage.saveChanges,
            onPressed: _saveWorkingHours,
            width: double.infinity,
            backgroundColor: AppColor.mainColor,
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return AppText(
      text: title,
      fontSize: AppSize.normalText,
      fontWeight: AppThem().bold,
      color: AppColor.textColor,
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay time,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: AppDecoration.decoration(
          showBorder: true,
          borderColor: AppColor.borderColor,
          shadow: false,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 24.sp,
                color: iconColor,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: label,
                    fontSize: AppSize.smallText,
                    color: AppColor.subGrayText,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    text: _formatTime(time),
                    fontSize: AppSize.normalText,
                    fontWeight: AppThem().bold,
                    color: AppColor.textColor,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.access_time_rounded,
              size: 24.sp,
              color: AppColor.subGrayText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysSelector() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: AppDecoration.decoration(
        showBorder: true,
        borderColor: AppColor.borderColor,
        shadow: false,
      ),
      child: Column(
        children: List.generate(_daysOfWeek.length, (index) {
          return Column(
            children: [
              if (index > 0)
                const Divider(height: 1, color: AppColor.borderColor),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedDays[index] = !_selectedDays[index];
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _selectedDays[index],
                        onChanged: (value) {
                          setState(() {
                            _selectedDays[index] = value ?? false;
                          });
                        },
                        activeColor: AppColor.green,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: AppText(
                          text: _daysOfWeek[index],
                          fontSize: AppSize.normalText,
                          color: _selectedDays[index]
                              ? AppColor.textColor
                              : AppColor.subGrayText,
                          fontWeight: _selectedDays[index]
                              ? AppThem().bold
                              : AppThem().regular,
                        ),
                      ),
                      if (_selectedDays[index])
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: AppText(
                            text: 'مفتوح',
                            fontSize: AppSize.captionText,
                            color: AppColor.green,
                            fontWeight: AppThem().bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final selectedDaysCount = _selectedDays.where((day) => day).length;
    final totalHours = _calculateWorkingHours();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: AppDecoration.decoration(
        color: AppColor.mainColor.withOpacity(0.05),
        showBorder: true,
        borderColor: AppColor.mainColor.withOpacity(0.2),
        shadow: false,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.summarize_rounded,
                color: AppColor.mainColor,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              AppText(
                text: 'ملخص ساعات العمل',
                fontSize: AppSize.normalText,
                fontWeight: AppThem().bold,
                color: AppColor.textColor,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildSummaryRow(
            icon: Icons.schedule_rounded,
            label: 'ساعات العمل اليومية',
            value: '$totalHours ساعة',
          ),
          SizedBox(height: 12.h),
          _buildSummaryRow(
            icon: Icons.calendar_today_rounded,
            label: 'أيام العمل الأسبوعية',
            value: '$selectedDaysCount أيام',
          ),
          SizedBox(height: 12.h),
          _buildSummaryRow(
            icon: Icons.access_time_rounded,
            label:
                'من ${_formatTime(_openTime)} إلى ${_formatTime(_closeTime)}',
            value: '',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: AppColor.mainColor,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: AppText(
            text: label,
            fontSize: AppSize.smallText,
            color: AppColor.subGrayText,
          ),
        ),
        if (value.isNotEmpty)
          AppText(
            text: value,
            fontSize: AppSize.smallText,
            fontWeight: AppThem().bold,
            color: AppColor.mainColor,
          ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context,
      {required bool isOpenTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpenTime ? _openTime : _closeTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.mainColor,
              onPrimary: AppColor.white,
              onSurface: AppColor.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          _openTime = picked;
        } else {
          _closeTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  int _calculateWorkingHours() {
    final openMinutes = _openTime.hour * 60 + _openTime.minute;
    final closeMinutes = _closeTime.hour * 60 + _closeTime.minute;
    final diffMinutes =
        closeMinutes > openMinutes ? closeMinutes - openMinutes : 0;
    return (diffMinutes / 60).round();
  }

  void _saveWorkingHours() {
    // التحقق من وجود يوم واحد على الأقل
    if (!_selectedDays.any((day) => day)) {
      AppSnackBar.show(
        message: 'يجب اختيار يوم واحد على الأقل',
        type: ToastType.error,
      );
      return;
    }

    // التحقق من صحة الأوقات
    if (_calculateWorkingHours() <= 0) {
      AppSnackBar.show(
        message: 'يجب أن يكون وقت الإغلاق بعد وقت الفتح',
        type: ToastType.error,
      );
      return;
    }

    // TODO: حفظ ساعات العمل في الـ API أو الـ Local Storage
    // final selectedDayIndices = [];
    // for (int i = 0; i < _selectedDays.length; i++) {
    //   if (_selectedDays[i]) selectedDayIndices.add(i);
    // }

    // تحديث البيانات التجريبية
    final selectedDayIndices = <int>[];
    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i]) selectedDayIndices.add(i + 1); // 1 = الأحد
    }

    // TODO: Call API to update working hours
    // final response = await profileRepository.updateWorkingHours(
    //   openTime: _formatTime(_openTime),
    //   closeTime: _formatTime(_closeTime),
    //   workingDays: selectedDayIndices,
    // );

    // TODO: في التطبيق الحقيقي، سيتم إرسال البيانات للـ API:
    // await repository.updateWorkingHours(
    //   openTime: _formatTime(_openTime),
    //   closeTime: _formatTime(_closeTime),
    //   workingDays: selectedDayIndices,
    // );

    // عرض رسالة النجاح
    AppSnackBar.show(
      message: 'تم حفظ ساعات العمل بنجاح',
      type: ToastType.success,
    );

    // الرجوع للصفحة السابقة مع إرسال true للإشارة للنجاح
    if (!mounted) return;
    Navigator.pop(context, true);
  }
}
