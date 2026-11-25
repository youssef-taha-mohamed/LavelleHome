# Konoz — Flutter Dynamic Theme System (Material 3 + Dynamic Colors + Locale-Aware)

هذه الوثيقة تشرح بالتفصيل نظام الثيم الجديد الذي تمت إعادة بنائه من الصفر،  
بأسلوب احترافي وحديث يدعم:

- 🎨 Material 3 Color System
- 🌈 Dynamic Colors (Android 12+)
- 🧬 Seed-Based ColorScheme
- 🌙 Light & Dark Themes
- 🔤 Typography تربط اللغات بالخطوط تلقائيًا
- 🧩 Theme Extensions
- 📦 Modular Components
- 📱 Locale-aware direction (RTL / LTR)
- 🧠 ThemeManager مركزي
- ⚡ أداء عالي + كود نظيف بالكامل

---

# 🏗️ **1. بنية ملفات الثيم الجديدة**

تم تقسيم كل شيء إلى ملفات منظمة لسهولة الصيانة:



---

# 🎯 **2. AppThemeExtension**

ملف ThemeExtension يسمح بإضافة خصائص غير موجودة في Flutter افتراضيًا:

```dart
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final double radiusSmall;
  final double radiusMedium;
  final double radiusLarge;

  final EdgeInsets defaultPadding;
  final EdgeInsets screenPadding;

  final Color cardBackground;
  final Color elevatedSurface;
  final Color borderColor;

  final List<BoxShadow> smallShadow;
  final List<BoxShadow> mediumShadow;

  final Duration animationDuration;
  final Curve defaultCurve;
}

final ext = context.theme.extension<AppThemeExtension>()!;
final radius = ext.radiusMedium;


Typography موحدة، لكن fontFamily يختلف حسب اللغة:

static String getFontFamily(Locale locale) =>
  locale.languageCode == "ar" ? "Cairo" : "Gotham";


ColorScheme.fromSeed(
  seedColor: MyColors.primaryColor,
  brightness: Brightness.light,
);

final dynamicScheme = await DynamicColorPlugin.getCorePalette();
