# 📦 Orders Feature - ميزة الطلبات

## 🏗️ بنية المجلد

```
orders/
├── data/                                  # طبقة البيانات (Data Layer)
│   ├── mock/                             # البيانات الوهمية
│   │   ├── mock_orders_data.dart         # 8 طلبات وهمية
│   │   └── mock_usage_example.dart       # أمثلة الاستخدام
│   ├── models/                           # نماذج البيانات
│   │   └── order_model.dart              # OrderModel, OrderItemModel, OrderStatus
│   └── repositories_impl/                # تطبيق Repositories
│       ├── orders_repository_impl.dart   # للبيانات الحقيقية (Real API)
│       └── mock_orders_repository_impl.dart  # للبيانات الوهمية (Mock Data)
├── domain/                               # طبقة المنطق (Domain Layer)
│   └── repositories/                     # Interfaces
│       └── orders_repository.dart        # OrdersRepository interface
├── providers/                            # Riverpod State Management
│   └── order_details/
│       ├── order_details_notifier.dart   # Business Logic
│       ├── order_details_provider.dart   # Provider
│       └── order_details_state.dart      # State Model
├── MOCK_DATA_GUIDE.md                    # 📚 دليل Mock Data
└── README.md                             # 📖 هذا الملف
```

---

## 🔄 تدفق البيانات (Data Flow)

```
┌─────────────┐
│     UI      │ (Widgets)
└──────┬──────┘
       │ استخدام Provider
       ▼
┌─────────────────┐
│   Providers     │ (OrderDetailsProvider)
│   + Notifiers   │ (OrderDetailsNotifier)
└──────┬──────────┘
       │ استدعاء Repository
       ▼
┌───────────────────────────────────┐
│      OrdersRepository             │ (Interface)
│                                   │
│  ┌─────────────┐  ┌─────────────┐│
│  │ Real Data   │  │  Mock Data  ││
│  │ (API)       │  │  (Memory)   ││
│  └─────────────┘  └─────────────┘│
└───────────────────────────────────┘
        │                 │
        ▼                 ▼
    🌐 API          💾 Mock Data
```

---

## ⚙️ التبديل بين Real و Mock

### في `lib/core/di/locator_providers.dart`:

```dart
final ordersDi = Provider<OrdersRepository>(
  (ref) {
    if (AppConfig.useMockData) {
      return MockOrdersRepositoryImpl();  // 🎭 Mock
    } else {
      return OrdersRepositoryImpl(...);   // 🌐 Real
    }
  },
);
```

### التحكم في `lib/core/constants/app_config.dart`:

```dart
static const bool useMockData = true;  // للتبديل
```

---

## 📊 نماذج البيانات (Data Models)

### OrderModel
```dart
class OrderModel {
  final String id;
  final String orderNumber;      // رقم الطلب
  final OrderStatus status;       // الحالة
  final String customerName;      // اسم العميل
  final String customerPhone;     // رقم الجوال
  final String? customerAddress;  // العنوان
  final List<OrderItemModel> items;  // المنتجات
  final double subtotal;          // المجموع الفرعي
  final double deliveryFee;       // رسوم التوصيل
  final double total;             // الإجمالي
  final DateTime createdAt;       // تاريخ الطلب
  // ... المزيد
}
```

### OrderStatus (Enum)
```dart
enum OrderStatus {
  pending        // 🔵 جديد
  confirmed      // 🟢 مؤكد
  preparing      // 🟡 قيد التحضير
  ready          // 🟠 جاهز
  onTheWay       // 🟣 في الطريق
  delivered      // ✅ تم التوصيل
  cancelled      // ❌ ملغي
}
```

---

## 🛠️ العمليات المتاحة

### 1. عرض جميع الطلبات
```dart
Future<PostDataHandle<List<OrderModel>>> getOrders({
  OrderStatus? status,  // اختياري: تصفية حسب الحالة
  int page = 1,         // رقم الصفحة (10 طلبات/صفحة)
});
```

### 2. عرض تفاصيل طلب
```dart
Future<PostDataHandle<OrderModel>> getOrderDetails({
  required String orderId,
});
```

### 3. تحديث حالة الطلب
```dart
Future<PostDataHandle<bool>> updateOrderStatus({
  required String orderId,
  required OrderStatus newStatus,
});
```

### 4. قبول الطلب
```dart
Future<PostDataHandle<bool>> acceptOrder({
  required String orderId,
  int? estimatedTime,  // بالدقائق
});
```

### 5. رفض الطلب
```dart
Future<PostDataHandle<bool>> rejectOrder({
  required String orderId,
  String? reason,
});
```

---

## 💡 أمثلة الاستخدام

### في Widget أو Provider:

```dart
// الحصول على Repository
final ordersRepo = ref.read(ordersDi);

// جلب الطلبات الجديدة
final result = await ordersRepo.getOrders(
  status: OrderStatus.pending,
);

if (!result.hasError && result.data != null) {
  // نجح
  final orders = result.data!;
  print('عدد الطلبات: ${orders.length}');
} else {
  // فشل
  print('خطأ: ${result.message}');
}
```

---

## 🎭 Mock Data

### البيانات المتوفرة
- ✅ 8 طلبات جاهزة
- ✅ جميع الحالات (Pending → Delivered)
- ✅ بيانات واقعية بالعربية
- ✅ أسماء وعناوين سعودية

### المميزات
- ⚡ لا حاجة للإنترنت
- 🔧 سهولة التعديل
- 🎨 مثالية للتطوير
- 🧪 رائعة للاختبار

### راجع:
📄 **MOCK_DATA_GUIDE.md** - دليل كامل

---

## 📱 State Management

### OrderDetailsProvider
```dart
final orderDetailsProvider = 
    StateNotifierProvider.autoDispose<OrderDetailsNotifier, OrderDetailsState>(
  (ref) {
    final repo = ref.read(ordersDi);
    return OrderDetailsNotifier(repo);
  },
);
```

### استخدام في Widget:
```dart
class OrderDetailsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderDetailsProvider);
    
    if (state.isLoading) {
      return LoadingWidget();
    }
    
    if (state.hasError) {
      return ErrorWidget(state.errorMessage);
    }
    
    return OrderDetailsView(order: state.order);
  }
}
```

---

## 🔗 الاعتماديات (Dependencies)

### من خارج Feature:
```dart
import 'package:jayeek_vendor/core/model/data_handel.dart';
import 'package:jayeek_vendor/core/services/network/inetwork_services.dart';
import 'package:jayeek_vendor/core/di/locator_providers.dart';
```

### داخل Feature:
```dart
// استخدام النماذج
import 'data/models/order_model.dart';

// استخدام Repository
import 'domain/repositories/orders_repository.dart';

// استخدام Provider
import 'providers/order_details/order_details_provider.dart';
```

---

## 🧪 الاختبار

### اختبار مع Mock Data
```dart
// 1. تفعيل Mock
AppConfig.useMockData = true;

// 2. اختبار جميع الحالات
// - الطلبات الجديدة
// - قبول الطلب
// - رفض الطلب
// - تحديث الحالة
// - Pagination

// 3. التحقق من UI
```

### اختبار مع Real API
```dart
// 1. تعطيل Mock
AppConfig.useMockData = false;

// 2. اختبار Integration
// 3. اختبار Error Handling
```

---

## 🎯 Best Practices

### 1. استخدام Repository دائماً
```dart
// ✅ صحيح
final repo = ref.read(ordersDi);
final result = await repo.getOrders();

// ❌ خطأ - لا تستدعي API مباشرة
```

### 2. التعامل مع الأخطاء
```dart
if (!result.hasError) {
  // نجح
} else {
  // فشل - اعرض رسالة
  showError(result.message);
}
```

### 3. استخدام Provider للـ State
```dart
// ✅ صحيح - State Management
final state = ref.watch(orderDetailsProvider);

// ❌ خطأ - State في Widget
```

---

## 📚 الملفات المرجعية

### للبدء
- 📄 **../../../QUICK_START.md** - البدء في 3 خطوات

### للتفاصيل
- 📄 **MOCK_DATA_GUIDE.md** - دليل Mock Data
- 📄 **data/mock/mock_usage_example.dart** - أمثلة

### للفهم الكامل
- 📄 **../../../MOCK_DATA_SETUP.md** - الدليل الشامل
- 📄 **../../../CHANGES_SUMMARY.md** - ملخص التغييرات

---

## 🚀 الخطوات التالية

### للمطورين الجدد
1. ✅ اقرأ QUICK_START.md
2. ✅ فعّل Mock Data
3. ✅ شغّل التطبيق
4. ✅ جرب الأمثلة

### للتطوير
1. ✅ استخدم Mock Data
2. ✅ طوّر UI
3. ✅ اختبر جميع الحالات
4. ✅ انتقل لـ Real Data

---

**🎉 استمتع بالتطوير!**
