// ignore_for_file: unused_local_variable

/// 📘 مثال توضيحي لاستخدام Mock Data
///
/// هذا الملف للتوضيح فقط - ليس جزءاً من التطبيق
/// يوضح كيفية استخدام نظام Mock Data في التطبيق

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/locator_providers.dart';
import '../models/order_model.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎯 مثال 1: جلب جميع الطلبات
/// ═══════════════════════════════════════════════════════════════════════════

Future<void> example1GetAllOrders(WidgetRef ref) async {
  // الحصول على Repository (سيكون Mock أو Real حسب AppConfig)
  final ordersRepo = ref.read(ordersDi);

  // جلب جميع الطلبات
  final result = await ordersRepo.getOrders();

  if (!result.hasError && result.data != null) {
    // نجح! عرض الطلبات
    final orders = result.data!;
    print('✅ تم جلب ${orders.length} طلبات');

    for (var order in orders) {
      print(
          '- ${order.orderNumber}: ${order.customerName} - ${order.total} ريال');
    }
  } else {
    // فشل
    print('❌ خطأ: ${result.message}');
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎯 مثال 2: تصفية الطلبات حسب الحالة
/// ═══════════════════════════════════════════════════════════════════════════

Future<void> example2FilterOrdersByStatus(WidgetRef ref) async {
  final ordersRepo = ref.read(ordersDi);

  // جلب الطلبات الجديدة فقط (Pending)
  final result = await ordersRepo.getOrders(
    status: OrderStatus.pending,
  );

  if (!result.hasError && result.data != null) {
    print('✅ الطلبات الجديدة: ${result.data!.length}');
  }

  // جلب الطلبات قيد التحضير
  final preparingResult = await ordersRepo.getOrders(
    status: OrderStatus.preparing,
  );

  if (!preparingResult.hasError && preparingResult.data != null) {
    print('✅ الطلبات قيد التحضير: ${preparingResult.data!.length}');
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎯 مثال 3: عرض تفاصيل طلب معين
/// ═══════════════════════════════════════════════════════════════════════════

Future<void> example3GetOrderDetails(WidgetRef ref, String orderId) async {
  final ordersRepo = ref.read(ordersDi);

  // جلب تفاصيل الطلب
  final result = await ordersRepo.getOrderDetails(orderId: orderId);

  if (!result.hasError && result.data != null) {
    final order = result.data!;

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📋 تفاصيل الطلب ${order.orderNumber}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('👤 العميل: ${order.customerName}');
    print('📞 الجوال: ${order.customerPhone}');
    print('📍 العنوان: ${order.customerAddress ?? 'غير محدد'}');
    print('💰 المجموع: ${order.total} ريال');
    print('📊 الحالة: ${order.status.arabicLabel}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    print('\n📦 المنتجات:');
    for (var item in order.items) {
      print('  • ${item.name} × ${item.quantity} - ${item.totalPrice} ريال');

      if (item.addons != null && item.addons!.isNotEmpty) {
        for (var addon in item.addons!) {
          print('    + ${addon.name} - ${addon.price} ريال');
        }
      }

      if (item.notes != null) {
        print('    📝 ملاحظة: ${item.notes}');
      }
    }
  } else {
    print('❌ خطأ: ${result.message}');
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎯 مثال 4: قبول طلب
/// ═══════════════════════════════════════════════════════════════════════════

Future<void> example4AcceptOrder(WidgetRef ref, String orderId) async {
  final ordersRepo = ref.read(ordersDi);

  // قبول الطلب مع تحديد وقت التحضير المتوقع (30 دقيقة)
  final result = await ordersRepo.acceptOrder(
    orderId: orderId,
    estimatedTime: 30, // بالدقائق
  );

  if (!result.hasError) {
    print('✅ تم قبول الطلب بنجاح');
    print('⏰ وقت التحضير المتوقع: 30 دقيقة');

    // الآن يمكن جلب تفاصيل الطلب المحدثة
    final updatedOrder = await ordersRepo.getOrderDetails(orderId: orderId);
    if (!updatedOrder.hasError && updatedOrder.data != null) {
      print('📊 الحالة الجديدة: ${updatedOrder.data!.status.arabicLabel}');
    }
  } else {
    print('❌ خطأ: ${result.message}');
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎯 مثال 5: رفض طلب
/// ═══════════════════════════════════════════════════════════════════════════

Future<void> example5RejectOrder(WidgetRef ref, String orderId) async {
  final ordersRepo = ref.read(ordersDi);

  // رفض الطلب مع ذكر السبب
  final result = await ordersRepo.rejectOrder(
    orderId: orderId,
    reason: 'المطعم مشغول حالياً ولا يمكن استقبال طلبات جديدة',
  );

  if (!result.hasError) {
    print('✅ تم رفض الطلب بنجاح');
    print('📝 تم إضافة سبب الرفض للطلب');
  } else {
    print('❌ خطأ: ${result.message}');
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎯 مثال 6: تحديث حالة الطلب
/// ═══════════════════════════════════════════════════════════════════════════

Future<void> example6UpdateOrderStatus(WidgetRef ref, String orderId) async {
  final ordersRepo = ref.read(ordersDi);

  // تحديث حالة الطلب إلى "قيد التحضير"
  final result = await ordersRepo.updateOrderStatus(
    orderId: orderId,
    newStatus: OrderStatus.preparing,
  );

  if (!result.hasError) {
    print('✅ تم تحديث حالة الطلب إلى: قيد التحضير');
  }

  // يمكن تحديثها إلى "جاهز"
  final readyResult = await ordersRepo.updateOrderStatus(
    orderId: orderId,
    newStatus: OrderStatus.ready,
  );

  if (!readyResult.hasError) {
    print('✅ تم تحديث حالة الطلب إلى: جاهز');
  }

  // ثم إلى "في الطريق"
  final onTheWayResult = await ordersRepo.updateOrderStatus(
    orderId: orderId,
    newStatus: OrderStatus.onTheWay,
  );

  if (!onTheWayResult.hasError) {
    print('✅ تم تحديث حالة الطلب إلى: في الطريق');
    print('✅ الطلب جاهز للتسليم للسائق');
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎯 مثال 7: Pagination (التصفح عبر الصفحات)
/// ═══════════════════════════════════════════════════════════════════════════

Future<void> example7Pagination(WidgetRef ref) async {
  final ordersRepo = ref.read(ordersDi);

  // الصفحة الأولى (أول 10 طلبات)
  final page1 = await ordersRepo.getOrders(page: 1);
  if (!page1.hasError) {
    print('📄 الصفحة 1: ${page1.data?.length ?? 0} طلبات');
  }

  // الصفحة الثانية (الـ 10 طلبات التالية)
  final page2 = await ordersRepo.getOrders(page: 2);
  if (!page2.hasError) {
    print('📄 الصفحة 2: ${page2.data?.length ?? 0} طلبات');
  }

  // يمكن الجمع بين الصفحات والتصفية
  final pendingPage1 = await ordersRepo.getOrders(
    status: OrderStatus.pending,
    page: 1,
  );

  if (!pendingPage1.hasError) {
    print('📄 الطلبات الجديدة - الصفحة 1: ${pendingPage1.data?.length ?? 0}');
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎯 مثال 8: سيناريو كامل لدورة حياة الطلب
/// ═══════════════════════════════════════════════════════════════════════════

Future<void> example8CompleteOrderLifecycle(WidgetRef ref) async {
  final ordersRepo = ref.read(ordersDi);
  const orderId = '1'; // طلب جديد

  print('\n🔄 دورة حياة الطلب الكاملة');
  print('═══════════════════════════════════════\n');

  // 1. جلب الطلب الجديد
  print('1️⃣ جلب الطلب...');
  var orderResult = await ordersRepo.getOrderDetails(orderId: orderId);
  if (!orderResult.hasError && orderResult.data != null) {
    print('   ✅ الحالة: ${orderResult.data!.status.arabicLabel}\n');
  }

  // 2. قبول الطلب
  print('2️⃣ قبول الطلب...');
  await Future.delayed(const Duration(seconds: 1));
  final acceptResult = await ordersRepo.acceptOrder(
    orderId: orderId,
    estimatedTime: 30,
  );
  if (!acceptResult.hasError) {
    print('   ✅ تم القبول\n');
  }

  // 3. بدء التحضير
  print('3️⃣ بدء التحضير...');
  await Future.delayed(const Duration(seconds: 1));
  final preparingResult = await ordersRepo.updateOrderStatus(
    orderId: orderId,
    newStatus: OrderStatus.preparing,
  );
  if (!preparingResult.hasError) {
    print('   ✅ الطلب قيد التحضير\n');
  }

  // 4. الطلب جاهز
  print('4️⃣ الطلب جاهز...');
  await Future.delayed(const Duration(seconds: 2));
  final readyResult = await ordersRepo.updateOrderStatus(
    orderId: orderId,
    newStatus: OrderStatus.ready,
  );
  if (!readyResult.hasError) {
    print('   ✅ الطلب جاهز للتوصيل\n');
  }

  // 5. في الطريق (تم تسليم الطلب للسائق)
  print('5️⃣ تسليم الطلب للسائق...');
  await Future.delayed(const Duration(seconds: 1));
  final onTheWayResult = await ordersRepo.updateOrderStatus(
    orderId: orderId,
    newStatus: OrderStatus.onTheWay,
  );
  if (!onTheWayResult.hasError) {
    print('   ✅ تم تسليم الطلب للسائق بنجاح\n');
  }

  // 6. الحالة النهائية
  print('6️⃣ الحالة النهائية:');
  orderResult = await ordersRepo.getOrderDetails(orderId: orderId);
  if (!orderResult.hasError && orderResult.data != null) {
    print('   📊 ${orderResult.data!.status.arabicLabel}');
    print('   ✅ تمت دورة الحياة الكاملة بنجاح!\n');
  }

  print('═══════════════════════════════════════\n');
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎯 ملاحظات مهمة
/// ═══════════════════════════════════════════════════════════════════════════
/// 
/// 1. 📱 جميع الأمثلة تعمل سواء كنت تستخدم Mock Data أو Real API
/// 
/// 2. 🔄 للتبديل بين Mock و Real، غيّر فقط في:
///    lib/core/constants/app_config.dart
///    static const bool useMockData = true; // أو false
/// 
/// 3. ⚡ Mock Data يحاكي تأخير الشبكة (300-500ms)
/// 
/// 4. 💾 التغييرات تبقى في الذاكرة خلال جلسة التطبيق الحالية فقط
/// 
/// 5. 🔧 يمكن تخصيص البيانات في:
///    lib/features/orders/data/mock/mock_orders_data.dart
/// 
/// 6. ✅ لا حاجة لتغيير أي كود آخر في التطبيق
/// 
/// ═══════════════════════════════════════════════════════════════════════════

