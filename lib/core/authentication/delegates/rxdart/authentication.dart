import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:rxdart/rxdart.dart';
import '../../../service/impersonation_service.dart';
import '../../../../feature/auth/domain/entities/login_credentials.dart';
import '../../../../feature/auth/domain/entities/logout_params.dart';
import '../../../../feature/auth/domain/entities/register_credentials.dart';
import '../../../../feature/auth/domain/entities/social_media_credentials.dart';
import '../../../../feature/auth/domain/entities/social_register_credentials.dart';
import '../../../../feature/auth/domain/repositories/authentication.dart';
import '../../../../feature/auth/domain/use_cases/login.dart';
import '../../../../feature/auth/domain/use_cases/login_with_social_media.dart';
import '../../../../feature/auth/domain/use_cases/logout.dart';
import '../../../../feature/auth/domain/use_cases/register.dart';
import '../../../../feature/auth/domain/use_cases/register_with_social_media.dart';
import '../../../../feature/user/domain/entities/parameters/add_fcm_token.dart';
import '../../../../feature/user/domain/entities/parameters/verify_account.dart';
import '../../../../feature/user/domain/entities/user.dart';
import '../../../../feature/user/domain/repositories/user.dart';
import '../../../../feature/user/domain/use_cases/add_fcm_token.dart';
import '../../../../feature/user/domain/use_cases/fetch_user_by_id.dart';
import '../../../../feature/user/domain/use_cases/verify_account.dart';
import '../../../../shared/model/api_response.dart';
import '../../../db/kv_db/hive.dart';
import '../../../di/dependency_injector.dart';
import '../../../service/jwt_service.dart';
import '../../../utils/notification/notification.dart';
import '../../cache/base/auth.dart';
import '../base/authentication.dart';

final class AuthenticationDelegateWithRxdart implements AuthenticationDelegate {
  AuthenticationDelegateWithRxdart({
    required this._authRepository,
    required this._userRepository,
    required this._cache,
  });

  final AuthenticationBaseRepository _authRepository;
  final UserBaseRepository _userRepository;
  final AuthenticationCache _cache;

  final _authStateController = BehaviorSubject<bool>.seeded(false);
  final _userController = BehaviorSubject<User?>.seeded(null);
  final _authChangesStreamController = BehaviorSubject<User?>();

  StreamSubscription<String>? _fcmTokenRefreshSubscription;
  StreamSubscription<bool>? _fcmAuthStateSubscription;
  String? _registeringToken;

  // late final StreamSubscription _authStreamSubscription;

  @override
  User? get currentUser => _userController.value;

  @override
  bool get isAuthenticated => _authStateController.value;

  @override
  Future<void> init() async {
    await _cache.init();
    // _authStreamSubscription = authStateChanges().listen((event) async {
    //   if (event == null) {
    //     await _cache.deleteToken();
    //     await _cache.deleteUser();
    //   } else {
    //     await _cache.cacheToken(token: event.token);
    //     await _cache.cachUser(user: event);
    //   }
    // });

    await verifyToken();

    // Setup global FCM registration listeners once the singleton is initialized
    _fcmTokenRefreshSubscription ??= NotificationUtils.onTokenRefresh().listen((
      event,
    ) {
      if (!canRegisterFcmToken) {
        log('🔄 FCM refreshed but user not eligible yet');
        return;
      }
      addFcmToken(token: event);
    });

    _fcmAuthStateSubscription ??= authStateChanges().listen((_) async {
      if (!canRegisterFcmToken) {
        log('🚫 Skipping FCM registration (user not fully authenticated)');
        return;
      }
      final fcmToken = await NotificationUtils.fcmToken();
      if (fcmToken == null || fcmToken.isEmpty) return;
      await addFcmToken(token: fcmToken);
    });
  }

  @override
  void dispose() {
    _fcmTokenRefreshSubscription?.cancel();
    _fcmAuthStateSubscription?.cancel();
    _userController.close();
    _authChangesStreamController.close();
    _authStateController.close();
  }

  @override
  Future<ApiResponse<User>> login({
    required LoginCredentials credentials,
  }) async {
    try {
      final useCase = Login(repository: _authRepository);
      final response = await useCase.call(credentials: credentials);

      final user = response.record;

      await _cache.cacheToken(token: user.accessToken);
      await _cache.cachUser(user: user.details);
      await syncPreferenceFromUser(user);
      _authStateController.sink.add(true);
      _userController.sink.add(user);

      return response;
    } catch (e) {
      _authStateController.sink.add(false);
      _userController.sink.add(null);
      rethrow;
    }
  }

  @override
  void sinkUser(User user) async {
    try {
      await _cache.cacheToken(token: user.accessToken);
      await _cache.cachUser(user: user.details);

      _authChangesStreamController.sink.add(user);
      _userController.sink.add(user);
      log('User data updated in cache and stream via sinkUser.');
    } catch (e) {
      log('Error in sinkUser: $e');
    }
  }

  @override
  Future<void> saveImpersonatedSession(User user) async {
    try {
      debugPrint('AuthDelegate: Ensuring cache is initialized...');
      await _cache.init();
      debugPrint('AuthDelegate: Caching token...');
      await _cache.cacheToken(token: user.accessToken);
      debugPrint('AuthDelegate: Caching user details...');
      await _cache.cachUser(user: user.details);
      debugPrint('AuthDelegate: Syncing preferences...');
      await syncPreferenceFromUser(user);
      _authChangesStreamController.sink.add(user);
      _authStateController.sink.add(true);
      _userController.sink.add(user);
      debugPrint('AuthDelegate: Impersonated user session saved successfully.');
    } catch (e, s) {
      debugPrint('AuthDelegate: Error in saveImpersonatedSession: $e\n$s');
    }
  }

  @override
  Future<ApiResponse<User>> loginWithSocialMedia({
    required SocialMediaCredentials credentials,
  }) async {
    final useCase = LoginWithSocialMedia(repository: _authRepository);
    final response = await useCase.call(credentials: credentials);

    // الباك إند بيرجع status: false لما اليوزر مش مسجل → نرجع الـ response زي ما هو
    // الـ caller (SocialLoginCubit) هو اللي هيتعامل مع الـ حالتين
    if (!response.status) {
      return response;
    }

    final user = response.record;
    await _cache.cacheToken(token: user.accessToken);
    await _cache.cachUser(user: user.details);
    await syncPreferenceFromUser(user);

    _authChangesStreamController.sink.add(user);
    _userController.sink.add(user);
    _authStateController.sink.add(true);

    return response;
  }

  @override
  Future<ApiResponse<User>> registerWithSocialMedia({
    required SocialRegisterCredentials credentials,
  }) async {
    final useCase = RegisterWithSocialMedia(repository: _authRepository);
    final response = await useCase.call(credentials: credentials);

    final user = response.record;
    await _cache.cacheToken(token: user.accessToken);
    await _cache.cachUser(user: user.details);
    await syncPreferenceFromUser(user);

    _authChangesStreamController.sink.add(user);
    _userController.sink.add(user);
    _authStateController.sink.add(true);

    return response;
  }

  @override
  Future<ApiResponse> logout() async {
    try {
      final token = await _cache.cachedToken();

      if (token != null && token.isNotEmpty) {
        await Logout(repository: _authRepository).call(
          parameters: LogoutParameters(
            fcmToken: await NotificationUtils.fcmToken() ?? '',
            platform: defaultTargetPlatform,
          ),
        );
      }
    } catch (e) {
      log('Logout API failed: $e');
    } finally {
      await logoutLocally();
    }
    return ApiResponse<String>(
      status: true,
      message: 'Logged out successfully',
      record: 'Success',
    );
  }

  @override
  Future<ApiResponse> register({
    required RegisterCredentials credentials,
  }) async {
    final useCase = Register(repository: _authRepository);
    final response = await useCase.call(credentials: credentials);

    return response;
  }

  @override
  Future<void> verifyToken() async {
    try {
      final token = await _cache.cachedToken();
      final userDetailsAsMap = await _cache.cachedUser();
      if (token == null) {
        log('AuthDelegate: No token found in cache.');
        _authStateController.sink.add(false);
        _userController.sink.add(null);
        return;
      }
      final isTokenExpired = JwtService.instance.isTokenExpired(token);
      if (isTokenExpired) {
        log('AuthDelegate: Token EXPIRED. Clearing cache.');
        await _cache.deleteToken();
        await _cache.deleteUser();
        _authStateController.sink.add(false);
        _userController.sink.add(null);
        return;
      }

      final isImpersonated = JwtService.instance.isImpersonatedToken(token);
      if (isImpersonated) {
        log(
          '🔒 AuthDelegate: Impersonation token detected on startup ("imp": true). Clearing cache and forcing logout.',
        );
        await _cache.deleteToken();
        await _cache.deleteUser();
        _authStateController.sink.add(false);
        _userController.sink.add(null);
        return;
      }

      if (userDetailsAsMap == null) {
        log(
          'AuthDelegate: Token is valid but userDetails are missing or failed to parse. Session remains unauthenticated.',
        );
        _authStateController.sink.add(false);
        _userController.sink.add(null);
        return;
      }
      final user = User(accessToken: token, details: userDetailsAsMap);
      _authStateController.sink.add(true);
      _userController.sink.add(user);
      log('Verified token and user from cache');
      log('Token: $token');
      log('AuthDelegate: Session verified successfully.');
    } catch (e, s) {
      log('AuthDelegate: CRITICAL error during verifyToken: $e');
      log('Stack trace: $s');
      _authStateController.sink.add(false);
      _userController.sink.add(null);
    }
  }

  @override
  Future<ApiResponse> verifyAccount({
    required VerifyAccountParameters parameters,
  }) async {
    final useCase = VerifyAccount(repository: _userRepository);
    final response = await useCase.call(parameters: parameters);
    return response;
  }

  @override
  Future<void> addFcmToken({required String token}) async {
    if (currentUser == null) {
      return;
    }
    final cachedToken = HiveDatabase.getFcmToken();

    if (cachedToken == token) {
      log('🔁 FCM token already sent to backend, skipping...');
      return;
    }

    if (_registeringToken == token) {
      log('⏳ FCM token registration already in progress, skipping...');
      return;
    }

    _registeringToken = token;
    try {
      final useCase = AddFcmToken(repository: _userRepository);
      await useCase.call(
        parameters: AddFcmTokenParameters(
          token: token,
          platform: defaultTargetPlatform,
        ),
      );
      await HiveDatabase.setFcmToken(token);
      log('✅ FCM token registered and cached successfully');
    } catch (e) {
      log('❌ Error registering FCM token: $e');
    } finally {
      if (_registeringToken == token) {
        _registeringToken = null;
      }
    }
  }

  @override
  Stream<bool> authStateChanges() {
    return _authStateController.stream;
  }

  @override
  Stream<User?> userChanges() {
    return _userController.stream;
  }

  @override
  Future<void> refreshUser({String? childId}) async {
    final user = await FetchUserById(
      repository: _userRepository,
    ).call(childId: childId);
    final userDetails = user.record;
    final token = currentUser!.accessToken;
    final refreshUser = User(accessToken: token, details: userDetails);

    _userController.sink.add(refreshUser);
    try {
      // Keep current user data if it exists
      if (currentUser != null) {
        _userController.sink.add(refreshUser);
        _authStateController.sink.add(true);
      } else {
        _authStateController.sink.add(false);
        _userController.sink.add(null);
      }
    } catch (e, s) {
      log('message$e');
      log('message$s');
      _authStateController.sink.add(false);
      _userController.sink.add(null);
    }
  }

  @override
  Future<void> logoutLocally() async {
    log('Performing Local Logout...');
    try {
      await FirebaseMessaging.instance.deleteToken();
      await FlutterAppBadge.count(0);
      await NotificationUtils.deleteFcmToken();
    } catch (e) {
      log('Error cleaning notification tokens: $e');
    }
    await HiveDatabase.clearFcmToken();
    await _cache.deleteUser();
    await _cache.deleteToken();
    ImpersonationService.clear();
    _authStateController.sink.add(false);
    _userController.sink.add(null);
    log('Local Logout Completed.');
  }

  @override
  Future<void> syncPreferenceFromUser(User user) async {
    final preference = user.details.preference;

    // -------- Language --------
    final backendLang = preference.languageCode;
    final cachedLang = HiveDatabase.getLanguageCode();

    if (backendLang.isNotEmpty && backendLang != cachedLang) {
      log('🌐 Sync language after auth: $backendLang');

      await HiveDatabase.setLanguageCode(backendLang);
      DependencyInjector.languageCubit.changeLanguage(backendLang);
    }

    // -------- Theme --------
    final backendTheme = preference.theme;

    if (backendTheme == 1 || backendTheme == 2) {
      final isDarkFromBackend = backendTheme == 2;
      final cachedTheme = HiveDatabase.getTheme();

      if (cachedTheme != isDarkFromBackend) {
        log(
          '🎨 Sync theme after auth: '
          '${isDarkFromBackend ? "Dark" : "Light"}',
        );

        await HiveDatabase.setTheme(isDarkFromBackend);

        DependencyInjector.themeCubit.setThemeMode(
          isDarkFromBackend ? ThemeMode.dark : ThemeMode.light,
        );
      }
    }
  }

  @override
  bool get canRegisterFcmToken {
    final user = currentUser?.details;
    if (user == null) return false;

    // أهم شرط
    if (!user.emailVerified) return false;

    final token = currentUser?.accessToken;
    if (token == null || token.isEmpty) return false;

    return true;
  }
}
