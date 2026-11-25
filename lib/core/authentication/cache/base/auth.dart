import '../../../../feature/user/domain/entities/user_details.dart';

abstract interface class AuthenticationCache {
  const AuthenticationCache();
  Future<void> init();

  Future<void> cacheToken({required String token});

  Future<String?> cachedToken();

  Future<void> deleteToken();

  Future<void> cachUser({required UserDetails user});

  Future<UserDetails?> cachedUser();

  Future<void> deleteUser();

}