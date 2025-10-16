# 📋 دليل إعداد Mock Data - تطبيق المطاعم

## 🎯 نظرة عامة

تم إضافة نظام **Mock Data** متكامل للتطبيق يسمح بالعمل والتطوير دون الحاجة لـ API حقيقي.

### ✅ الملفات المضافة

```
lib/
├── core/
│   └── constants/
│       └── app_config.dart                    # ملف التحكم الرئيسي
├── features/
│   └── orders/
│       ├── data/
│       │   ├── mock/
│       │   │   └── mock_orders_data.dart      # البيانات الوهمية (8 طلبات)
│       │   └── repositories_impl/
│       │       ├── orders_repository_impl.dart          # للبيانات الحقيقية
│       │       └── mock_orders_repository_impl.dart     # للبيانات الوهمية
│       └── MOCK_DATA_GUIDE.md                 # دليل مفصل للطلبات
└── MOCK_DATA_SETUP.md                         # هذا الملف
```

---

## 🔧 كيفية الاستخدام

### 1️⃣ تفعيل Mock Data (للتطوير)

افتح الملف: **`lib/core/constants/app_config.dart`**

```dart
class AppConfig {
  static const bool useMockData = true;  // ✅ استخدام البيانات الوهمية
}
```

✅ **المميزات:**
- لا حاجة للإنترنت
- لا حاجة لـ Backend
- بيانات جاهزة للعرض فوراً
- يمكن التعديل عليها بحرية

### 2️⃣ تفعيل البيانات الحقيقية (Production)

افتح الملف: **`lib/core/constants/app_config.dart`**

```dart
class AppConfig {
  static const bool useMockData = false;  // ✅ استخدام API الحقيقي
}
```

⚠️ **مهم:** تأكد من تغيير هذا القيمة إلى `false` قبل رفع التطبيق للـ App Store/Play Store

---

## 📊 البيانات المتوفرة

### الطلبات (Orders)

تم إنشاء **8 طلبات** تغطي جميع الحالات:

| رقم الطلب | الحالة | العميل | المبلغ |
|-----------|--------|---------|--------|
| ORD-2024-001 | جديد (Pending) | أحمد محمد | 131 ريال |
| ORD-2024-002 | مؤكد (Confirmed) | سارة خالد | 122 ريال |
| ORD-2024-003 | قيد التحضير (Preparing) | محمد عبدالله | 102 ريال |
| ORD-2024-004 | جاهز (Ready) | فاطمة أحمد | 113 ريال |
| ORD-2024-005 | في الطريق (On The Way) | خالد سعيد | 91 ريال |
| ORD-2024-006 | تم التوصيل (Delivered) | عبدالرحمن يوسف | 113 ريال |
| ORD-2024-007 | ملغي (Cancelled) | نورة علي | 73 ريال |
| ORD-2024-008 | جديد (Pending) | ياسر حسن | 107 ريال |

---

## 🔄 العمليات المدعومة

### ✅ جميع العمليات تعمل كما هو متوقع:

1. **عرض جميع الطلبات** - `getOrders()`
2. **تصفية حسب الحالة** - `getOrders(status: OrderStatus.pending)`
3. **عرض تفاصيل الطلب** - `getOrderDetails(orderId: '1')`
4. **تحديث حالة الطلب** - `updateOrderStatus(orderId: '1', newStatus: ...)`
5. **قبول الطلب** - `acceptOrder(orderId: '1', estimatedTime: 30)`
6. **رفض الطلب** - `rejectOrder(orderId: '1', reason: '...')`

---

## 🎨 مثال عملي

```dart
// في أي مكان بالتطبيق، استخدم Repository كالمعتاد
final ordersRepo = ref.read(ordersDi);

// عرض الطلبات الجديدة
final result = await ordersRepo.getOrders(
  status: OrderStatus.pending,
);

if (!result.hasError) {
  // عرض الطلبات
  print('عدد الطلبات: ${result.data?.length}');
}

// قبول طلب
final acceptResult = await ordersRepo.acceptOrder(
  orderId: '1',
  estimatedTime: 30,
);

if (!acceptResult.hasError) {
  // تم القبول بنجاح
  print('تم قبول الطلب');
}
```

---

## 🛠️ التخصيص

### إضافة/تعديل بيانات وهمية

افتح: **`lib/features/orders/data/mock/mock_orders_data.dart`**

```dart
static List<OrderModel> get mockOrders => [
  // أضف طلبات جديدة هنا
  OrderModel(
    id: '9',
    orderNumber: 'ORD-2024-009',
    status: OrderStatus.pending,
    customerName: 'اسم العميل',
    customerPhone: '+966xxxxxxxxx',
    // ... باقي البيانات
  ),
];
```

### دوال مساعدة إضافية

```dart
// في MockOrdersRepositoryImpl

// إعادة تعيين البيانات
mockRepo.resetOrders();

// إضافة طلب جديد
mockRepo.addOrder(newOrder);

// حذف طلب
mockRepo.removeOrder('order-id');
```

---

## 🎭 ميزات Mock Repository

### 1. محاكاة تأخير الشبكة
```dart
await Future.delayed(const Duration(milliseconds: 500));
```
يحاكي تأخير الاستجابة من API الحقيقي.

### 2. إدارة الحالة
جميع التغييرات تُحفظ في الذاكرة خلال جلسة التطبيق.

### 3. Pagination
يدعم التصفح عبر الصفحات (10 طلبات لكل صفحة).

### 4. رسائل خطأ واقعية
```dart
return PostDataHandle<OrderModel>(
  data: null,
  hasError: true,
  message: 'لم يتم العثور على الطلب',
);
```

---

## 📱 سيناريوهات الاستخدام

### 1. التطوير المحلي
```dart
static const bool useMockData = true;  // ✅ سريع وسهل
```

### 2. اختبار UI
```dart
// استخدم Mock Data لاختبار جميع الحالات
// دون الحاجة لإنشاء بيانات حقيقية
```

### 3. Demo/Presentation
```dart
// عرض التطبيق بدون اتصال بالإنترنت
// بيانات جاهزة واحترافية
```

### 4. Production
```dart
static const bool useMockData = false;  // ⚠️ استخدام API الحقيقي
```

---

## ⚙️ كيف يعمل النظام؟

### في `locator_providers.dart`:

```dart
final ordersDi = Provider<OrdersRepository>(
  (ref) {
    if (AppConfig.useMockData) {
      // 🎭 Mock Data
      return MockOrdersRepositoryImpl();
    } else {
      // 🌐 Real API
      return OrdersRepositoryImpl(
        networkService: ref.read(networkServicesDi)
      );
    }
  },
);
```

### التبديل التلقائي:
- التطبيق يقرأ قيمة `AppConfig.useMockData`
- يقرر تلقائياً أي Repository يستخدم
- **لا حاجة لتغيير كود آخر في المشروع!**

---

## ✅ قائمة التحقق قبل Production

- [ ] تغيير `AppConfig.useMockData` إلى `false`
- [ ] اختبار Integration مع API الحقيقي
- [ ] التأكد من جميع endpoints تعمل
- [ ] التأكد من التعامل مع الأخطاء
- [ ] اختبار على أجهزة حقيقية

---

## 🐛 استكشاف الأخطاء

### المشكلة: لا تظهر البيانات
**الحل:**
```dart
// تأكد من:
AppConfig.useMockData = true  // ✅

// أعد تشغيل التطبيق
// Hot Restart (⌘ + Shift + \ on Mac)
```

### المشكلة: التغييرات لا تستمر
**الحل:**
```
هذا سلوك طبيعي! 
البيانات الوهمية تُعاد عند إعادة تشغيل التطبيق.
```

### المشكلة: أريد mock data لميزة أخرى
**الحل:**
```
اتبع نفس النمط:
1. أنشئ mock_[feature]_data.dart
2. أنشئ mock_[feature]_repository_impl.dart
3. عدّل في locator_providers.dart
```

---

## 📚 موارد إضافية

- **دليل الطلبات المفصل:** `lib/features/orders/MOCK_DATA_GUIDE.md`
- **ملف الإعدادات:** `lib/core/constants/app_config.dart`
- **البيانات الوهمية:** `lib/features/orders/data/mock/mock_orders_data.dart`
- **Mock Repository:** `lib/features/orders/data/repositories_impl/mock_orders_repository_impl.dart`

---

## 💡 نصائح مهمة

1. **استخدم Mock Data في المراحل الأولى** من التطوير
2. **اختبر جميع الحالات** باستخدام البيانات الوهمية
3. **تأكد من التبديل إلى Real Data** قبل Production
4. **أضف المزيد من البيانات** حسب احتياجك
5. **استخدم نفس النمط** لميزات أخرى

---

## 📞 الدعم

في حال وجود مشاكل:
1. راجع `app_config.dart` - تأكد من القيمة الصحيحة
2. راجع `locator_providers.dart` - تأكد من التكامل
3. راجع ملفات Mock Data - تأكد من البيانات

---

## 🎉 جاهز للاستخدام!

الآن يمكنك:
- ✅ تشغيل التطبيق بدون Backend
- ✅ التطوير بسرعة وسهولة
- ✅ اختبار جميع السيناريوهات
- ✅ التبديل بسهولة للبيانات الحقيقية

**Happy Coding! 🚀**

---

*تم الإنشاء في: أكتوبر 2024*  
*الإصدار: 1.0.0*

