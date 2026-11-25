import 'dart:developer';
import 'package:hive/hive.dart';

/// مدير حالات الـ Showcase باستخدام Hive
/// يحفظ تفضيلات المستخدم لكل showcase بشكل منفصل
class ShowcaseManager {
  ShowcaseManager._internal();

  factory ShowcaseManager() => _singleton;

  static final _singleton = ShowcaseManager._internal();

  bool _isInitialized = false;
  late final Box<bool> _showcaseBox;
  static const String _boxName = 'showcase_preferences';

  /// تهيئة الـ Hive Box
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      if (Hive.isBoxOpen(_boxName)) {
        _showcaseBox = Hive.box<bool>(_boxName);
      } else {
        _showcaseBox = await Hive.openBox<bool>(_boxName);
      }
      _isInitialized = true;
      log('✅ ShowcaseManager initialized successfully');
    } catch (e) {
      log('❌ Error initializing ShowcaseManager: $e');
      rethrow;
    }
  }

  /// حفظ حالة showcase معين
  Future<void> markAsCompleted(String showcaseId) async {
    try {
      await _showcaseBox.put(showcaseId, true);
      log('💾 Showcase "$showcaseId" marked as completed');
    } catch (e) {
      log('❌ Error saving showcase state: $e');
    }
  }

  /// التحقق من عرض showcase معين من قبل
  Future<bool> hasBeenShown(String showcaseId) async {
    try {
      final hasShown = _showcaseBox.get(showcaseId, defaultValue: false) ?? false;
      log('🔍 Showcase "$showcaseId" has been shown: $hasShown');
      return hasShown;
    } catch (e) {
      log('❌ Error checking showcase state: $e');
      return false;
    }
  }

  /// إعادة تعيين حالة showcase معين (للتطوير والاختبار)
  Future<void> resetShowcase(String showcaseId) async {
    try {
      await _showcaseBox.delete(showcaseId);
      log('🔄 Showcase "$showcaseId" reset');
    } catch (e) {
      log('❌ Error resetting showcase: $e');
    }
  }

  /// إعادة تعيين كل showcases (للتطوير والاختبار)
  Future<void> resetAll() async {
    try {
      await _showcaseBox.clear();
      log('🔄 All showcases reset');
    } catch (e) {
      log('❌ Error resetting all showcases: $e');
    }
  }

  /// الحصول على عدد showcases المكتملة
  int getCompletedCount() {
    return _showcaseBox.values.where((completed) => completed).length;
  }

  /// الحصول على قائمة بجميع showcases المكتملة
  List<String> getCompletedShowcases() {
    return _showcaseBox.keys
        .where((key) => _showcaseBox.get(key) == true)
        .map((key) => key.toString())
        .toList();
  }
}