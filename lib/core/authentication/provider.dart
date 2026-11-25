import '../../feature/auth/domain/entities/login_credentials.dart';
import '../../feature/auth/domain/entities/register_credentials.dart';
import '../../feature/auth/domain/entities/social_media_credentials.dart';
import '../../feature/auth/domain/entities/social_register_credentials.dart';
import '../../feature/user/domain/entities/parameters/verify_account.dart';
import '../../feature/user/domain/entities/user.dart';
import '../../shared/model/api_response.dart';
import 'delegates/base/authentication.dart';

final class AuthenticationProvider implements AuthenticationDelegate {
  AuthenticationProvider._();

  bool isVerify = false;

  static AuthenticationProvider get instance {
    if (!_delegateHasInit) {
      throw Exception('''
\n
          AuthenticationProvider has not been initialized.
          You Must called "AuthenticationProvider.injectDelegate" first.
        ''');
    }
    return AuthenticationProvider._();
  }

  static bool get isAuth => _delegate.isAuthenticated;

  static User? get user => _delegate.currentUser;
  static late AuthenticationDelegate _delegate;
  static bool _delegateHasInit = false;

  static void injectDelegate({required AuthenticationDelegate delegate}) {
    if (delegate is AuthenticationProvider) {
      throw Exception('Cannot inject AuthenticationProvider as delegate');
    }

    _delegate = delegate;
    _delegateHasInit = true;
  }

  // @override
  // Stream<User?> authStateChanges() {
  //   return _delegate.authStateChanges();
  // }
  @override
  bool get canRegisterFcmToken => _delegate.canRegisterFcmToken;

  @override
  bool get isAuthenticated => _delegate.isAuthenticated;

  @override
  User? get currentUser => _delegate.currentUser;

  @override
  Stream<bool> authStateChanges() {
    return _delegate.authStateChanges();
  }

  @override
  Stream<User?> userChanges() {
    return _delegate.userChanges();
  }

  @override
  Future<void> init() {
    return _delegate.init();
  }

  @override
  void dispose() {
    return _delegate.dispose();
  }

  @override
  Future<ApiResponse<User>> login({required LoginCredentials credentials}) {
    return _delegate.login(credentials: credentials);
  }

  @override
  Future<ApiResponse<User>> loginWithSocialMedia({
    required SocialMediaCredentials credentials,
  }) {
    return _delegate.loginWithSocialMedia(credentials: credentials);
  }

  @override
  Future<ApiResponse<User>> registerWithSocialMedia({
    required SocialRegisterCredentials credentials,
  }) {
    return _delegate.registerWithSocialMedia(credentials: credentials);
  }

  @override
  Future<ApiResponse> logout() {
    return _delegate.logout();
  }

  @override
  Future<ApiResponse> register({required RegisterCredentials credentials}) {
    return _delegate.register(credentials: credentials);
  }

  @override
  Future<ApiResponse> verifyAccount({
    required VerifyAccountParameters parameters,
  }) {
    return _delegate.verifyAccount(parameters: parameters);
  }

  @override
  Future<void> verifyToken() {
    isVerify = true;
    return _delegate.verifyToken()..then((value) => isVerify = false);
  }

  @override
  Future<void> refreshUser({String? childId}) {
    return _delegate.refreshUser(childId: childId);
  }

  @override
  Future<void> addFcmToken({required String token}) {
    return _delegate.addFcmToken(token: token);
  }

  @override
  Future<void> saveImpersonatedSession(User user) {
    return _delegate.saveImpersonatedSession(user);
  }

  @override
  void sinkUser(User user) {
    return _delegate.sinkUser(user);
  }

  @override
  Future<void> logoutLocally() {
    return _delegate.logoutLocally();
  }

  @override
  Future<void> syncPreferenceFromUser(User user) {
    return _delegate.syncPreferenceFromUser(user);
  }
}
