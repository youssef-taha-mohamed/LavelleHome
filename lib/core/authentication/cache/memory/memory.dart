import 'dart:developer';
import '../../../../feature/user/domain/entities/user_details.dart';
import '../base/auth.dart';

final class MemoryAuthenticationCache implements AuthenticationCache {
  MemoryAuthenticationCache();

  String? _token;
  UserDetails? _user;

  @override
  Future<void> cacheToken({
    required String token,
  }) async {
    _token = token;
  }

  @override
  Future<String?> cachedToken() async {
    return _token;
  }

  @override
  Future<void> deleteToken() async {
    _token = null;
  }

  @override
  Future<void> init() async {
    log('MemoryAuthenticationCache initialized  haha 😉');
  }

  @override
  Future<void> cachUser({required UserDetails user}) async {
    _user = user;
  }

  @override
  Future<UserDetails?> cachedUser() async {
    return _user;
  }

  @override
  Future<void> deleteUser() async {
    _user = null;
  }
}
