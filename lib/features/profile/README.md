# 👤 Profile Module - وحدة البروفايل

## 📋 نظرة عامة

وحدة عصرية واحترافية لعرض وإدارة معلومات المطعم والمشرف مع تصميم متناسق مع باقي التطبيق.

---

## 🏗️ البنية المعمارية

```
lib/features/profile/
├── data/
│   ├── models/
│   │   └── vendor_model.dart          # نموذج بيانات المطعم
│   └── mock/
│       └── mock_vendor_data.dart      # بيانات تجريبية
├── presentation/
│   ├── screens/
│   │   └── profile.dart               # الشاشة الرئيسية
│   └── widgets/
│       ├── profile_header.dart        # رأس الصفحة مع الإحصائيات
│       ├── profile_info_tile.dart     # بطاقة معلومة
│       ├── profile_action_tile.dart   # بطاقة إجراء
│       └── profile_section_title.dart # عنوان قسم
└── README.md
```

---

## 🎨 المكونات الرئيسية

### 1. **ProfileHeader** 
رأس عصري يعرض:
- شعار المطعم
- اسم المطعم
- التقييم وعدد الطلبات
- إحصائيات (إجمالي الطلبات، إجمالي المبيعات)
- تدرج لوني جذاب

### 2. **ProfileInfoTile**
بطاقة لعرض معلومة واحدة مع:
- أيقونة ملونة
- عنوان ووصف
- إمكانية النقر للتعديل
- سهم اختياري

### 3. **ProfileActionTile**
بطاقة للإجراءات مع:
- أيقونة ملونة
- عنوان ووصف
- widget مخصص أو سهم
- دعم Switch وغيره

### 4. **ProfileSectionTitle**
عنوان قسم أنيق مع أيقونة اختيارية

---

## 📊 نموذج البيانات

### VendorModel
```dart
class VendorModel {
  final String id;
  final String restaurantName;      // اسم المطعم
  final String supervisorName;      // اسم المشرف
  final String email;                // البريد الإلكتروني
  final String phone;                // رقم الجوال
  final String? logo;                // شعار المطعم
  final String? licenseNumber;       // رقم الترخيص
  final String? address;             // العنوان
  final String? city;                // المدينة
  final double? rating;              // التقييم
  final int? totalOrders;            // إجمالي الطلبات
  final double? totalSales;          // إجمالي المبيعات
  final bool isActive;               // حالة المطعم
  final DateTime? createdAt;         // تاريخ الإنشاء
  final WorkingHours? workingHours;  // ساعات العمل
}
```

### WorkingHours
```dart
class WorkingHours {
  final String openTime;           // وقت الفتح (مثال: "10:00")
  final String closeTime;          // وقت الإغلاق (مثال: "23:30")
  final List<int> workingDays;     // أيام العمل (1-7)
}
```

---

## 📱 أقسام الصفحة

### 1. معلومات المطعم 🏪
- رقم الترخيص
- العنوان (قابل للتعديل)
- المدينة
- ساعات العمل (قابلة للتعديل)

### 2. معلومات المشرف 👨‍💼
- اسم المشرف
- رقم الجوال
- البريد الإلكتروني

### 3. الإعدادات ⚙️
- الإشعارات
- اللغة
- حالة المطعم (مفتوح/مغلق) مع Switch

### 4. الحساب 👤
- تعديل الملف الشخصي
- تغيير كلمة المرور
- المساعدة والدعم
- عن التطبيق
- تسجيل الخروج

---

## 🎨 التصميم

### الألوان المستخدمة
- **الرئيسي**: `AppColor.mainColor` - للخلفية والعناصر الرئيسية
- **الأخضر**: `AppColor.green` - للحالات الإيجابية
- **الأحمر**: `AppColor.red` - للتحذيرات والخروج
- **الأزرق**: `AppColor.blue` - للمعلومات
- **الكهرماني**: `AppColor.amber` - للتقييمات

### المسافات والأحجام
- استخدام `ScreenUtil` للتناسق عبر الشاشات
- مسافة افتراضية: `AppSize.horizontalPadding`
- بطاقات دائرية: `16.r`
- أيقونات: `22-24.sp`

### الظلال والحدود
- حدود خفيفة: `AppColor.borderColor`
- ظلال ناعمة للبطاقات
- تدرجات لونية في الرأس

---

## 🚀 الاستخدام

```dart
// في main_nav أو home page
ProfileScreen()
```

---

## ✨ المميزات

✅ **تصميم عصري** - يتماشى مع أحدث اتجاهات UI/UX  
✅ **Clean Code** - كود نظيف ومنظم  
✅ **Reusable Components** - مكونات قابلة لإعادة الاستخدام  
✅ **Responsive** - متجاوب مع جميع أحجام الشاشات  
✅ **Mock Data** - بيانات تجريبية للاختبار  
✅ **Scalable** - قابل للتوسع بسهولة  
✅ **RTL Support** - دعم كامل للعربية  
✅ **Professional** - احترافي مثل تطبيقات التوصيل الشهيرة  

---

## 🔮 التطويرات المستقبلية

- [ ] صفحة تعديل البروفايل
- [ ] رفع وتعديل شعار المطعم
- [ ] صفحة إعدادات الإشعارات
- [ ] تغيير اللغة ديناميكياً
- [ ] صفحة تغيير كلمة المرور
- [ ] تكامل مع API حقيقي
- [ ] إضافة صور للمطعم (معرض)
- [ ] إدارة الفروع
- [ ] إحصائيات مفصلة

---

## 📝 ملاحظات

### الحقول المطلوبة في التسجيل
وفقاً لـ `sing_up.dart`:
- ✅ اسم المطعم (`restaurantName`)
- ✅ اسم المشرف (`supervisorName`)
- ✅ البريد الإلكتروني (`email`)
- ✅ رقم الجوال (`phone`)
- ✅ كلمة المرور (`password`)

### حقول إضافية مهمة
- ✅ رقم الترخيص (`licenseNumber`)
- ✅ العنوان (`address`)
- ✅ المدينة (`city`)
- ✅ ساعات العمل (`workingHours`)
- ✅ التقييم والإحصائيات

---

## 🎯 أمثلة

### استخدام VendorModel
```dart
final vendor = VendorModel(
  id: '1',
  restaurantName: 'مطعم جايك',
  supervisorName: 'أحمد محمد',
  email: 'info@jayeek.com',
  phone: '+966501234567',
  licenseNumber: 'CR-2024-12345',
  address: 'شارع الملك فهد',
  city: 'جدة',
  rating: 4.8,
  totalOrders: 1523,
  totalSales: 156789.50,
  isActive: true,
  workingHours: WorkingHours(
    openTime: '10:00',
    closeTime: '23:30',
    workingDays: [1, 2, 3, 4, 5, 6, 7],
  ),
);
```

### استخدام ProfileInfoTile
```dart
ProfileInfoTile(
  icon: Icons.email_rounded,
  title: 'البريد الإلكتروني',
  value: vendor.email,
  iconColor: AppColor.blue,
)
```

### استخدام ProfileActionTile
```dart
ProfileActionTile(
  icon: Icons.edit_rounded,
  title: 'تعديل الملف الشخصي',
  subtitle: 'تعديل معلومات المطعم',
  onTap: () {
    // Navigate to edit screen
  },
)
```

---

## 🛠️ التكامل مع باقي التطبيق

### الهيكلية المتبعة
- ✅ نفس هيكلية Orders
- ✅ استخدام نفس الـ Widgets (AppText, AppButtons, إلخ)
- ✅ نفس نمط التسمية والتنظيم
- ✅ Clean Code principles
- ✅ Separation of Concerns

---

## 📚 المراجع

- تصميم مستوحى من: Uber Eats, Talabat, HungerStation
- يتبع Material Design Guidelines
- يستخدم Flutter Best Practices
- Clean Architecture Pattern

---

تم التصميم والتطوير بعناية ✨

