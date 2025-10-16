# 💰 Wallet Module - وحدة المحفظة

## 📋 نظرة عامة

نظام محفظة احترافي وشامل لإدارة الأموال وسجل المعاملات المالية للمطعم، مع تصميم عصري وسهل الاستخدام.

---

## 🎯 المميزات الرئيسية

✅ **عرض الرصيد المباشر** - الرصيد المتاح والمعلق  
✅ **إحصائيات شاملة** - إجمالي الإيرادات والمسحوبات  
✅ **سجل كامل للمعاملات** - جميع العمليات المالية  
✅ **تصنيف ذكي** - فلترة حسب النوع والحالة  
✅ **طلبات السحب** - سحب الأموال بسهولة  
✅ **تصميم عصري** - واجهة جذابة واحترافية  
✅ **Mock Data** - بيانات تجريبية للاختبار  

---

## 🏗️ البنية المعمارية

```
lib/features/profile/
├── data/
│   ├── models/
│   │   └── wallet_model.dart          # نماذج المحفظة والمعاملات
│   └── mock/
│       └── mock_wallet_data.dart      # بيانات تجريبية
├── presentation/
│   ├── screens/
│   │   └── wallet_screen.dart         # الشاشة الرئيسية
│   └── widgets/
│       └── wallet/
│           ├── wallet_balance_card.dart    # بطاقة الرصيد
│           └── transaction_card.dart       # بطاقة المعاملة
├── domain/
│   └── repositories/
│       └── profile_repository.dart    # واجهة المحفظة
└── data/
    └── repositories_impl/
        └── mock_profile_repository_impl.dart  # التطبيق التجريبي
```

---

## 📊 نماذج البيانات

### WalletModel
```dart
class WalletModel {
  final String id;
  final String vendorId;
  final double balance;              // الرصيد المتاح
  final double totalEarnings;        // إجمالي الإيرادات
  final double totalWithdrawals;     // إجمالي المسحوبات
  final double pendingAmount;        // قيد المعالجة
  final String currency;             // العملة (SAR)
  final DateTime? lastUpdated;
}
```

### TransactionModel
```dart
class TransactionModel {
  final String id;
  final TransactionType type;        // نوع المعاملة
  final TransactionStatus status;    // الحالة
  final double amount;                // المبلغ
  final double? commissionAmount;     // العمولة
  final String? orderId;              // رقم الطلب
  final String? orderNumber;
  final String? reference;            // الرقم المرجعي
  final String? description;
  final DateTime createdAt;
  final DateTime? completedAt;
}
```

### TransactionType (أنواع المعاملات)
```dart
enum TransactionType {
  earning       // 📥 إيراد من طلب
  withdrawal    // 📤 سحب إلى حساب بنكي
  commission    // 💼 عمولة المنصة
  refund        // ↩️ استرجاع مبلغ
}
```

### TransactionStatus (حالات المعاملة)
```dart
enum TransactionStatus {
  pending       // ⏳ قيد المعالجة
  completed     // ✅ مكتمل
  failed        // ❌ فشل
  cancelled     // 🚫 ملغي
}
```

---

## 🎨 المكونات الرئيسية

### 1. WalletBalanceCard
بطاقة عرض الرصيد مع:
- تدرج لوني جذاب
- الرصيد المتاح بخط كبير
- إحصائيات (الإيرادات، المسحوبات)
- المبلغ قيد المعالجة
- تنسيق المبالغ بفواصل

### 2. TransactionCard
بطاقة عرض معاملة واحدة مع:
- أيقونة ملونة حسب النوع
- المبلغ (+ للإيرادات، - للمصروفات)
- حالة المعاملة
- رقم الطلب (إن وجد)
- التاريخ بصيغة ذكية
- العمولة (إن وجدت)

### 3. WalletScreen
الشاشة الرئيسية مع:
- بطاقة الرصيد
- زر طلب سحب
- 4 تبويبات للفلترة
- قائمة المعاملات
- تفاصيل المعاملة

---

## 📱 واجهة المستخدم

### التبويبات
1. **كل العمليات** - جميع المعاملات
2. **الإيرادات** - الإيرادات من الطلبات فقط
3. **المسحوبات** - عمليات السحب
4. **العمولات** - العمولات والاستر جاعات

### ألوان النوع
| النوع | اللون | الأيقونة |
|------|-------|---------|
| إيراد | 🟢 أخضر | ⬇️ |
| سحب | 🔵 أزرق | ⬆️ |
| عمولة | 🟡 كهرماني | % |
| استرجاع | 🔴 أحمر | ↩️ |

### ألوان الحالة
| الحالة | اللون |
|--------|-------|
| مكتمل | 🟢 أخضر |
| قيد المعالجة | 🟡 كهرماني |
| فشل | 🔴 أحمر |
| ملغي | ⚫ رمادي |

---

## 🔧 الاستخدام

### فتح المحفظة
```dart
AppRoutes.pushTo(context, const WalletScreen());
```

### البيانات التجريبية
```dart
final wallet = MockWalletData.mockWallet;
final transactions = MockWalletData.mockTransactions;
```

### فلترة المعاملات
```dart
// حسب النوع
final earnings = MockWalletData.getTransactionsByType(
  TransactionType.earning
);

// حسب الحالة
final completed = MockWalletData.getTransactionsByStatus(
  TransactionStatus.completed
);
```

---

## 💼 Repository Pattern

### الواجهة
```dart
abstract interface class ProfileRepository {
  Future<PostDataHandle<WalletModel>> getWallet();
  
  Future<PostDataHandle<List<TransactionModel>>> getTransactions({
    TransactionType? type,
    TransactionStatus? status,
    int page = 1,
  });
  
  Future<PostDataHandle<bool>> requestWithdrawal({
    required double amount,
    required String bankAccount,
  });
}
```

### التطبيق التجريبي
```dart
class MockProfileRepositoryImpl implements ProfileRepository {
  // محاكاة جميع العمليات مع تأخير واقعي
  // دعم Pagination
  // معالجة الأخطاء
}
```

---

## 📊 البيانات التجريبية

### المحفظة
- **الرصيد**: 45,680.50 ريال
- **إجمالي الإيرادات**: 156,789.50 ريال
- **إجمالي المسحوبات**: 111,109.00 ريال
- **قيد المعالجة**: 3,250.00 ريال

### المعاملات
- 10 معاملات متنوعة
- إيرادات من طلبات حقيقية
- سحوبات مكتملة وقيد المعالجة
- عمولات واسترجاعات

---

## ✨ المميزات المتقدمة

### 1. طلب السحب
- Dialog أنيق للإدخال
- التحقق من الرصيد المتاح
- إدخال رقم الحساب البنكي
- إشعار نجاح

### 2. تفاصيل المعاملة
- Bottom Sheet احترافي
- جميع تفاصيل المعاملة
- تنسيق جميل للبيانات

### 3. تنسيق المبالغ
- فواصل للآلاف (45,680.50)
- عرض العملة
- علامة + للإيرادات

### 4. التاريخ الذكي
- "منذ X دقيقة/ساعة/يوم"
- تاريخ كامل للعمليات القديمة

---

## 🔄 دورة حياة المعاملة

```
إيراد من طلب:
قيد المعالجة → مكتمل (بعد توصيل الطلب)

سحب:
قيد المعالجة → مكتمل (بعد التحويل البنكي)

عمولة:
مكتمل (مباشرة)

استرجاع:
مكتمل (عند إلغاء طلب)
```

---

## 📈 الإحصائيات

### في بطاقة الرصيد
- إجمالي الإيرادات
- إجمالي المسحوبات
- المبلغ قيد المعالجة (إذا وجد)

### حسابات تلقائية
```dart
الرصيد = الإيرادات - المسحوبات - العمولات + الاسترجاعات
```

---

## 🚀 التطويرات المستقبلية

- [ ] إضافة Charts للإحصائيات
- [ ] تقارير شهرية/سنوية
- [ ] تصدير PDF للمعاملات
- [ ] ربط مع بوابات الدفع
- [ ] إشعارات push للمعاملات
- [ ] فلترة متقدمة (تاريخ محدد)
- [ ] البحث في المعاملات
- [ ] طباعة كشف الحساب

---

## 🎯 أمثلة الاستخدام

### عرض المحفظة
```dart
ProfileActionTile(
  icon: Icons.account_balance_wallet_rounded,
  title: AppMessage.wallet,
  subtitle: 'عرض الرصيد وسجل المعاملات',
  onTap: () {
    AppRoutes.pushTo(context, const WalletScreen());
  },
  iconColor: AppColor.green,
)
```

### طلب سحب
```dart
Future<PostDataHandle<bool>> requestWithdrawal({
  required double amount,
  required String bankAccount,
});
```

---

## 📝 ملاحظات

### العمولة
- يتم خصم 10% عمولة من كل طلب
- العمولة تظهر في تفاصيل المعاملة

### السحب
- الحد الأدنى: لم يتم تحديده (يمكن إضافته)
- الحد الأقصى: الرصيد المتاح
- وقت المعالجة: 1-3 أيام عمل

### الأمان
- جميع المبالغ بصيغة double
- التحقق من الرصيد قبل السحب
- معالجة الأخطاء بشكل صحيح

---

## 🎨 التصميم

### الألوان
- بطاقة الرصيد: تدرج من الأزرق الداكن
- الإيرادات: أخضر
- المصروفات: أحمر
- قيد المعالجة: كهرماني

### الخطوط
- العناوين: Bold
- المبالغ: Bold كبير
- التفاصيل: Regular صغير

---

تم التصميم والتطوير بعناية فائقة ✨

