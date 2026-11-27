import 'dart:async';
import 'dart:developer';
import 'package:app_links/app_links.dart';
import '../../feature/laundry/presentation/view/home_screen.dart';
import '../authentication/provider.dart';
import '../service/navigation_service.dart';
import '../../feature/auth/presentation/login/view/login.dart';
import '../../feature/auth/presentation/impersonate/view/impersonation_screen.dart';

abstract final class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _linkSubscription;
  static HomeScreenParameter? _pendingParameter;
  static Uri? _lastHandledUri;
  static DateTime? _lastHandledTime;

  /// Returns true if there is a pending deep link waiting to be handled
  static bool get hasPendingDeepLink => _pendingParameter != null;

  /// Sets a pending parameter manually (useful for Web initial URL parsing)
  static void setPendingParameter(HomeScreenParameter parameter) {
    _pendingParameter = parameter;
  }

  /// Initializes deep link listeners for both initial link and stream
  static Future<void> init() async {
    try {
      // 1. Listen for background & foreground incoming links
      _linkSubscription?.cancel();
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (uri) {
          log(
            '🔗 [DeepLink] Incoming stream link: $uri',
            name: 'DeepLinkService',
          );
          _handleUri(uri);
        },
        onError: (err) {
          log(
            '❌ [DeepLink] Error in link stream: $err',
            name: 'DeepLinkService',
          );
        },
      );

      // 2. Handle cold start initial link
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        log(
          '🚀 [DeepLink] Cold start initial link: $initialUri',
          name: 'DeepLinkService',
        );
        _handleUri(initialUri, isColdStart: true);
      }
    } catch (e, stack) {
      log(
        '❌ [DeepLink] Initialization failed: $e',
        error: e,
        stackTrace: stack,
        name: 'DeepLinkService',
      );
    }
  }

  /// Processes any URI received from App Link, Universal Link, or Custom Scheme
  static void _handleUri(Uri uri, {bool isColdStart = false}) {
    // Debounce duplicate links within 1.5 seconds
    final now = DateTime.now();
    if (_lastHandledUri == uri &&
        _lastHandledTime != null &&
        now.difference(_lastHandledTime!).inMilliseconds < 1500) {
      log(
        '⚠️ [DeepLink] Duplicate link ignored (debounced): $uri',
        name: 'DeepLinkService',
      );
      return;
    }
    _lastHandledUri = uri;
    _lastHandledTime = now;

    // Handle impersonation deep link (Production / Dev / Custom Scheme)
    final impersonationToken = uri.queryParameters['token'];
    final isImpersonate =
        uri.path.contains('impersonate') ||
        (impersonationToken != null &&
            impersonationToken.isNotEmpty &&
            (uri.path == '/' || uri.path.isEmpty));

    if (isImpersonate &&
        impersonationToken != null &&
        impersonationToken.isNotEmpty) {
      log(
        '🎭 [DeepLink] Handling impersonation link with token: $impersonationToken',
        name: 'DeepLinkService',
      );
      final navState = NavigationService.navigatorKey.currentState;
      if (navState != null) {
        navState.pushNamedAndRemoveUntil(
          ImpersonationScreen.routeName,
          (route) => false,
          arguments: impersonationToken,
        );
      }
      return;
    }

    final parameter = parseHomeScreenUri(uri);
    if (parameter == null) {
      log(
        'ℹ️ [DeepLink] URI does not match course_details target: $uri',
        name: 'DeepLinkService',
      );
      return;
    }

    if (isColdStart) {
      // For cold starts, save as pending so Splash can complete initial setup
      log(
        '⏳ [DeepLink] Cold start detected - setting pending deep }',
        name: 'DeepLinkService',
      );
      _pendingParameter = parameter;
      return;
    }

    _navigateOrDefer(parameter);
  }

  /// Parses a URI to extract [MyCoursesDetailsScreenParameter]
  /// Supports:
  /// - https://student.knoz.online/course_details?sspId=...&studentId=...
  /// - https://knoz-student.azurewebsites.net/course_details?sspId=...&studentId=...
  /// - konoz://course_details?sspId=...&studentId=...
  static HomeScreenParameter? parseHomeScreenUri(Uri uri) {
    final host = uri.host.toLowerCase();
    final path = uri.path.toLowerCase();

    final isMatchingHost =
        host.contains('student.knoz.online') ||
        host.contains('azurewebsites.net') ||
        host == 'course_details' ||
        host == 'course-details';

    final isMatchingPath =
        path.contains('course_details') || path.contains('course-details');

    if (!isMatchingHost && !isMatchingPath) {
      return null;
    }

    // Extract sspId (expected as int)
    final rawSspId = uri.queryParameters['sspId'];
    if (rawSspId == null || rawSspId.trim().isEmpty) {
      log('⚠️ [DeepLink] sspId missing in URI: $uri', name: 'DeepLinkService');
      return null;
    }

    final sspIdString = rawSspId.replaceAll('"', '').replaceAll("'", '').trim();
    final int? sspId = int.tryParse(sspIdString);
    if (sspId == null) {
      log(
        '⚠️ [DeepLink] Invalid sspId format ($sspIdString) in URI: $uri',
        name: 'DeepLinkService',
      );
      return null;
    }

    // Extract studentId (expected as String)
    final rawStudentId = uri.queryParameters['studentId'];
    String studentId = (rawStudentId ?? '')
        .replaceAll('"', '')
        .replaceAll("'", '')
        .trim();

    if (studentId.isEmpty) {
      studentId = AuthenticationProvider.user?.details.id ?? '';
    }

    return HomeScreenParameter(id: studentId);
  }

  /// Navigates to CoursesDetailsScreen or defers if app is not ready/authenticated
  static void _navigateOrDefer(HomeScreenParameter parameter) {
    final navState = NavigationService.navigatorKey.currentState;
    final isAuth = AuthenticationProvider.isAuth;

    if (!isAuth) {
      log(
        '🔒 [DeepLink] User not authenticated. Deferring navigation and opening login.',
        name: 'DeepLinkService',
      );
      _pendingParameter = parameter;
      if (navState != null) {
        navState.pushNamed(LoginView.routeName);
      }
      return;
    }

    // If studentId was missing, fill it from authenticated user
    final finalStudentId = parameter.id.isNotEmpty
        ? parameter.id
        : (AuthenticationProvider.user?.details.id ?? '');

    final resolvedParameter = HomeScreenParameter(id: finalStudentId);

    if (navState == null) {
      log(
        '⏳ [DeepLink] NavigatorState not ready. Deferring parameter.',
        name: 'DeepLinkService',
      );
      _pendingParameter = resolvedParameter;
      return;
    }

    log(
      '🚀 [DeepLink] Navigating to CoursesDetailsScreen with studentId: ${resolvedParameter.id}',
      name: 'DeepLinkService',
    );
    navState.pushNamed(HomeScreen.routeName, arguments: resolvedParameter);
  }

  /// Processes any deferred deep link (e.g. after Splash completes or after login)
  static void processPendingDeepLink() {
    if (_pendingParameter == null) return;

    if (!AuthenticationProvider.isAuth) {
      log(
        '🔒 [DeepLink] Cannot process pending link - user still not authenticated',
        name: 'DeepLinkService',
      );
      return;
    }

    final param = _pendingParameter!;
    _pendingParameter = null;

    final studentId = param.id.isNotEmpty
        ? param.id
        : (AuthenticationProvider.user?.details.id ?? '');

    final resolvedParam = HomeScreenParameter(id: studentId);

    final navState = NavigationService.navigatorKey.currentState;
    if (navState != null) {
      navState.pushNamed(HomeScreen.routeName, arguments: resolvedParam);
    } else {
      // Re-queue if navigator not yet attached
      _pendingParameter = resolvedParam;
    }
  }

  /// Disposes stream subscription when needed
  static void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
  }
}
