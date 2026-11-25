import 'dart:async';
import 'dart:developer';
import 'package:hive/hive.dart';
import '../../../../feature/user/data/models/user_details.dart';
import '../../../../feature/user/domain/entities/user_details.dart';
import '../base/auth.dart';

final class HiveAuthenticationCache implements AuthenticationCache {
  HiveAuthenticationCache._internal();

  factory HiveAuthenticationCache() => _singleton;

  static final _singleton = HiveAuthenticationCache._internal();
  final _initCompleter = Completer<void>();

  Box<String>? _boxInstance;
  Box<String>? _userBoxInstance;

  Future<Box<String>> get _box async {
    if (!_initCompleter.isCompleted) {
      await init();
    }
    await _initCompleter.future;
    return _boxInstance!;
  }

  Future<Box<String>> get _userBox async {
    if (!_initCompleter.isCompleted) {
      await init();
    }
    await _initCompleter.future;
    return _userBoxInstance!;
  }

  static final _boxName = 'auth_cache';
  static final _tokenKey = 'api_token';
  static final _userKey = 'user';
  static final _userBoxName = 'user_cache';

  @override
  Future<void> init() async {
    if (_initCompleter.isCompleted) return;
    try {
      // 🛡️ Ensure boxes are not re-opened if they are already active
      if (!Hive.isBoxOpen(_boxName)) {
        _boxInstance = await Hive.openBox<String>(_boxName);
      } else {
        _boxInstance = Hive.box<String>(_boxName);
      }

      if (!Hive.isBoxOpen(_userBoxName)) {
        _userBoxInstance = await Hive.openBox<String>(_userBoxName);
      } else {
        _userBoxInstance = Hive.box<String>(_userBoxName);
      }
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    } catch (e, s) {
      log('HiveAuthCache: Critical error during init: $e');
      log('Stack trace: $s');
      // Complete with error to prevent permanent hanging
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e, s);
      }
    }
  }

  @override
  Future<void> cacheToken({required String token}) async {
    final b = await _box;
    log('Caching token: $token');
    await b.put(_tokenKey, token);
    // Verify the token was cached
    final storedToken = await cachedToken();
    log('Verified cached token: $storedToken');
  }

  @override
  Future<String?> cachedToken() async {
    final b = await _box;
    final token = b.get(_tokenKey);
    if (token == null) {
      log(
        'HiveAuthCache: Failed to retrieve token. Box is empty for key: $_tokenKey',
      );
    } else {
      log('HiveAuthCache: Successfully retrieved token from cache.');
    }
    return token;
  }

  @override
  Future<void> deleteToken() async {
    final b = await _box;
    log('HiveAuthCache: Deleting token from cache...');
    await b.delete(_tokenKey);
    // Verify the token was deleted
    final storedToken = await cachedToken();
    log('Verified token deletion: $storedToken');
  }

  @override
  Future<void> cachUser({required UserDetails user}) async {
    final ub = await _userBox;
    try {
      final userDto = UserDetailsDTO.fromEntity(user);
      final userJson = userDto.toJson();
      log('HiveAuthCache: Caching user data: $userJson');
      await ub.put(_userKey, userJson);
    } catch (e, s) {
      log('HiveAuthCache: Error caching user: $e');
      log('Stack trace: $s');
    }
  }

  @override
  Future<UserDetails?> cachedUser() async {
    final ub = await _userBox;
    try {
      final userJson = ub.get(_userKey);
      if (userJson == null) {
        log(
          'HiveAuthCache: Failed to retrieve user JSON. Box is empty for key: $_userKey',
        );
        return null;
      }
      log(
        'HiveAuthCache: Retrieved user JSON from cache. Length: ${userJson.length}',
      );

      final userDetails = UserDetailsDTO.fromJson(userJson);
      log('HiveAuthCache: Successfully parsed UserDetailsDTO from JSON.');
      return userDetails;
    } catch (e, s) {
      log('HiveAuthCache: Error retrieving or parsing user from cache: $e');
      log('Stack trace: $s');
      return null;
    }
  }

  @override
  Future<void> deleteUser() async {
    final ub = await _userBox;
    log('Deleting user from cache');
    await ub.delete(_userKey);
    // Verify the user was deleted
    final storedUser = await cachedUser();
    if (storedUser != null) {
      final storedDto = UserDetailsDTO.fromEntity(storedUser);
      log('Verified user deletion: ${storedDto.toJson()}');
    } else {
      log('Verified user deletion: null');
    }
  }
}
