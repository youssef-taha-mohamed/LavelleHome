part of 'social_login_cubit.dart';

enum SocialLoginStatus {
  initial,
  loading,
  loginSuccess, // اليوزر موجود ← افتح الـ dashboard
  needsRegistration, // مش مسجل ← افتح الـ form
  error,
}

extension SocialLoginStateX on SocialLoginState {
  bool get isInitial => status == SocialLoginStatus.initial;
  bool get isLoading => status == SocialLoginStatus.loading;
  bool get isLoginSuccess => status == SocialLoginStatus.loginSuccess;
  bool get isNeedsReg => status == SocialLoginStatus.needsRegistration;
  bool get isError => status == SocialLoginStatus.error;
}

class SocialLoginState extends Equatable {
  final SocialLoginStatus status;
  final String? errorMessage;

  // ✅ حالة النجاح
  final User? user;

  // ❌ حالة التسجيل
  final String? token;
  final SocialMediaAuthentication? socialMedia;
  final String? emailFromProvider;
  final String? fullNameFromProvider;

  const SocialLoginState({
    this.status = SocialLoginStatus.initial,
    this.errorMessage,
    this.user,
    this.token,
    this.socialMedia,
    this.emailFromProvider,
    this.fullNameFromProvider,
  });

  SocialLoginState copyWith({
    SocialLoginStatus? status,
    String? errorMessage,
    User? user,
    String? token,
    SocialMediaAuthentication? socialMedia,
    String? emailFromProvider,
    String? fullNameFromProvider,
  }) {
    return SocialLoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      token: token ?? this.token,
      socialMedia: socialMedia ?? this.socialMedia,
      emailFromProvider: emailFromProvider ?? this.emailFromProvider,
      fullNameFromProvider: fullNameFromProvider ?? this.fullNameFromProvider,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        user,
        token,
        socialMedia,
        emailFromProvider,
        fullNameFromProvider,
      ];
}
