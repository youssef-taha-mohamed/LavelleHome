import 'dart:async';
import '../../../../../shared/model/api_response.dart';
import '../../../domain/entities/parameters/add_fcm_token.dart';
import '../../../domain/entities/parameters/change_email_para.dart';
import '../../../domain/entities/parameters/change_password.dart';
import '../../../domain/entities/parameters/update_preference.dart';
import '../../../domain/entities/parameters/verify_account.dart';
import '../../../domain/entities/profile_modification_data.dart';
import '../../../domain/enums/admin_setting.dart';

abstract interface class UserDataSource {
  const UserDataSource();

  Future<ApiResponse<Map>> addFcmToken({
    required AddFcmTokenParameters parameters,
  });

  Future<ApiResponse<Map>> deleteAccount({required String childId});

  Future<ApiResponse<Map>> resendOtp({required String email});

  Future<ApiResponse<Map<String, dynamic>>> userById({
    String? childId,
  });

  Future<ApiResponse<Map<String, dynamic>>> update({
    required ProfileModificationData data,
  });

  Future<ApiResponse> verifyAccount({
    required VerifyAccountParameters parameters,
  });

  Future<ApiResponse<Map>> toggleNotification();

  Future<ApiResponse> changeEmail({
    required ChangeEmailParameters parameters,
  });

  Future<ApiResponse> confirmChangeEmail({
    required ChangeEmailParameters parameters,
  });

  Future<ApiResponse<Map>> changePassword({
    required ChangePasswordParameters parameters,
  });

  Future<ApiResponse<Map>> updatePreference({
    required UpdatePreference data,
  });

  Future<ApiResponse<Map<String, dynamic>>> getPreference({String? childId});

  Future<ApiResponse<int>> appSettings({
    required AdminSettingsEnum adminSettingsEnum,
  });
}
