import '../../../../core/constant/endpoint.dart';
import '../../../../core/network/client/base/client.dart';
import '../../../../core/network/response_handler/base/response_handler.dart';
import '../../../../shared/model/api_response.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/logout_params.dart';
import '../../domain/entities/otp_confirmation_parameters.dart';
import '../../domain/entities/register_credentials.dart';
import '../../domain/entities/reset_password_parameters.dart';
import '../../domain/entities/social_media_credentials.dart';
import '../../domain/entities/social_register_credentials.dart';
import '../models/login_credentials.dart';
import '../models/logout_parameters.dart';
import '../models/otp_confirmation_parameters.dart';
import '../models/register_credentials.dart';
import '../models/reset_password_parameters.dart';
import '../models/social_media_credentials.dart';
import '../models/social_register_credentials.dart';
import 'base/data_source.dart';

final class AuthenticationRemoteDataSource implements AuthenticationDataSource {
  const AuthenticationRemoteDataSource({
    required this._client,
    required this._responseHandler,
  });

  final NetworkClient _client;
  final ResponseHandler _responseHandler;

  @override
  Future<ApiResponse<Map<String, dynamic>>> login({
    required LoginCredentials credentials,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.login),
      body: LoginCredentialsDTO.fromEntity(credentials).toMap(),
    );

    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> loginWithSocialMedia({
    required SocialMediaCredentials credentials,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.loginWithSocialMedia),
      body: SocialMediaCredentialsDTO.fromEntity(credentials).toMap(),
    );

    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> registerWithSocialMedia({
    required SocialRegisterCredentials credentials,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.registerWithSocialMedia),
      body: SocialRegisterCredentialsDTO.fromEntity(credentials).toMap()
        ..removeWhere((key, value) => value == null || value == ''),
    );

    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map>> logout({
    required LogoutParameters parameters,
  }) async {
    final response = await _client.put(
      uri: Uri.parse(ApiEndPoint.logout),
      body: LogoutParametersDTO.fromEntity(parameters).toMap(),
    );
    return _responseHandler.handle<ApiResponse<Map>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse> register({
    required RegisterCredentials credentials,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.register),
      body: RegisterCredentialsDTO.fromEntity(credentials).toMap()
        ..removeWhere((key, value) => value == null || value == ''),
    );

    return _responseHandler.handle<ApiResponse>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<String>> confirmOtpToResetPassword({
    required OtpConfirmationParameters parameters,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.confirmOtpToResetPassword),
      body: OtpConfirmationParametersDTO.fromEntity(parameters).toMap(),
    );

    return _responseHandler.handle<ApiResponse<String>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<String>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as String;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map>> resetPassword({
    required ResetPasswordParameters parameters,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.resetPasswordByOtp),
      body: ResetPasswordParametersDTO.fromEntity(parameters).toMap(),
    );

    return _responseHandler.handle<ApiResponse<Map>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map>> sendOtpToResetPassword({
    required String email,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.sendOtpToResetPassword),
      body: {'email': email},
    );

    return _responseHandler.handle<ApiResponse<Map>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> impersonate({
    required String token,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.impersonate(token)),
    );

    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }
}
