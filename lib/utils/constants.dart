class AppConstants {
  // App Info
  static const String appName = 'متجر السوبر ماركت';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'متجر إلكتروني متكامل للسوبر ماركت';
  
  // Colors
  static const int primaryColorValue = 0xFF4CAF50;
  static const int accentColorValue = 0xFF8BC34A;
  static const int errorColorValue = 0xFFF44336;
  static const int warningColorValue = 0xFFFF9800;
  static const int successColorValue = 0xFF4CAF50;
  
  // Categories
  static const List<String> categories = [
    'خضروات وفواكه',
    'لحوم ودواجن',
    'أسماك',
    'ألبان وأجبان',
    'خبز ومخبوزات',
    'مشروبات',
    'مكسرات',
    'تنظيف',
    'عناية شخصية',
    'أدوية',
    'أدوات منزلية',
    'أخرى'
  ];
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'نقدي عند الاستلام',
    'فيزا',
    'ماستر كارد',
    'أمريكان إكسبرس',
    'مدى',
    'STC Pay',
    'Apple Pay',
    'Google Pay',
    'PayPal'
  ];
  
  // Database
  static const String databaseName = 'supermarket.db';
  static const int databaseVersion = 1;
  
  // API Endpoints (for future Firebase integration)
  static const String baseUrl = 'https://api.supermarket.com';
  static const String productsEndpoint = '/products';
  static const String ordersEndpoint = '/orders';
  static const String usersEndpoint = '/users';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String cartKey = 'cart_data';
  static const String favoritesKey = 'favorites_data';
  static const String settingsKey = 'app_settings';
  static const String localeKey = 'locale';
  
  // Image Assets
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImage = 'assets/images/placeholder.png';
  static const String noImageAvailable = 'assets/images/no_image.png';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Text Styles
  static const double headingFontSize = 24.0;
  static const double subheadingFontSize = 20.0;
  static const double bodyFontSize = 16.0;
  static const double captionFontSize = 14.0;
  static const double smallFontSize = 12.0;
  
  // Spacing
  static const double tinySpacing = 4.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;
  
  // Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;
  
  // Card Heights
  static const double productCardHeight = 200.0;
  static const double categoryCardHeight = 120.0;
  static const double bannerHeight = 160.0;
  
  // Network Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxCartItems = 100;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxAddressLength = 200;
  
  // Notifications
  static const String notificationChannelId = 'supermarket_channel';
  static const String notificationChannelName = 'إشعارات السوبر ماركت';
  static const String notificationChannelDescription = 'إشعارات الطلبات والعروض';
  
  // Error Messages
  static const String networkError = 'خطأ في الاتصال بالإنترنت';
  static const String serverError = 'خطأ في الخادم';
  static const String unknownError = 'خطأ غير معروف';
  static const String validationError = 'يرجى التحقق من البيانات المدخلة';
  
  // Success Messages
  static const String orderPlacedSuccessfully = 'تم تقديم طلبك بنجاح';
  static const String profileUpdatedSuccessfully = 'تم تحديث الملف الشخصي بنجاح';
  static const String productAddedToCart = 'تم إضافة المنتج للسلة';
  static const String productRemovedFromCart = 'تم حذف المنتج من السلة';
}