import '../../../../feature/auth/domain/entities/login_credentials.dart';
import '../../../../feature/auth/domain/entities/register_credentials.dart';
import '../../../../feature/auth/domain/entities/social_media_credentials.dart';
import '../../../../feature/auth/domain/entities/social_register_credentials.dart';
import '../../../../feature/user/domain/entities/parameters/verify_account.dart';
import '../../../../feature/user/domain/entities/user.dart';
import '../../../../shared/model/api_response.dart';

abstract interface class AuthenticationDelegate {
  const AuthenticationDelegate();

  User? get currentUser;

  bool get isAuthenticated;

  bool get canRegisterFcmToken;

  Future<void> init();

  void dispose();

  Future<ApiResponse<User>> login({required LoginCredentials credentials});

  Future<ApiResponse<User>> loginWithSocialMedia({
    required SocialMediaCredentials credentials,
  });

  Future<ApiResponse<User>> registerWithSocialMedia({
    required SocialRegisterCredentials credentials,
  });

  void sinkUser(User user);

  Future<void> saveImpersonatedSession(User user);

  Future<ApiResponse> register({required RegisterCredentials credentials});

  Future<ApiResponse> logout();

  Future<ApiResponse> verifyAccount({
    required VerifyAccountParameters parameters,
  });

  Stream<User?> userChanges();

  Future<void> refreshUser({String? childId});

  Future<void> addFcmToken({required String token});

  Stream<bool> authStateChanges();

  Future<void> verifyToken();

  Future<void> logoutLocally();

  Future<void> syncPreferenceFromUser(User user);
}
