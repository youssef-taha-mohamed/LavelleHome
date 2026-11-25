import '../../../../shared/model/api_response.dart';
import '../../../user/data/models/user.dart';
import '../../../user/domain/entities/user.dart';
import '../../domain/entities/impersonate_result.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/logout_params.dart';
import '../../domain/entities/otp_confirmation_parameters.dart';
import '../../domain/entities/register_credentials.dart';
import '../../domain/entities/reset_password_parameters.dart';
import '../../domain/entities/social_media_credentials.dart';
import '../../domain/entities/social_register_credentials.dart';
import '../../domain/repositories/authentication.dart';
import '../data_sources/base/data_source.dart';
import '../models/impersonate_result.dart' show ImpersonateResultDTO;

final class AuthenticationRepository implements AuthenticationBaseRepository {
  const AuthenticationRepository({required this._dataSource});

  final AuthenticationDataSource _dataSource;

  @override
  Future<ApiResponse<String>> confirmOtpToResetPassword({
    required OtpConfirmationParameters parameters,
  }) async {
    final result = await _dataSource.confirmOtpToResetPassword(
      parameters: parameters,
    );
    return result.map((recordMap) {
      return recordMap;
    });
  }

  @override
  Future<ApiResponse<User>> login({
    required LoginCredentials credentials,
  }) async {
    final result = await _dataSource.login(credentials: credentials);
    return result.map((recordMap) {
      return UserDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<User>> loginWithSocialMedia({
    required SocialMediaCredentials credentials,
  }) async {
    final result = await _dataSource.loginWithSocialMedia(
      credentials: credentials,
    );
    return result.map((recordMap) {
      return UserDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<User>> registerWithSocialMedia({
    required SocialRegisterCredentials credentials,
  }) async {
    final result = await _dataSource.registerWithSocialMedia(
      credentials: credentials,
    );
    return result.map((recordMap) {
      return UserDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<Map>> logout({required LogoutParameters parameters}) {
    return _dataSource.logout(parameters: parameters);
  }

  @override
  Future<ApiResponse> register({
    required RegisterCredentials credentials,
  }) async {
    final result = await _dataSource.register(credentials: credentials);

    return result;
  }

  @override
  Future<ApiResponse<Map>> sendOtpToResetPassword({
    required String email,
  }) async {
    final result = await _dataSource.sendOtpToResetPassword(email: email);
    return result.map((recordMap) {
      return recordMap;
    });
  }

  @override
  Future<ApiResponse<Map>> resetPassword({
    required ResetPasswordParameters parameters,
  }) async {
    final result = await _dataSource.resetPassword(parameters: parameters);

    return result.map((recordMap) {
      return recordMap;
    });
  }

  @override
  Future<ApiResponse<ImpersonateResult>> impersonate({
    required String token,
  }) async {
    final result = await _dataSource.impersonate(token: token);
    return result.map((recordMap) {
      return ImpersonateResultDTO.fromMap(recordMap);
    });
  }
}
