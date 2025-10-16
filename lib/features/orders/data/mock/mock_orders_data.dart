import '../models/order_model.dart';

/// Mock data for orders
class MockOrdersData {
  static List<OrderModel> get mockOrders => [
        OrderModel(
          id: '1',
          orderNumber: 'ORD-2024-001',
          status: OrderStatus.pending,
          customerName: 'أحمد محمد',
          customerPhone: '+966501234567',
          customerAddress: 'حي النزهة، شارع الملك فهد، جدة',
          items: [
            const OrderItemModel(
              id: '1',
              name: 'برجر لحم',
              image: 'https://via.placeholder.com/150',
              price: 35.0,
              quantity: 2,
              notes: 'بدون بصل',
              addons: [
                OrderAddonModel(name: 'جبن إضافي', price: 5.0),
                OrderAddonModel(name: 'بطاطس', price: 10.0),
              ],
            ),
            const OrderItemModel(
              id: '2',
              name: 'كولا',
              price: 8.0,
              quantity: 2,
            ),
          ],
          subtotal: 116.0,
          deliveryFee: 15.0,
          total: 131.0,
          notes: 'يرجى التوصيل في أسرع وقت',
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          branchName: 'فرع جدة الرئيسي',
          paymentMethod: 'نقدي',
          isPaid: false,
        ),
        OrderModel(
          id: '2',
          orderNumber: 'ORD-2024-002',
          status: OrderStatus.confirmed,
          customerName: 'سارة خالد',
          customerPhone: '+966502345678',
          customerAddress: 'حي الروضة، شارع التحلية، الرياض',
          items: [
            const OrderItemModel(
              id: '3',
              name: 'بيتزا مارجريتا',
              image: 'https://via.placeholder.com/150',
              price: 45.0,
              quantity: 1,
              addons: [
                OrderAddonModel(name: 'مشروم إضافي', price: 8.0),
              ],
            ),
            const OrderItemModel(
              id: '4',
              name: 'سلطة سيزر',
              price: 25.0,
              quantity: 1,
            ),
            const OrderItemModel(
              id: '5',
              name: 'عصير برتقال طازج',
              price: 12.0,
              quantity: 2,
            ),
          ],
          subtotal: 102.0,
          deliveryFee: 20.0,
          total: 122.0,
          createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
          estimatedDeliveryTime:
              DateTime.now().add(const Duration(minutes: 30)),
          branchName: 'فرع الرياض الشمالي',
          paymentMethod: 'بطاقة ائتمان',
          isPaid: true,
        ),
        OrderModel(
          id: '3',
          orderNumber: 'ORD-2024-003',
          status: OrderStatus.preparing,
          customerName: 'محمد عبدالله',
          customerPhone: '+966503456789',
          customerAddress: 'حي السلامة، شارع الأمير سلطان، جدة',
          items: [
            const OrderItemModel(
              id: '6',
              name: 'شاورما دجاج',
              image: 'https://via.placeholder.com/150',
              price: 18.0,
              quantity: 3,
              addons: [
                OrderAddonModel(name: 'ثوم إضافي', price: 2.0),
              ],
            ),
            const OrderItemModel(
              id: '7',
              name: 'فطيرة جبن',
              price: 15.0,
              quantity: 2,
            ),
          ],
          subtotal: 90.0,
          deliveryFee: 12.0,
          total: 102.0,
          notes: 'عدم إضافة مخلل',
          createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
          estimatedDeliveryTime:
              DateTime.now().add(const Duration(minutes: 20)),
          branchName: 'فرع جدة الرئيسي',
          paymentMethod: 'نقدي',
          isPaid: false,
        ),
        OrderModel(
          id: '4',
          orderNumber: 'ORD-2024-004',
          status: OrderStatus.ready,
          customerName: 'فاطمة أحمد',
          customerPhone: '+966504567890',
          customerAddress: 'حي الملقا، شارع العليا، الرياض',
          items: [
            const OrderItemModel(
              id: '8',
              name: 'مندي لحم',
              image: 'https://via.placeholder.com/150',
              price: 65.0,
              quantity: 1,
            ),
            const OrderItemModel(
              id: '9',
              name: 'سلطة يوناني',
              price: 20.0,
              quantity: 1,
            ),
            const OrderItemModel(
              id: '10',
              name: 'ماء معدني',
              price: 5.0,
              quantity: 2,
            ),
          ],
          subtotal: 95.0,
          deliveryFee: 18.0,
          total: 113.0,
          createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
          estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 5)),
          branchName: 'فرع الرياض الشرقي',
          paymentMethod: 'بطاقة مدى',
          isPaid: true,
        ),
        OrderModel(
          id: '5',
          orderNumber: 'ORD-2024-005',
          status: OrderStatus.onTheWay,
          customerName: 'خالد سعيد',
          customerPhone: '+966505678901',
          customerAddress: 'حي الحمراء، شارع فلسطين، جدة',
          items: [
            const OrderItemModel(
              id: '11',
              name: 'دجاج مشوي',
              image: 'https://via.placeholder.com/150',
              price: 42.0,
              quantity: 1,
              addons: [
                OrderAddonModel(name: 'أرز إضافي', price: 8.0),
              ],
            ),
            const OrderItemModel(
              id: '12',
              name: 'حمص',
              price: 12.0,
              quantity: 1,
            ),
            const OrderItemModel(
              id: '13',
              name: 'بيبسي',
              price: 7.0,
              quantity: 2,
            ),
          ],
          subtotal: 76.0,
          deliveryFee: 15.0,
          total: 91.0,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          estimatedDeliveryTime:
              DateTime.now().add(const Duration(minutes: 10)),
          branchName: 'فرع جدة الجنوبي',
          paymentMethod: 'نقدي',
          isPaid: false,
        ),
        OrderModel(
          id: '6',
          orderNumber: 'ORD-2024-006',
          status: OrderStatus.delivered,
          customerName: 'عبدالرحمن يوسف',
          customerPhone: '+966506789012',
          customerAddress: 'حي النرجس، طريق الملك عبدالله، الرياض',
          items: [
            const OrderItemModel(
              id: '14',
              name: 'برجر دجاج',
              image: 'https://via.placeholder.com/150',
              price: 28.0,
              quantity: 2,
            ),
            const OrderItemModel(
              id: '15',
              name: 'بطاطس مقلية',
              price: 15.0,
              quantity: 2,
            ),
            const OrderItemModel(
              id: '16',
              name: 'ميرندا',
              price: 6.0,
              quantity: 2,
            ),
          ],
          subtotal: 98.0,
          deliveryFee: 15.0,
          total: 113.0,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          estimatedDeliveryTime:
              DateTime.now().subtract(const Duration(minutes: 30)),
          branchName: 'فرع الرياض الشمالي',
          paymentMethod: 'بطاقة ائتمان',
          isPaid: true,
        ),
        OrderModel(
          id: '7',
          orderNumber: 'ORD-2024-007',
          status: OrderStatus.cancelled,
          customerName: 'نورة علي',
          customerPhone: '+966507890123',
          customerAddress: 'حي الزهراء، شارع المدينة، جدة',
          items: [
            const OrderItemModel(
              id: '17',
              name: 'معكرونة ألفريدو',
              image: 'https://via.placeholder.com/150',
              price: 38.0,
              quantity: 1,
            ),
            const OrderItemModel(
              id: '18',
              name: 'خبز بالثوم',
              price: 10.0,
              quantity: 2,
            ),
          ],
          subtotal: 58.0,
          deliveryFee: 15.0,
          total: 73.0,
          notes: 'تم الإلغاء من قبل العميل',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          branchName: 'فرع جدة الرئيسي',
          paymentMethod: 'نقدي',
          isPaid: false,
        ),
        OrderModel(
          id: '8',
          orderNumber: 'ORD-2024-008',
          status: OrderStatus.pending,
          customerName: 'ياسر حسن',
          customerPhone: '+966508901234',
          customerAddress: 'حي اليرموك، شارع الأمير محمد، الرياض',
          items: [
            const OrderItemModel(
              id: '19',
              name: 'كبسة دجاج',
              image: 'https://via.placeholder.com/150',
              price: 55.0,
              quantity: 1,
            ),
            const OrderItemModel(
              id: '20',
              name: 'سلطة فتوش',
              price: 18.0,
              quantity: 1,
            ),
            const OrderItemModel(
              id: '21',
              name: 'لبن',
              price: 8.0,
              quantity: 2,
            ),
          ],
          subtotal: 89.0,
          deliveryFee: 18.0,
          total: 107.0,
          notes: 'يرجى إضافة ملاعق وشوك',
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          branchName: 'فرع الرياض الغربي',
          paymentMethod: 'بطاقة مدى',
          isPaid: true,
        ),
      ];

  /// Get order by ID
  static OrderModel? getOrderById(String id) {
    try {
      return mockOrders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get orders by status
  static List<OrderModel> getOrdersByStatus(OrderStatus status) {
    return mockOrders.where((order) => order.status == status).toList();
  }

  /// Get paginated orders
  static List<OrderModel> getPaginatedOrders({
    int page = 1,
    int pageSize = 10,
    OrderStatus? status,
  }) {
    var filteredOrders = status != null
        ? mockOrders.where((order) => order.status == status).toList()
        : mockOrders;

    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= filteredOrders.length) {
      return [];
    }

    return filteredOrders.sublist(
      startIndex,
      endIndex > filteredOrders.length ? filteredOrders.length : endIndex,
    );
  }
}
