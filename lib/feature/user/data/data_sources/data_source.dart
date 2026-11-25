import 'dart:io';
import 'dart:typed_data';
import '../../../../core/constant/endpoint.dart';
import '../../../../core/network/client/base/client.dart';
import '../../../../core/network/response_handler/base/response_handler.dart';
import '../../../../shared/model/api_response.dart';
import '../../domain/entities/parameters/add_fcm_token.dart';
import '../../domain/entities/parameters/change_email_para.dart';
import '../../domain/entities/parameters/change_password.dart';
import '../../domain/entities/parameters/update_preference.dart';
import '../../domain/entities/parameters/verify_account.dart';
import '../../domain/entities/profile_modification_data.dart';
import '../../domain/enums/admin_setting.dart';
import '../../domain/enums/field.dart';
import '../models/parameters/add_fcm_token.dart';
import '../models/parameters/change_email.dart';
import '../models/parameters/change_password.dart';
import '../models/parameters/update_preference.dart';
import '../models/parameters/verify_account.dart';
import '../models/profile_modification_data.dart';
import 'base/data_source.dart';

final class UserRemoteDataSource implements UserDataSource {
  UserRemoteDataSource({required this._client, required this._responseHandler});
  final NetworkClient _client;
  final ResponseHandler _responseHandler;

  @override
  Future<ApiResponse<Map>> addFcmToken({
    required AddFcmTokenParameters parameters,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.addFcmToken),
      body: AddFcmTokenParametersDTO.fromEntity(parameters).toMap(),
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
  Future<ApiResponse<Map>> deleteAccount({required String childId}) async {
    final response = await _client.delete(
      uri: Uri.parse(ApiEndPoint.delete),
      body: childId.isNotEmpty ? {'childId': childId} : {},
    );

    return _responseHandler.handle<ApiResponse<Map>>(
      response: response,
      expectedCases: [200, 202, 201],
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
  Future<ApiResponse<Map>> resendOtp({required String email}) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.resendOtp),
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
  Future<ApiResponse<Map<String, dynamic>>> userById({String? childId}) async {
    final response = await _client.get(
      uri: Uri.parse(ApiEndPoint.userById(childId)),
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
  Future<ApiResponse<Map<String, dynamic>>> update({
    required ProfileModificationData data,
  }) async {
    final dto = ProfileModificationDataDTO.fromEntity(data);

    // Read image bytes from path (mobile) or use bytes directly (web)
    final Uint8List? bytes;
    if (data.imageBytes != null) {
      bytes = data.imageBytes;
    } else if (data.imagePath != null) {
      bytes = await File(data.imagePath!).readAsBytes();
    } else {
      bytes = null;
    }

    final response = await _client.putMultipart(
      uri: Uri.parse(ApiEndPoint.updateProfile),
      fields: dto.toFormFields(),
      fileBytes: bytes,
      fileName: data.imageName ?? 'profile.jpg',
      fileFieldName: UserField.image.value,
    );

    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200, 202],
      expectedCasesHandler: (jsonBody, statusCode) {
        return ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) => recordJson as Map<String, dynamic>,
        );
      },
    );
  }
  @override
  Future<ApiResponse> verifyAccount({
    required VerifyAccountParameters parameters,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.verifyAccount),
      body: VerifyAccountParametersDTO.fromEntity(parameters).toMap(),
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
  Future<ApiResponse<Map>> toggleNotification({String? childId}) async {
    final response = await _client.put(
      uri: Uri.parse(ApiEndPoint.toggleNotification),
      body: childId != null && childId.isNotEmpty ? {'childId': childId} : {},
    );

    return _responseHandler.handle<ApiResponse<Map>>(
      response: response,
      expectedCases: [200, 201, 202],
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
  Future<ApiResponse> changeEmail({
    required ChangeEmailParameters parameters,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.changeEmail),
      body: ChangeEmailParametersDTO.fromEntity(parameters).toMap(),
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
  Future<ApiResponse<Map>> changePassword({
    required ChangePasswordParameters parameters,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.changePassword),
      body: ChangePasswordParametersDTO.fromEntity(parameters).toMap(),
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
  Future<ApiResponse> confirmChangeEmail({
    required ChangeEmailParameters parameters,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.confirmChangeEmail),
      body: ChangeEmailParametersDTO.fromEntity(parameters).toMap(),
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
  Future<ApiResponse<Map<String, dynamic>>> getPreference({
    String? childId,
  }) async {
    final uri = Uri.parse(
      childId != null && childId.isNotEmpty
          ? ApiEndPoint.getPreference(childId)
          : ApiEndPoint.getPreference(null),
    );

    final response = await _client.get(uri: uri);

    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        return ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
      },
    );
  }

  @override
  Future<ApiResponse<Map>> updatePreference({
    required UpdatePreference data,
  }) async {
    final response = await _client.put(
      uri: Uri.parse(ApiEndPoint.updatePreference),
      body: UpdatePreferenceDTO.fromEntity(data).toMap(),
    );
    return _responseHandler.handle<ApiResponse<Map>>(
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
  Future<ApiResponse<int>> appSettings({
    required AdminSettingsEnum adminSettingsEnum,
  }) async {
    final response = await _client.get(
      uri: Uri.parse(ApiEndPoint.appSettings(adminSettingsEnum)),
    );
    return _responseHandler.handle<ApiResponse<int>>(
      response: response,
      expectedCases: [200, 201, 202],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<int>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as int;
          },
        );
        return apiResponse;
      },
    );
  }
}
