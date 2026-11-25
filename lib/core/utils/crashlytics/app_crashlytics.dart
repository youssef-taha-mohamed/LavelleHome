import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// A platform-aware wrapper for Firebase Crashlytics ("كراس").
/// Ensures that Crashlytics is fully active on mobile platforms while
/// preventing assertion failures and crashes on Flutter Web.
final class AppCrashlytics {
  const AppCrashlytics._();

  /// Returns true on platforms where Crashlytics is NOT available
  /// (web + desktop: Windows, Linux) or when Firebase is not initialized.
  static bool get _isUnsupported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      Firebase.apps.isEmpty;

  /// Log an error to Crashlytics on native platforms, or console on Web.
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool fatal = false,
  }) async {
    if (_isUnsupported) {
      debugPrint('❌ Unsupported platform: Caught error (Crashlytics skipped)');
      debugPrint('Exception: $exception');
      if (stack != null) debugPrint('Stack Trace:\n$stack');
      return;
    }

    try {
      await FirebaseCrashlytics.instance.recordError(
        exception,
        stack,
        reason: reason,
        information: information,
        fatal: fatal,
      );
    } catch (e) {
      log('Error while recording to Crashlytics: $e');
    }
  }

  /// Log a Flutter-specific error.
  static Future<void> recordFlutterError(FlutterErrorDetails details) async {
    if (_isUnsupported) {
      // On web/desktop, we dump the full error to console to maintain
      // the standard Flutter error reporting experience.
      FlutterError.dumpErrorToConsole(details);
      return;
    }

    try {
      await FirebaseCrashlytics.instance.recordFlutterError(details);
    } catch (e) {
      log('Error while recording Flutter error to Crashlytics: $e');
    }
  }

  /// Log a fatal Flutter-specific error.
  static Future<void> recordFlutterFatalError(FlutterErrorDetails details) async {
    if (_isUnsupported) {
      // On web/desktop, we dump the full error to console to maintain
      // the standard Flutter error reporting experience.
      FlutterError.dumpErrorToConsole(details, forceReport: true);
      return;
    }

    try {
      await FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    } catch (e) {
      log('Error while recording fatal Flutter error to Crashlytics: $e');
    }
  }

  /// Safely enable/disable data collection.
  static Future<void> setCollectionEnabled(bool enabled) async {
    if (_isUnsupported) {
      log('Unsupported platform: Crashlytics collection toggle skipped ($enabled).');
      return;
    }

    try {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled);
    } catch (e) {
      log('Error while setting Crashlytics collection enabled: $e');
    }
  }
}
