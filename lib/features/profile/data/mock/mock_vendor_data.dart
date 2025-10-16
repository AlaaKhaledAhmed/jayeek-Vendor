import '../models/vendor_model.dart';

/// بيانات تجريبية للمطعم
class MockVendorData {
  static VendorModel get mockVendor => VendorModel(
        id: '1',
        restaurantName: 'مطعم جايك',
        supervisorName: 'أحمد محمد السعيد',
        email: 'info@jayeek-restaurant.com',
        phone: '+966501234567',
        logo: 'https://via.placeholder.com/200',
        licenseNumber: 'CR-2024-12345',
        address: 'شارع الملك فهد، حي النزهة',
        city: 'جدة',
        rating: 4.8,
        totalOrders: 1523,
        totalSales: 156789.50,
        isActive: true,
        createdAt: DateTime(2024, 1, 15),
        workingHours: const WorkingHours(
          openTime: '10:00',
          closeTime: '23:30',
          workingDays: [1, 2, 3, 4, 5, 6, 7],
        ),
      );
}
