import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../l10n/l10n.dart';
import '../service/navigation_service.dart';

class DateFormatter {
  static final context = NavigationService.navigatorKey.currentContext;

  static String formatDate(DateTime date) {
    // 1. نضمن وجود الـ context
    final currentContext = NavigationService.navigatorKey.currentContext;
    if (currentContext == null) return "";

    // 2. أهم خطوة: تحويل التاريخ القادم لـ Local
    // حتى لو كان UTC أو ناقصه حرف الـ Z، التأكد هنا يحميك من فروقات الساعات
    final localDate = date.toLocal();

    // 3. الحصول على الوقت الحالي (دائماً Local)
    final now = DateTime.now();
    final difference = now.difference(localDate);

    // اليوم نفسه (استخدام localDate بدلاً من date)
    if (localDate.year == now.year &&
        localDate.month == now.month &&
        localDate.day == now.day) {
      return _formatTimeOnly(localDate);
    }

    // أمس
    final yesterday = now.subtract(const Duration(days: 1));
    if (localDate.year == yesterday.year &&
        localDate.month == yesterday.month &&
        localDate.day == yesterday.day) {
      // التأكد من استخدام l10n من خلال الـ currentContext
      return '${currentContext.l10n.yesterday} ${_formatTimeOnly(localDate)}';
    }

    // هذا الأسبوع
    if (difference.inDays < 7) {
      return '${_getDayName(localDate)} ${_formatTimeOnly(localDate)}';
    }

    // هذا الشهر
    if (localDate.month == now.month && localDate.year == now.year) {
      return '${localDate.day} ${_getMonthName(localDate)} ${_formatTimeOnly(localDate)}';
    }

    // هذه السنة
    if (localDate.year == now.year) {
      return '${localDate.day} ${_getMonthName(localDate)}';
    }

    // السنوات السابقة
    return '${localDate.day} ${_getMonthName(localDate)} ${localDate.year}';
  }

  /// تنسيق التاريخ بصيغة مخصصة
  static String formatCustom(
    DateTime date,
    String pattern, {
    String? locale,
  }) {
    Intl.defaultLocale = context?.l10n.localeName;
    return DateFormat(pattern, locale).format(date);
  }

  /// تحويل التاريخ إلى صيغة منذ (قبل دقيقة، قبل ساعة، الخ)
  static String formatTimeAgo(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(date);

    // استخدام l10n بدلاً من النصوص الثابتة
    final l10n = context.l10n;

    if (difference.inSeconds < 60) {
      // نفترض أن لديك "second" في ملفات l10n
      // إذا كانت 0 ثانية، اعرض "الآن"
      return difference.inSeconds == 0
          ? l10n.now
          : '${l10n.since} ${difference.inSeconds} ${l10n.second}';
    } else if (difference.inMinutes < 60) {
      return '${l10n.since} ${difference.inMinutes} ${l10n.minute}';
    } else if (difference.inHours < 24) {
      return '${l10n.since} ${difference.inHours} ${l10n.hour}';
    } else if (difference.inDays < 30) {
      return '${l10n.since} ${difference.inDays} ${l10n.day}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${l10n.since} $months ${l10n.month}';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${l10n.since} $years ${l10n.year}';
    }
  }

  /// تنسيق الوقت المتبقي (أيام وساعات)
  static String formatRemainingTime(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final difference = date.difference(now);
    final l10n = context.l10n;

    if (difference.isNegative) {
      return l10n.pending_course_renewal_window_closed;
    }

    final totalHours = difference.inHours;
    final remainingDays = totalHours ~/ 24;
    final remainingHours = totalHours % 24;

    return '$remainingDays ${l10n.day}  $remainingHours ${l10n.hour}';
  }

  static String formatSmartDay(DateTime date, BuildContext context) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final diff = target.difference(today).inDays;

    final l10n = context.l10n;

    if (diff == 0) {
      return l10n.today; // اليوم
    }

    if (diff == 1) {
      return l10n.tomorrow; // غدًا
    }

    return DateFormat('EEEE', l10n.localeName).format(date);
  }

  static DateTime? parseDate(String dateStr) {
    if (dateStr.trim().isEmpty) {
      debugPrint("Info: Field is empty or null"); // ده التحذير اللي بيطمنك
      return null;
    }

    try {
      String fixedDate = dateStr.endsWith('Z') ? dateStr : '${dateStr}Z';
      DateTime local = DateTime.parse(fixedDate).toLocal();

      // سطر إضافي للتأكد من الدقة أثناء التطوير
      // debugPrint("Converted: $dateStr -> To Local: $local");

      return local;
    } catch (e) {
      debugPrint("Critical: Invalid format found! -> $dateStr");
      return null;
    }
  }

  /// الحصول على اسم اليوم
  static String _getDayName(DateTime date) {
    return DateFormat('EEEE', context?.l10n.localeName).format(date);
  }

  /// الحصول على اسم الشهر
  static String _getMonthName(DateTime date) {
    return DateFormat('MMMM', context?.l10n.localeName).format(date);
  }

  /// تنسيق الوقت فقط
  static String _formatTimeOnly(DateTime date) {
    return DateFormat('h:mm a', context?.l10n.localeName).format(date);
  }

  /// تنسيق التاريخ للعرض في الواجهة
  static String formatForUI(
    DateTime date,
    BuildContext context, {
    String? locale,
  }) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return context.l10n.now;
    } else if (difference.inHours < 1) {
      return formatTimeAgo(date, context);
    } else if (date.day == now.day) {
      return _formatTimeOnly(date);
    } else if (difference.inDays < 7) {
      return '${_getDayName(date)} ${_formatTimeOnly(date)}';
    } else {
      return '${date.day} ${_getMonthName(date)} ${date.year}';
    }
  }

  /// تحويل التاريخ إلى صيغة قابلة للمقارنة
  static String formatForComparison(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// التحقق من أن التاريخ هو اليوم
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// التحقق من أن التاريخ هو أمس
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// تنسيق التاريخ بأسلوب (اليوم / غدًا / تاريخ + وقت)
  static String formatRelativeDay(
    DateTime date,
    BuildContext context, {
    String? locale,
  }) {
    final now = DateTime.now();
    final l10n = context.l10n;

    final effectiveLocale =
        locale ?? Localizations.localeOf(context).languageCode;
    Intl.defaultLocale = effectiveLocale;

    final diffInDays = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    final time = DateFormat('HH:mm', effectiveLocale).format(date);

    // اليوم
    if (diffInDays == 0) {
      return '${l10n.today} $time';
    }

    // غدًا
    if (diffInDays == 1) {
      return '${l10n.tomorrow} $time';
    }

    // تاريخ عادي
    final datePart = DateFormat('d/M/y', effectiveLocale).format(date);
    return '$datePart - $time';
  }
}

/*
======================== DateFormatter Usage Guide ========================

1️⃣ formatDate(DateTime, BuildContext)
--------------------------------------------------
- تستخدم لعرض التاريخ بشكل ذكي:
  - اليوم → وقت فقط
  - أمس → "أمس + وقت"
  - هذا الأسبوع → اسم اليوم + وقت
  - هذا الشهر → يوم + شهر + وقت
  - هذا العام → يوم + شهر
- تعتمد على l10n
- مناسبة لقوائم الإشعارات والرسائل

Example:
DateFormatter.formatDate(date, context);

--------------------------------------------------------------------------

2️⃣ formatCustom(DateTime, pattern)
--------------------------------------------------
- تنسيق التاريخ باستخدام pattern مخصص
- تعتمد على Intl
- مناسبة للتقارير أو الشاشات المتخصصة

Example:
DateFormatter.formatCustom(date, 'yyyy/MM/dd');

--------------------------------------------------------------------------

3️⃣ formatTimeAgo(DateTime, BuildContext)
--------------------------------------------------
- تعرض الوقت بصيغة "منذ ..."
- تدعم:
  - الآن
  - دقائق
  - ساعات
  - أيام
  - شهور
  - سنوات
- تعتمد كليًا على l10n

Example:
DateFormatter.formatTimeAgo(date, context);

--------------------------------------------------------------------------

4️⃣ formatRelativeDay(DateTime, BuildContext)
--------------------------------------------------
- تعرض:
  - اليوم + وقت
  - غدًا + وقت
  - تاريخ + وقت
- مناسبة للحجوزات والمواعيد القادمة
- تدعم جميع لغات التطبيق

Example:
DateFormatter.formatRelativeDay(date, context);

--------------------------------------------------------------------------

5️⃣ formatForUI(DateTime, BuildContext)
--------------------------------------------------
- تنسيق مختصر للواجهة
- ذكي حسب الفرق الزمني
- مناسب للـ cards والـ lists

Example:
DateFormatter.formatForUI(date, context);

--------------------------------------------------------------------------

6️⃣ formatForComparison(DateTime)
--------------------------------------------------
- تحويل التاريخ لصيغة قابلة للمقارنة
- يستخدم في الفلترة والمقارنات

Example:
DateFormatter.formatForComparison(date);

--------------------------------------------------------------------------

7️⃣ isToday / isYesterday
--------------------------------------------------
- دوال مساعدة للتحقق من اليوم أو أمس

Example:
if (DateFormatter.isToday(date)) { ... }

===========================================================================
*/
