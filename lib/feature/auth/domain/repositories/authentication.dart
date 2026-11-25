import '../../../../shared/model/api_response.dart';
import '../../../user/domain/entities/user.dart';
import '../entities/impersonate_result.dart';
import '../entities/login_credentials.dart';
import '../entities/logout_params.dart';
import '../entities/otp_confirmation_parameters.dart';
import '../entities/register_credentials.dart';
import '../entities/reset_password_parameters.dart';
import '../entities/social_media_credentials.dart';
import '../entities/social_register_credentials.dart';

abstract interface class AuthenticationBaseRepository {
  const AuthenticationBaseRepository();

  Future<ApiResponse<String>> confirmOtpToResetPassword({
    required OtpConfirmationParameters parameters,
  });

  Future<ApiResponse<User>> login({required LoginCredentials credentials});

  Future<ApiResponse<User>> loginWithSocialMedia({
    required SocialMediaCredentials credentials,
  });

  Future<ApiResponse<User>> registerWithSocialMedia({
    required SocialRegisterCredentials credentials,
  });

  Future<ApiResponse<Map>> logout({required LogoutParameters parameters});

  Future<ApiResponse<Map>> sendOtpToResetPassword({required String email});

  Future<ApiResponse> register({required RegisterCredentials credentials});

  Future<ApiResponse<Map>> resetPassword({
    required ResetPasswordParameters parameters,
  });

  Future<ApiResponse<ImpersonateResult>> impersonate({required String token});
}
