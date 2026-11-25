import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:developer' as dev;

class ForceUpdateService {
  ForceUpdateService._();
  static final ForceUpdateService instance = ForceUpdateService._();

  FirebaseRemoteConfig? get _remoteConfig =>
      Firebase.apps.isEmpty ? null : FirebaseRemoteConfig.instance;

  // Remote Config Keys
  static const String _minAppVersionKey = 'min_app_version';
  static const String _storeUrlIosKey = 'store_url_ios';
  static const String _storeUrlAndroidKey = 'store_url_android';
  static const String _updateTitleArKey = 'force_update_title_ar';
  static const String _updateTitleEnKey = 'force_update_title_en';
  static const String _updateMessageArKey = 'force_update_message_ar';
  static const String _updateMessageEnKey = 'force_update_message_en';

  String _currentVersion = '';
  String get currentVersion => _currentVersion;

  Future<void> init() async {
    try {
      final rc = _remoteConfig;
      if (rc == null) return;

      await rc.setDefaults({
        _minAppVersionKey: '1.0.0',
        _storeUrlIosKey:
            'https://apps.apple.com/us/app/tiba-academy/id6796023439',
        _storeUrlAndroidKey:
            'https://play.google.com/store/apps/details?id=com.nileunited.tibastudent',
        _updateTitleArKey: 'تحديث جديد متاح',
        _updateTitleEnKey: 'New Update Available',
        _updateMessageArKey:
            'يرجى تحديث التطبيق للاستمرار في استخدامه والحصول على أحدث المميزات.',
        _updateMessageEnKey:
            'Please update the app to continue using it and get the latest features.',
      });

      await rc.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 4),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await rc.fetchAndActivate();
    } catch (e) {
      dev.log('❌ ForceUpdateService: Failed to initialize Remote Config: $e');
    }
  }

  Future<bool> isUpdateRequired() async {
    try {
      final rc = _remoteConfig;
      if (rc == null) return false;

      final packageInfo = await PackageInfo.fromPlatform();
      _currentVersion = packageInfo.version;
      final minRequiredVersion = rc.getString(_minAppVersionKey);

      dev.log(
        '🔍 Version Check: Current=$_currentVersion, Required=$minRequiredVersion',
      );

      return _isVersionGreaterThan(minRequiredVersion, _currentVersion);
    } catch (e) {
      dev.log('❌ ForceUpdateService: Error checking version: $e');
      return false;
    }
  }

  String getUpdateTitle(String languageCode) {
    final rc = _remoteConfig;
    if (rc == null) {
      return languageCode == 'ar' ? 'تحديث جديد متاح' : 'New Update Available';
    }
    return languageCode == 'ar'
        ? rc.getString(_updateTitleArKey)
        : rc.getString(_updateTitleEnKey);
  }

  String getUpdateMessage(String languageCode) {
    final rc = _remoteConfig;
    if (rc == null) {
      return languageCode == 'ar'
          ? 'يرجى تحديث التطبيق للاستمرار في استخدامه والحصول على أحدث المميزات.'
          : 'Please update the app to continue using it and get the latest features.';
    }
    return languageCode == 'ar'
        ? rc.getString(_updateMessageArKey)
        : rc.getString(_updateMessageEnKey);
  }

  String get storeUrl {
    final rc = _remoteConfig;
    if (rc == null) return '';
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return rc.getString(_storeUrlIosKey);
    } else {
      return rc.getString(_storeUrlAndroidKey);
    }
  }

  /// Compares two version strings (e.g. "1.0.1" and "1.1.0")
  /// Returns true if [required] > [current]
  bool _isVersionGreaterThan(String required, String current) {
    final requiredParts = required.split('.').map(int.parse).toList();
    final currentParts = current.split('.').map(int.parse).toList();

    for (var i = 0; i < requiredParts.length; i++) {
      if (i >= currentParts.length) {
        return requiredParts[i] > 0;
      }
      if (requiredParts[i] > currentParts[i]) {
        return true;
      } else if (requiredParts[i] < currentParts[i]) {
        return false;
      }
    }
    return false;
  }
}
