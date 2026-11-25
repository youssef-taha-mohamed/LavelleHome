import '../../../../../shared/model/api_response.dart';
import '../../../domain/entities/login_credentials.dart';
import '../../../domain/entities/logout_params.dart';
import '../../../domain/entities/otp_confirmation_parameters.dart';
import '../../../domain/entities/register_credentials.dart';
import '../../../domain/entities/reset_password_parameters.dart';
import '../../../domain/entities/social_media_credentials.dart';
import '../../../domain/entities/social_register_credentials.dart';

abstract interface class AuthenticationDataSource {
  const AuthenticationDataSource();

  Future<ApiResponse<String>> confirmOtpToResetPassword({
    required OtpConfirmationParameters parameters,
  });

  Future<ApiResponse<Map<String, dynamic>>> login({
    required LoginCredentials credentials,
  });

  Future<ApiResponse<Map<String, dynamic>>> loginWithSocialMedia({
    required SocialMediaCredentials credentials,
  });

  Future<ApiResponse<Map<String, dynamic>>> registerWithSocialMedia({
    required SocialRegisterCredentials credentials,
  });

  Future<ApiResponse<Map>> logout({
    required LogoutParameters parameters,
  });

  Future<ApiResponse> register({
    required RegisterCredentials credentials,
  });

  Future<ApiResponse<Map>> sendOtpToResetPassword({
    required String email,
  });

  Future<ApiResponse<Map>> resetPassword({
    required ResetPasswordParameters parameters,
  });


  Future<ApiResponse<Map<String, dynamic>>> impersonate({
    required String token,
  });
}
