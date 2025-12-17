# إصلاح مشكلة قاعدة البيانات على الويب

## المشكلة:
عند تشغيل التطبيق على الويب، ظهر خطأ:
```
DartError: Bad state: databaseFactory not initialized
databaseFactory is only initialized when using sqflite. When using `sqflite_common_ffi`
You must call `databaseFactory = databaseFactoryFfi;` before using global openDatabase API
```

## الحل:
تم إضافة دعم sqflite_common_ffi للعمل مع الويب:

### 1. في `pubspec.yaml`:
تم إضافة:
```yaml
sqflite_common_ffi: ^2.3.0
```

### 2. في `lib/services/database_service.dart`:
تم إضافة:
- Import للـ sqflite_common_ffi
- Import للـ kIsWeb من flutter/foundation
- تهيئة FFI loader للـ web و desktop platforms:
```dart
if (Platform.isWindows || Platform.isLinux || Platform.isMacOS || kIsWeb) {
  // Initialize FFI loader
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

## خطوات التشغيل:

### 1. تحديث dependencies:
```bash
flutter pub get
```

### 2. تشغيل التطبيق:
```bash
flutter run
```

## النتيجة:
التطبيق يجب أن يعمل الآن بدون مشاكل على المتصفح والمحمول!