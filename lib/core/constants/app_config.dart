/// App Configuration
/// يحتوي على إعدادات التطبيق الأساسية
class AppConfig {
  /// Use mock data instead of real API
  /// قم بتغيير هذا إلى true لاستخدام البيانات الوهمية (Mock Data)
  /// قم بتغيير هذا إلى false لاستخدام البيانات الحقيقية من الـ API
  static const bool useMockData = true;

  /// Enable debug mode
  /// تفعيل وضع التصحيح
  static const bool debugMode = true;

  /// API timeout in seconds
  /// مهلة الانتظار للـ API بالثواني
  static const int apiTimeout = 30;

  /// Enable logging
  /// تفعيل السجلات
  static const bool enableLogging = true;

  /// App version
  static const String appVersion = '1.0.0';

  /// Supported languages
  static const List<String> supportedLanguages = ['ar', 'en'];

  /// Default language
  static const String defaultLanguage = 'ar';

  /// Get current environment name
  static String get environment {
    if (useMockData) {
      return 'Mock Data (Development)';
    }
    return 'Production';
  }

  /// Check if app is in mock mode
  static bool get isMockMode => useMockData;

  /// Check if app is in production mode
  static bool get isProduction => !useMockData;
}
