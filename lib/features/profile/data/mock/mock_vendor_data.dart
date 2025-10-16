import '../models/vendor_model.dart';

/// بيانات تجريبية للمطعم
class MockVendorData {
  // جعل البيانات قابلة للتحديث
  static VendorModel _mockVendor = VendorModel(
    id: '1',
    restaurantName: 'مطعم جايك',
    supervisorName: 'أحمد محمد السعيد',
    email: 'info@jayeek-restaurant.com',
    phone: '+966501234567',
    logo:
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=400&fit=crop',
    coverImage:
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&h=600&fit=crop',
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

  // Getter للحصول على البيانات
  static VendorModel get mockVendor => _mockVendor;

  // دالة لتحديث ساعات العمل
  static void updateWorkingHours({
    required String openTime,
    required String closeTime,
    List<int>? workingDays,
  }) {
    _mockVendor = _mockVendor.copyWith(
      workingHours: WorkingHours(
        openTime: openTime,
        closeTime: closeTime,
        workingDays: workingDays ?? [1, 2, 3, 4, 5, 6, 7],
      ),
    );
  }

  // دالة لتحديث معلومات المطعم
  static void updateVendorInfo({
    String? restaurantName,
    String? supervisorName,
    String? email,
    String? phone,
    String? licenseNumber,
    String? address,
    String? city,
    String? logo,
    String? coverImage,
  }) {
    _mockVendor = _mockVendor.copyWith(
      restaurantName: restaurantName,
      supervisorName: supervisorName,
      email: email,
      phone: phone,
      licenseNumber: licenseNumber,
      address: address,
      city: city,
      logo: logo,
      coverImage: coverImage,
    );
  }

  // إعادة تعيين البيانات للقيم الافتراضية (للاختبار)
  static void reset() {
    _mockVendor = VendorModel(
      id: '1',
      restaurantName: 'مطعم جايك',
      supervisorName: 'أحمد محمد السعيد',
      email: 'info@jayeek-restaurant.com',
      phone: '+966501234567',
      logo:
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=400&fit=crop',
      coverImage:
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&h=600&fit=crop',
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
}
