import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'showcase_manager.dart';

/// 🎮 ShowcaseController - لإدارة عدة showcases معاً
///
/// يساعد في:
/// - إدارة تسلسل عرض الـ showcases
/// - التحقق من العرض السابق
/// - تنفيذ callbacks عند الانتهاء
class ShowcaseController {
  final String showcaseGroupId;
  final List<GlobalKey> showcaseKeys;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  ShowcaseController({
    required this.showcaseGroupId,
    required this.showcaseKeys,
    this.onComplete,
    this.onSkip,
  });

  static final ValueNotifier<bool> isGlobalTourActive = ValueNotifier(false);
  static String? activeGroupId;

  /// بدء عرض الـ showcases
  Future<void> start(BuildContext context) async {
    if (kIsWeb) return;

    // التحقق من عدم عرض الـ showcase من قبل
    final hasBeenShown = await ShowcaseManager().hasBeenShown(showcaseGroupId);

    if (hasBeenShown) return;

    // تحديث المعرف والحالة النشطة عالمياً
    activeGroupId = showcaseGroupId;
    isGlobalTourActive.value = true;

    if (context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowcaseView.get().startShowCase(showcaseKeys);
      });
    }
  }

  /// إخفاء الجولة الحالية للأبد في الكاش
  static Future<void> markActiveAsCompleted() async {
    if (activeGroupId != null) {
      isGlobalTourActive.value = false;
      await ShowcaseManager().markAsCompleted(activeGroupId!);
    }
  }

  /// وضع علامة مكتمل على الـ showcase
  Future<void> complete() async {
    isGlobalTourActive.value = false;
    await ShowcaseManager().markAsCompleted(showcaseGroupId);
    onComplete?.call();
  }

  /// تخطي الـ showcase النشط عالمياً
  static void skipActive() {
    isGlobalTourActive.value = false;
  }

  /// تخطي الـ showcase
  void skip() {
    isGlobalTourActive.value = false;
    onSkip?.call();
  }

  /// إعادة تعيين الـ showcase (للتطوير)
  Future<void> reset() async {
    await ShowcaseManager().resetShowcase(showcaseGroupId);
  }
}

/// 🎯 مثال على الاستخدام:
///
/// ```dart
/// class MyHomePage extends StatefulWidget {
///   @override
///   State<MyHomePage> createState() => _MyHomePageState();
/// }
///
/// class _MyHomePageState extends State<MyHomePage> {
///   final GlobalKey _key1 = GlobalKey();
///   final GlobalKey _key2 = GlobalKey();
///   final GlobalKey _key3 = GlobalKey();
///
///   late ShowcaseController _showcaseController;
///
///   @override
///   void initState() {
///     super.initState();
///     _showcaseController = ShowcaseController(
///       showcaseGroupId: 'home_screen_tour',
///       showcaseKeys: [_key1, _key2, _key3],
///       onComplete: () {
///         print('Showcase completed!');
///       },
///     );
///
///     // بدء العرض بعد بناء الواجهة
///     WidgetsBinding.instance.addPostFrameCallback((_) {
///       _showcaseController.start(context);
///     });
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return ShowcaseRoot(
///       onComplete: (index, key) {
///         if (index == 2) { // آخر showcase
///           _showcaseController.complete();
///         }
///       },
///       builder: Builder(
///         builder: (context) => Scaffold(
///           body: Column(
///             children: [
///               CustomShowcase(
///                 showcaseId: 'home_feature_1',
///                 keyValue: _key1,
///                 title: 'ميزة رائعة',
///                 description: 'هذه ميزة رائعة في التطبيق',
///                 totalShowcases: 3,
///                 currentIndex: 0,
///                 child: YourWidget1(),
///               ),
///               // ... المزيد من الـ showcases
///             ],
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```