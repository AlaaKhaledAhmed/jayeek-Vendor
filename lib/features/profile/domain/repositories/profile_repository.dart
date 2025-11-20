import '../../../../core/model/data_handel.dart';
import '../../data/models/vendor_model.dart';
import '../../data/models/wallet_model.dart';

/// Profile Repository Interface
abstract interface class ProfileRepository {
  /// الحصول على معلومات المطعم/البائع
  Future<PostDataHandle<VendorModel>> getVendorProfile();

  /// تحديث صورة الشعار (Logo/Profile Image)
  Future<PostDataHandle<VendorModel>> updateLogoImage({
    required String imageBase64,
  });

  /// تحديث صورة الخلفية (Cover Image)
  Future<PostDataHandle<VendorModel>> updateCoverImage({
    required String coverBase64,
  });

  /// الحصول على معلومات المحفظة
  Future<PostDataHandle<WalletModel>> getWallet();

  /// الحصول على سجل المعاملات
  Future<PostDataHandle<List<TransactionModel>>> getTransactions({
    TransactionType? type,
    TransactionStatus? status,
    int page = 1,
    int pageSize = 20,
  });

  /// طلب سحب
  Future<PostDataHandle<bool>> requestWithdrawal({
    required double amount,
    required String bankAccount,
  });

  /// تغيير كلمة المرور
  Future<PostDataHandle<bool>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  /// تحديث ساعات العمل
  Future<PostDataHandle<bool>> updateWorkingHours({
    required String openTime,
    required String closeTime,
    required List<int> workingDays,
  });

  /// تحديث حالة المطعم (مفتوح/مغلق)
  Future<PostDataHandle<bool>> toggleRestaurantStatus({
    required bool isActive,
  });
}
