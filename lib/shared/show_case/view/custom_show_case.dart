import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../core/extension/extension_helper.dart';
import '../../../core/style/app_colors.dart';

class CustomShowcase extends StatefulWidget {
  /// معرف فريد للـ showcase (مستخدم لحفظ الحالة في Hive)
  final String showcaseId;

  /// معرف مجموعة الـ showcase (لتعطيل المجموعة بالكامل)
  final String? showcaseGroupId;

  /// GlobalKey للـ showcase
  final GlobalKey keyValue;

  /// العنوان (اختياري)
  final String? title;

  /// الوصف
  final String description;

  /// الـ widget المراد إظهار showcase له
  final Widget child;

  /// تفعيل التمرير التلقائي
  final bool enableAutoScroll;

  /// عدد الـ showcases الكلي (لعرض Progress)
  final int? totalShowcases;

  /// الترتيب الحالي (لعرض Progress)
  final int? currentIndex;

  /// Callback عند الانتهاء من showcase
  final VoidCallback? onComplete;

  /// لون gradient مخصص (اختياري)
  final List<Color>? customGradientColors;

  const CustomShowcase({
    super.key,
    required this.showcaseId,
    this.showcaseGroupId,
    required this.keyValue,
    this.title,
    required this.description,
    required this.child,
    this.enableAutoScroll = true,
    this.totalShowcases,
    this.currentIndex,
    this.onComplete,
    this.customGradientColors,
  });

  @override
  State<CustomShowcase> createState() => _CustomShowcaseState();
}

class _CustomShowcaseState extends State<CustomShowcase> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return widget.child;

    final isDark = context.isDark;

    return Showcase(
      enableAutoScroll: widget.enableAutoScroll,
      key: widget.keyValue,
      title: _buildTitle(),
      description: _buildDescription(),
      overlayOpacity: isDark ? 0.92 : 0.85,
      overlayColor: Colors.black,
      targetShapeBorder: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      titleTextStyle: TextStyle(
        color: MyColors.islamicGold,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      descTextStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: 14.sp,
        height: 1.5,
      ),
      showArrow: true,
      tooltipBackgroundColor: MyColors.black,
      tooltipPadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      tooltipBorderRadius: BorderRadius.circular(16.r),
      onToolTipClick: () {
        ShowcaseView.get().next();
      },
      onTargetClick: () {
        ShowcaseView.get().next();
      },
      disposeOnTap: false,
      child: widget.child,
    );
  }

  /// بناء العنوان (تم إخفاء الـ Progress)
  String _buildTitle() {
    return widget.title ?? '';
  }

  /// بناء الوصف (تم إخفاء الـ Progress والـ hint)
  String _buildDescription() {
    return widget.description;
  }
}
