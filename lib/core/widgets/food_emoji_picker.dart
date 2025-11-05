import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jayeek_vendor/core/constants/app_color.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/constants/app_size.dart';

/// قائمة emojis الطعام بدون مكتبة خارجية
class FoodEmojiPicker extends StatefulWidget {
  final Function(String) onEmojiSelected;
  final String? selectedEmoji;

  const FoodEmojiPicker({
    super.key,
    required this.onEmojiSelected,
    this.selectedEmoji,
  });
  
  /// Static method to show emoji picker as bottom sheet
  static Future<String?> showPicker(BuildContext context, {String? selectedEmoji}) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FoodEmojiPicker(
          selectedEmoji: selectedEmoji,
          onEmojiSelected: (emoji) {
            // Callback handled in the widget
          },
        );
      },
    );
  }

  @override
  State<FoodEmojiPicker> createState() => _FoodEmojiPickerState();
}

class _FoodEmojiPickerState extends State<FoodEmojiPicker> {
  // قائمة emojis الطعام والشراب الشائعة
  static const List<String> foodEmojis = [
    // فواكه
    '🍎', '🍏', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🫐', '🍈', 
    '🍒', '🍑', '🥭', '🍍', '🥥', '🥝', '🍅', '🫒', '🥑',
    
    // خضروات
    '🥦', '🥬', '🥒', '🌶️', '🫑', '🌽', '🥕', '🫚', '🧄', '🧅',
    '🥔', '🍠', '🫘', '🥜', '🌰',
    
    // وجبات رئيسية
    '🍕', '🍔', '🍟', '🌭', '🥪', '🌮', '🌯', '🫔', '🥙', '🧆',
    '🥚', '🍳', '🥘', '🍲', '🥣', '🥗', '🍿', '🧈', '🧂',
    
    // لحوم ومأكولات بحرية
    '🍗', '🍖', '🦴', '🌭', '🥓', '🍤', '🦞', '🦀', '🐙', '🦑',
    '🍣', '🍱', '🍛', '🍙', '🍚', '🍘',
    
    // معجنات وحلويات
    '🍞', '🥐', '🥖', '🫓', '🥨', '🥯', '🥞', '🧇', '🧀', '🍖',
    '🥩', '🍗', '🦴',
    
    // حلويات
    '🎂', '🍰', '🧁', '🥧', '🍮', '🍭', '🍬', '🍫', '🍿', '🍩',
    '🍪', '🌰', '🥜',
    
    // مشروبات
    '☕', '🍵', '🧃', '🥤', '🧋', '🍶', '🍺', '🍻', '🥂', '🍷',
    '🥃', '🍸', '🍹', '🧉', '🍾', '🧊',
    
    // آيس كريم وحلويات باردة
    '🍦', '🍧', '🍨', '🍡', '🍢', '🍥', '🥟', '🥠', '🥮',
    
    // معكرونة وأرز
    '🍝', '🍜', '🍲', '🍛', '🍱', '🍙', '🍚', '🍘',
    
    // أطباق آسيوية
    '🥡', '🥢', '🍱', '🍜', '🍲', '🥘', '🍳',
  ];

  String? _selectedEmoji;

  @override
  void initState() {
    super.initState();
    _selectedEmoji = widget.selectedEmoji;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.h,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColor.mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant,
                  color: AppColor.mainColor,
                  size: 24.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: AppText(
                    text: 'اختر أيقونة طعام',
                    fontSize: AppSize.bodyText,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textColor,
                  ),
                ),
                if (_selectedEmoji != null)
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColor.mainColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      _selectedEmoji!,
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ),
                SizedBox(width: 10.w),
                IconButton(
                  icon: Icon(Icons.close, color: AppColor.mediumGray),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Emoji Grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                ),
                itemCount: foodEmojis.length,
                itemBuilder: (context, index) {
                  final emoji = foodEmojis[index];
                  final isSelected = emoji == _selectedEmoji;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedEmoji = emoji;
                      });
                      // تأخير قصير لإظهار التحديد قبل الإغلاق
                      Future.delayed(const Duration(milliseconds: 150), () {
                        widget.onEmojiSelected(emoji);
                        Navigator.pop(context, emoji);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColor.mainColor.withOpacity(0.2)
                            : AppColor.lightGray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected 
                              ? AppColor.mainColor 
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 28.sp),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

