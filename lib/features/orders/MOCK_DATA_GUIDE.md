# دليل استخدام Mock Data للطلبات

## نظرة عامة
تم إضافة نظام Mock Data متكامل لميزة الطلبات، مما يسمح بالعمل على التطبيق دون الحاجة لـ API حقيقي أثناء التطوير.

## كيفية التبديل بين Mock Data والبيانات الحقيقية

### 1. استخدام Mock Data (البيانات الوهمية)
افتح الملف: `lib/core/constants/app_config.dart`

```dart
class AppConfig {
  static const bool useMockData = true; // ✅ استخدام Mock Data
}
```

### 2. استخدام البيانات الحقيقية (API)
افتح الملف: `lib/core/constants/app_config.dart`

```dart
class AppConfig {
  static const bool useMockData = false; // ✅ استخدام API الحقيقي
}
```

## بنية الملفات

```
lib/features/orders/
├── data/
│   ├── mock/
│   │   └── mock_orders_data.dart          # البيانات الوهمية
│   ├── repositories_impl/
│   │   ├── orders_repository_impl.dart    # Repository للبيانات الحقيقية
│   │   └── mock_orders_repository_impl.dart # Repository للبيانات الوهمية
│   └── models/
│       └── order_model.dart
├── domain/
│   └── repositories/
│       └── orders_repository.dart         # Interface
└── MOCK_DATA_GUIDE.md                     # هذا الملف
```

## البيانات الوهمية المتاحة

### الطلبات المتوفرة (8 طلبات)

1. **ORD-2024-001** - حالة: جديد (Pending)
   - العميل: أحمد محمد
   - المجموع: 131 ريال

2. **ORD-2024-002** - حالة: مؤكد (Confirmed)
   - العميل: سارة خالد
   - المجموع: 122 ريال

3. **ORD-2024-003** - حالة: قيد التحضير (Preparing)
   - العميل: محمد عبدالله
   - المجموع: 102 ريال

4. **ORD-2024-004** - حالة: جاهز (Ready)
   - العميل: فاطمة أحمد
   - المجموع: 113 ريال

5. **ORD-2024-005** - حالة: في الطريق (On The Way)
   - العميل: خالد سعيد
   - المجموع: 91 ريال

6. **ORD-2024-006** - حالة: تم التوصيل (Delivered)
   - العميل: عبدالرحمن يوسف
   - المجموع: 113 ريال

7. **ORD-2024-007** - حالة: ملغي (Cancelled)
   - العميل: نورة علي
   - المجموع: 73 ريال

8. **ORD-2024-008** - حالة: جديد (Pending)
   - العميل: ياسر حسن
   - المجموع: 107 ريال

## العمليات المتاحة

### 1. عرض جميع الطلبات
```dart
final result = await ordersRepository.getOrders();
```

### 2. تصفية الطلبات حسب الحالة
```dart
final result = await ordersRepository.getOrders(
  status: OrderStatus.pending,
);
```

### 3. عرض تفاصيل طلب معين
```dart
final result = await ordersRepository.getOrderDetails(
  orderId: '1',
);
```

### 4. تحديث حالة الطلب
```dart
final result = await ordersRepository.updateOrderStatus(
  orderId: '1',
  newStatus: OrderStatus.preparing,
);
```

### 5. قبول الطلب
```dart
final result = await ordersRepository.acceptOrder(
  orderId: '1',
  estimatedTime: 30, // بالدقائق
);
```

### 6. رفض الطلب
```dart
final result = await ordersRepository.rejectOrder(
  orderId: '1',
  reason: 'المطعم مشغول حالياً',
);
```

## ميزات Mock Repository

### 1. محاكاة تأخير الشبكة
جميع العمليات تحتوي على تأخير وهمي (300-500ms) لمحاكاة سلوك API الحقيقي.

### 2. إدارة الحالة
التغييرات على البيانات تستمر خلال جلسة التطبيق الواحدة.

### 3. Pagination
يدعم التصفح عبر الصفحات (10 طلبات لكل صفحة).

### 4. دوال مساعدة إضافية
```dart
// إعادة تعيين البيانات للحالة الأولية
mockRepository.resetOrders();

// إضافة طلب جديد
mockRepository.addOrder(newOrder);

// حذف طلب
mockRepository.removeOrder('order-id');
```

## أفضل الممارسات

### 1. أثناء التطوير
- استخدم `useMockData = true` للعمل دون الحاجة للـ backend
- يمكنك تعديل البيانات في `mock_orders_data.dart` حسب احتياجك

### 2. أثناء الاختبار
- اختبر جميع الحالات المختلفة باستخدام Mock Data
- تأكد من أن UI يتعامل مع جميع حالات الطلبات

### 3. قبل Production
- تأكد من تغيير `useMockData = false`
- اختبر Integration مع API الحقيقي

## إضافة بيانات وهمية جديدة

لإضافة طلبات وهمية جديدة، عدّل الملف:
`lib/features/orders/data/mock/mock_orders_data.dart`

```dart
static List<OrderModel> get mockOrders => [
  OrderModel(
    id: '9',
    orderNumber: 'ORD-2024-009',
    status: OrderStatus.pending,
    // ... باقي البيانات
  ),
  // أضف المزيد من الطلبات هنا
];
```

## استكشاف الأخطاء

### المشكلة: لا تظهر البيانات الوهمية
**الحل:**
1. تأكد من أن `AppConfig.useMockData = true`
2. أعد تشغيل التطبيق بالكامل (Hot Restart)

### المشكلة: التغييرات لا تستمر
**الحل:**
- هذا سلوك طبيعي! البيانات الوهمية تُعاد تعيينها عند إعادة تشغيل التطبيق

### المشكلة: أريد بيانات مختلفة
**الحل:**
- عدّل الملف `mock_orders_data.dart` وأضف/عدّل البيانات حسب احتياجك

## ملاحظات مهمة

1. ⚠️ **لا تنسَ**: تغيير `useMockData` إلى `false` قبل رفع التطبيق للـ Production

2. ✅ **مرونة**: يمكنك استخدام Mock Data لميزات معينة وReal Data لميزات أخرى

3. 🔄 **التبديل السريع**: يمكنك التبديل بين Mock و Real بتغيير قيمة واحدة فقط

4. 📱 **لا حاجة للإنترنت**: عند استخدام Mock Data، لا تحتاج لاتصال بالإنترنت

## الدعم

في حال وجود مشاكل أو أسئلة، راجع:
- `lib/core/constants/app_config.dart` - ملف الإعدادات
- `lib/core/di/locator_providers.dart` - Dependency Injection
- `lib/features/orders/data/mock/` - البيانات الوهمية

---

**تم إنشاؤه:** أكتوبر 2024
**النسخة:** 1.0.0

