import '../../../../core/model/data_handel.dart';
import '../../domain/repositories/profile_repository.dart';
import '../mock/mock_vendor_data.dart';
import '../mock/mock_wallet_data.dart';
import '../models/vendor_model.dart';
import '../models/wallet_model.dart';

/// Mock Implementation للـ Profile Repository
class MockProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<PostDataHandle<VendorModel>> getVendorProfile() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final vendor = MockVendorData.mockVendor;
      return PostDataHandle<VendorModel>(
        hasError: false,
        data: vendor,
        message: 'تم تحميل البيانات بنجاح',
      );
    } catch (e) {
      return const PostDataHandle<VendorModel>(
        hasError: true,
        message: 'فشل في تحميل بيانات المطعم',
      );
    }
  }

  @override
  Future<PostDataHandle<bool>> updateVendorProfile({
    required String restaurantName,
    required String supervisorName,
    required String email,
    required String phone,
    String? licenseNumber,
    String? address,
    String? city,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      // في التطبيق الحقيقي، سيتم إرسال البيانات إلى API
      // هنا نقوم بمحاكاة النجاح فقط
      return const PostDataHandle<bool>(
        hasError: false,
        data: true,
        message: 'تم تحديث البيانات بنجاح',
      );
    } catch (e) {
      return const PostDataHandle<bool>(
        hasError: true,
        message: 'فشل في تحديث البيانات',
      );
    }
  }

  @override
  Future<PostDataHandle<String>> updateLogo({
    required String imagePath,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      // محاكاة رفع الصورة والحصول على رابط
      const logoUrl =
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=400&fit=crop';
      return const PostDataHandle<String>(
        hasError: false,
        data: logoUrl,
        message: 'تم رفع الصورة بنجاح',
      );
    } catch (e) {
      return const PostDataHandle<String>(
        hasError: true,
        message: 'فشل في رفع الصورة',
      );
    }
  }

  @override
  Future<PostDataHandle<WalletModel>> getWallet() async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final wallet = MockWalletData.mockWallet;
      return PostDataHandle<WalletModel>(
        hasError: false,
        data: wallet,
        message: 'تم تحميل بيانات المحفظة بنجاح',
      );
    } catch (e) {
      return const PostDataHandle<WalletModel>(
        hasError: true,
        message: 'فشل في تحميل بيانات المحفظة',
      );
    }
  }

  @override
  Future<PostDataHandle<List<TransactionModel>>> getTransactions({
    TransactionType? type,
    TransactionStatus? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      var transactions = MockWalletData.mockTransactions;

      // تصفية حسب النوع
      if (type != null) {
        transactions = transactions.where((txn) => txn.type == type).toList();
      }

      // تصفية حسب الحالة
      if (status != null) {
        transactions =
            transactions.where((txn) => txn.status == status).toList();
      }

      // Pagination
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      if (startIndex >= transactions.length) {
        return const PostDataHandle<List<TransactionModel>>(
          hasError: false,
          data: [],
          message: 'لا توجد معاملات أخرى',
        );
      }

      final paginatedTransactions = transactions.sublist(
        startIndex,
        endIndex > transactions.length ? transactions.length : endIndex,
      );

      return PostDataHandle<List<TransactionModel>>(
        hasError: false,
        data: paginatedTransactions,
        message: 'تم تحميل المعاملات بنجاح',
      );
    } catch (e) {
      return const PostDataHandle<List<TransactionModel>>(
        hasError: true,
        message: 'فشل في تحميل سجل المعاملات',
      );
    }
  }

  @override
  Future<PostDataHandle<bool>> requestWithdrawal({
    required double amount,
    required String bankAccount,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      // التحقق من الرصيد
      final wallet = MockWalletData.mockWallet;
      if (amount > wallet.balance) {
        return const PostDataHandle<bool>(
          hasError: true,
          message: 'الرصيد غير كافٍ',
        );
      }

      return const PostDataHandle<bool>(
        hasError: false,
        data: true,
        message: 'تم إرسال طلب السحب بنجاح',
      );
    } catch (e) {
      return const PostDataHandle<bool>(
        hasError: true,
        message: 'فشل في إرسال طلب السحب',
      );
    }
  }

  @override
  Future<PostDataHandle<bool>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      // في التطبيق الحقيقي، يتم التحقق من كلمة المرور القديمة
      return const PostDataHandle<bool>(
        hasError: false,
        data: true,
        message: 'تم تغيير كلمة المرور بنجاح',
      );
    } catch (e) {
      return const PostDataHandle<bool>(
        hasError: true,
        message: 'فشل في تغيير كلمة المرور',
      );
    }
  }

  @override
  Future<PostDataHandle<bool>> updateWorkingHours({
    required String openTime,
    required String closeTime,
    required List<int> workingDays,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      return const PostDataHandle<bool>(
        hasError: false,
        data: true,
        message: 'تم تحديث ساعات العمل بنجاح',
      );
    } catch (e) {
      return const PostDataHandle<bool>(
        hasError: true,
        message: 'فشل في تحديث ساعات العمل',
      );
    }
  }

  @override
  Future<PostDataHandle<bool>> toggleRestaurantStatus({
    required bool isActive,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      return const PostDataHandle<bool>(
        hasError: false,
        data: true,
        message: 'تم تحديث حالة المطعم بنجاح',
      );
    } catch (e) {
      return const PostDataHandle<bool>(
        hasError: true,
        message: 'فشل في تحديث حالة المطعم',
      );
    }
  }
}
