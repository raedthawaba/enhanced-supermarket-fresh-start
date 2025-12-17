import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermarket_app/utils/constants.dart';

class LocaleService {
  static final LocaleService _instance = LocaleService._internal();
  factory LocaleService() => _instance;
  LocaleService._internal();

  static const List<Locale> supportedLocales = [
    Locale('ar', 'SA'),
    Locale('en', 'US'),
  ];

  Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString(AppConstants.localeKey);
    
    if (localeString != null) {
      final parts = localeString.split('_');
      if (parts.length == 2) {
        return Locale(parts[0], parts[1]);
      }
    }
    
    // Default to Arabic
    return const Locale('ar', 'SA');
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.localeKey, '${locale.languageCode}_${locale.countryCode}');
  }

  bool isRTL(Locale locale) {
    return locale.languageCode == 'ar';
  }

  String getLanguageCode(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return 'العربية';
    }
  }

  String getCurrencySymbol(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'ر.س';
      case 'en':
        return 'SAR';
      default:
        return 'ر.س';
    }
  }

  String formatCurrency(double amount, Locale locale) {
    final symbol = getCurrencySymbol(locale);
    return '${amount.toStringAsFixed(2)} $symbol';
  }

  String formatDate(DateTime date, Locale locale) {
    // Simple date formatting - in real app, use intl package
    if (isRTL(locale)) {
      return '${date.day}/${date.month}/${date.year}';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String formatTime(DateTime date, Locale locale) {
    // Simple time formatting - in real app, use intl package
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String formatDateTime(DateTime date, Locale locale) {
    return '${formatDate(date, locale)} ${formatTime(date, locale)}';
  }

  // Text direction
  TextDirection getTextDirection(Locale locale) {
    return isRTL(locale) ? TextDirection.rtl : TextDirection.ltr;
  }

  // Alignment based on locale
  Alignment getStartAlignment(Locale locale) {
    return isRTL(locale) ? Alignment.centerRight : Alignment.centerLeft;
  }

  Alignment getEndAlignment(Locale locale) {
    return isRTL(locale) ? Alignment.centerLeft : Alignment.centerRight;
  }

  // Icon mirroring for RTL
  bool shouldMirrorIcon(IconData icon, Locale locale) {
    if (!isRTL(locale)) return false;
    
    // Icons that should be mirrored in RTL
    final mirroredIcons = [
      Icons.arrow_back,
      Icons.arrow_forward,
      Icons.chevron_left,
      Icons.chevron_right,
      Icons.keyboard_arrow_left,
      Icons.keyboard_arrow_right,
      Icons.navigate_before,
      Icons.navigate_next,
      Icons.arrow_back_ios,
      Icons.arrow_forward_ios,
    ];
    
    return mirroredIcons.contains(icon);
  }

  // Currency formatting for different locales
  String formatPrice(double price, {Locale? locale, bool showSymbol = true}) {
    final effectiveLocale = locale ?? const Locale('ar', 'SA');
    final symbol = getCurrencySymbol(effectiveLocale);
    
    if (showSymbol) {
      return '${price.toStringAsFixed(2)} $symbol';
    } else {
      return price.toStringAsFixed(2);
    }
  }

  // Unit conversions and formatting
  String formatWeight(double weight, String unit, Locale locale) {
    if (isRTL(locale)) {
      return '$weight $unit';
    } else {
      return '$weight $unit';
    }
  }

  // Pluralization rules for Arabic
  String getPluralForm(int count, String singular, String plural, Locale locale) {
    if (locale.languageCode == 'ar') {
      if (count == 0) return 'لا يوجد $singular';
      if (count == 1) return '$singular واحد';
      if (count == 2) return '$singular اثنان';
      if (count <= 10) return '$count $plural';
      return '$count $singular';
    } else {
      return count == 1 ? singular : plural;
    }
  }
}