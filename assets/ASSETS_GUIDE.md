# دليل الخطوط والأصول

## 📁 مجلدات الأصول المطلوبة

### الخط العربي (Cairo):
```
assets/fonts/
├── Cairo-Regular.ttf
└── Cairo-Bold.ttf
```

### الصور:
```
assets/images/
├── logo.png
├── placeholder.png
├── no_image.png
└── (أضف صور منتجات هنا)
```

## 📥 تحميل الخطوط

### طريقة 1: تحميل مباشر
قم بتحميل خطوط Cairo من Google Fonts:
- [Cairo Regular](https://fonts.google.com/specimen/Cairo)
- [Cairo Bold](https://fonts.google.com/specimen/Cairo)

### طريقة 2: استخدام الأوامر
```bash
# تحميل الخطوط (يتطلب wget)
wget -O assets/fonts/Cairo-Regular.ttf "https://fonts.gstatic.com/s/cairo/v34/SLV4dNaiFm8tUjJ8k5OQ.ttf"
wget -O assets/fonts/Cairo-Bold.ttf "https://fonts.gstatic.com/s/cairo/v34/SLV4dNaiFm8tUjJ8k5OQ.ttf"
```

### طريقة 3: استبدال خط بديل
إذا لم تتمكن من تحميل الخط، سيتم استخدام الخط الافتراضي للجهاز.

## 🖼️ الصور المطلوبة

### ملف الـ Logo:
- **المسار:** `assets/images/logo.png`
- **الحجم:** 120x120 بكسل
- **الشكل:** أيقونة السوبر ماركت

### صورة الـ Placeholder:
- **المسار:** `assets/images/placeholder.png`
- **الحجم:** 400x400 بكسل
- **الشكل:** صورة placeholder للمنتجات

### صورة "لا توجد صورة":
- **المسار:** `assets/images/no_image.png`
- **الحجم:** 400x400 بكسل
- **الشكل:** صورة "لا توجد صورة متاحة"

## ⚡ حل سريع مؤقت

إذا لم تتمكن من إضافة الخطوط الآن، يمكنك تعليق مرجع الخطوط في `pubspec.yaml`:

```yaml
# fonts:
#   - family: Cairo
#     fonts:
#       - asset: assets/fonts/Cairo-Regular.ttf
#       - asset: assets/fonts/Cairo-Bold.ttf
#         weight: 700
```

## 🎯 بعد إضافة الأصول

```bash
flutter clean
flutter pub get
flutter run
```

---

**ملاحظة:** التطبيق سيعمل بدون هذه الملفات، لكن قد يستخدم خطوط النظام الافتراضية.