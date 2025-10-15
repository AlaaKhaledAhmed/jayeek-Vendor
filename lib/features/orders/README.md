# نظام إدارة الطلبات - Orders Management System

تم بناء نظام إدارة الطلبات بنجاح باستخدام Clean Architecture والهيكلية المتبعة في المشروع.

## الهيكلية 📁

```
lib/features/orders/
├── data/
│   ├── models/
│   │   └── order_model.dart          # Models للطلبات والعناصر
│   └── repositories_impl/
│       └── orders_repository_impl.dart # تنفيذ الـ Repository
├── domain/
│   └── repositories/
│       └── orders_repository.dart      # واجهة الـ Repository
├── providers/
│   ├── orders_list/
│   │   ├── orders_list_state.dart     # حالة قائمة الطلبات
│   │   ├── orders_list_notifier.dart  # منطق قائمة الطلبات
│   │   └── orders_list_provider.dart  # Provider
│   └── order_details/
│       ├── order_details_state.dart    # حالة تفاصيل الطلب
│       ├── order_details_notifier.dart # منطق تفاصيل الطلب
│       └── order_details_provider.dart # Provider
└── presentation/
    ├── screens/
    │   ├── orders_list_screen.dart    # شاشة قائمة الطلبات
    │   └── order_details_screen.dart  # شاشة تفاصيل الطلب
    └── widgets/
        ├── order_card.dart             # بطاقة الطلب
        ├── status_filter_chip.dart     # فلتر الحالة
        ├── order_item_widget.dart      # عنصر الطلب
        └── order_status_timeline.dart  # Timeline الحالة
```

## المميزات ✨

### 1. صفحة قائمة الطلبات (Orders List Screen)
- عرض جميع الطلبات مع Pagination
- فلترة الطلبات حسب الحالة:
  - طلبات جديدة (Pending)
  - مؤكد (Confirmed)
  - قيد التحضير (Preparing)
  - جاهز (Ready)
  - في الطريق (On The Way)
  - تم التوصيل (Delivered)
- Pull to refresh
- تصميم عصري مع حالات فارغة وخطأ

### 2. صفحة تفاصيل الطلب (Order Details Screen)
- عرض تفاصيل الطلب الكاملة
- Timeline لحالة الطلب
- معلومات العميل
- قائمة المنتجات مع الإضافات
- ملاحظات الطلب
- ملخص الفاتورة
- أزرار تحديث الحالة حسب الحالة الحالية

### 3. إدارة حالة الطلب (Order Status Management)
- قبول الطلب مع تحديد وقت التحضير المتوقع
- رفض الطلب مع سبب اختياري
- تحديث حالة الطلب:
  - بدء التحضير
  - جاهز للتوصيل
  - تم الشحن
  - تم التوصيل

### 4. التصميم
- تصميم Material Design عصري
- ألوان مميزة لكل حالة
- Shadows و Borders
- استجابة سريعة
- تجربة مستخدم سلسة

## حالات الطلب 🔄

```dart
enum OrderStatus {
  pending       // طلب جديد - أصفر
  confirmed     // مؤكد - أزرق فاتح
  preparing     // قيد التحضير - بنفسجي
  ready         // جاهز - أخضر فاتح
  onTheWay      // في الطريق - أزرق
  delivered     // تم التوصيل - أخضر
  cancelled     // ملغي - أحمر
}
```

## API Endpoints 🌐

```dart
// الحصول على قائمة الطلبات
GET /api/Organization/Orders?status=pending&page=1

// الحصول على تفاصيل طلب
GET /api/Organization/Orders/{orderId}

// تحديث حالة الطلب
POST /api/Organization/Orders/{orderId}/status
Body: { "status": "confirmed" }

// قبول الطلب
POST /api/Organization/Orders/{orderId}/accept
Body: { "estimated_time": 30 }

// رفض الطلب
POST /api/Organization/Orders/{orderId}/reject
Body: { "reason": "سبب الرفض" }
```

## الاستخدام 📱

### التنقل للطلبات من الشاشة الرئيسية:
الطلبات متاحة من خلال Bottom Navigation Bar في الـ HomePage

### الانتقال لتفاصيل الطلب:
```dart
AppRoutes.pushTo(
  context,
  OrderDetailsScreen(orderId: order.id),
);
```

### قبول طلب:
1. اضغط على "قبول الطلب"
2. أدخل الوقت المتوقع للتحضير (اختياري)
3. اضغط تأكيد

### رفض طلب:
1. اضغط على "رفض الطلب"
2. أدخل سبب الرفض (اختياري)
3. اضغط تأكيد

### تحديث حالة الطلب:
- الطلبات المؤكدة: "بدء التحضير"
- الطلبات قيد التحضير: "جاهز للتوصيل"
- الطلبات الجاهزة: "تم الشحن"
- الطلبات في الطريق: "تم التوصيل"

## الملفات المحدثة 📝

1. **lib/core/constants/app_string.dart** - إضافة نصوص الطلبات
2. **lib/core/constants/app_end_points.dart** - إضافة endpoints الطلبات
3. **lib/core/constants/app_size.dart** - إضافة normalText و heading3
4. **lib/core/constants/app_color.dart** - إضافة ألوان جديدة
5. **lib/core/di/locator_providers.dart** - إضافة ordersDi
6. **lib/features/home/presentation/screens/home_page.dart** - ربط شاشة الطلبات

## ملاحظات هامة ⚠️

1. تأكد من وجود حزمة `intl` في pubspec.yaml لتنسيق التواريخ
2. جميع الـ Endpoints تحتاج authentication token
3. التطبيق يدعم اللغة العربية بالكامل
4. التصميم responsive ويعمل على جميع أحجام الشاشات

## الخطوات التالية 🚀

1. ربط الـ API الفعلي
2. إضافة إشعارات للطلبات الجديدة (Push Notifications)
3. إضافة طباعة الفواتير
4. إضافة تقارير الطلبات
5. إضافة صوت عند استلام طلب جديد

---

تم بناء النظام باتباع Clean Architecture و SOLID Principles 🎯

