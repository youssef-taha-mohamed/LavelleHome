import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract interface class HiveDatabase {
  HiveDatabase();

  static late final Box<bool> _appInfo;
  static late final Box<String> _appSettings;
  static const _fcmTokenKey = 'fcm_token';

  static Future<void> init() async {
    await Hive.initFlutter();
    _appInfo = await Hive.openBox<bool>('app_info');
    _appSettings = await Hive.openBox<String>('app_settings');
    // Using debugPrint for reliable web console logging during startup
    debugPrint('✅ HiveDatabase: app_info and app_settings boxes are ready.');
  }

  static Future<void> cacheTheAppIsOpened() async {
    return _appInfo.put('first_time_openedApp', false);
  }

  static bool firstTimeOpenedApp() {
    return _appInfo.get('first_time_openedApp', defaultValue: true) ?? true;
  }

  static Future<void> setLanguageCode(String languageCode) async {
    await _appSettings.put('language_code', languageCode);
  }

  static String? getLanguageCode() {
    try {
      return _appSettings.get('language_code');
    } catch (e) {
      debugPrint('⚠️ HiveDatabase.getLanguageCode error: $e');
      return null;
    }
  }

  static Future<void> setTheme(bool isDark) async {
    await _appSettings.put('theme_is_dark', isDark.toString());
  }

  static bool? getTheme() {
    try {
      final themeString = _appSettings.get('theme_is_dark');
      return themeString != null ? themeString == 'true' : null;
    } catch (e) {
      debugPrint('⚠️ HiveDatabase.getTheme error: $e');
      return null;
    }
  }

  static Future<void> setFcmToken(String token) async {
    await _appSettings.put(_fcmTokenKey, token);
  }

  static String? getFcmToken() {
    return _appSettings.get(_fcmTokenKey);
  }

  static Future<void> clearFcmToken() async {
    await _appSettings.delete(_fcmTokenKey);
  }

  // Developer settings
  static const _developerModeKey = 'developer_mode';
  static const _developerEnvironmentKey = 'developer_environment';

  static Future<void> setDeveloperMode(bool enabled) async {
    await _appSettings.put(_developerModeKey, enabled.toString());
  }

  static bool isDeveloperMode() {
    final value = _appSettings.get(_developerModeKey);
    return value == 'true';
  }

  static Future<void> setDeveloperEnvironment(String baseUrl) async {
    await _appSettings.put(_developerEnvironmentKey, baseUrl);
  }

  static String? getDeveloperEnvironment() {
    return _appSettings.get(_developerEnvironmentKey);
  }

  static const _initialNotificationKey = 'initial_notification';

  static Future<void> setInitialNotification(String value) async {
    await _appSettings.put(_initialNotificationKey, value);
  }

  static String? getInitialNotification() {
    return _appSettings.get(_initialNotificationKey);
  }

  static Future<void> clearInitialNotification() async {
    await _appSettings.delete(_initialNotificationKey);
  }
}
