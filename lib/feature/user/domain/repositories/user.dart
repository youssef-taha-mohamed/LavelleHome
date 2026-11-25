import '../../../../shared/model/api_response.dart';
import '../entities/parameters/add_fcm_token.dart';
import '../entities/parameters/change_email_para.dart';
import '../entities/parameters/change_password.dart';
import '../entities/parameters/update_preference.dart';
import '../entities/parameters/verify_account.dart';
import '../entities/preference_model.dart';
import '../entities/profile_modification_data.dart';
import '../entities/user_details.dart';
import '../enums/admin_setting.dart';

abstract interface class UserBaseRepository {
  const UserBaseRepository();

  Future<ApiResponse<Map>> addFcmToken({
    required AddFcmTokenParameters parameters,
  });

  Future<ApiResponse<Map>> delete({required String childId});

  Future<ApiResponse> changeEmail({
    required ChangeEmailParameters parameters,
  });

  Future<ApiResponse> confirmChangeEmail({
    required ChangeEmailParameters parameters,
  });

  Future<ApiResponse<Map>> changePassword({
    required ChangePasswordParameters parameters,
  });

  Future<ApiResponse<Map>> resendOtp({required String email});

  Future<ApiResponse<Map>> toggleNotification();

  Future<ApiResponse<UserDetails>> update({
    required ProfileModificationData data,
  });

  Future<ApiResponse<UserDetails>> userById({
    String? childId,
  });

  Future<ApiResponse> verifyAccount({
    required VerifyAccountParameters parameters,
  });

  Future<ApiResponse<Map>> updatePreference({
    required UpdatePreference data,
  });

  Future<ApiResponse<PreferenceModel>> getPreference({String? childId});

  Future<ApiResponse<int>> appSettings({
    required AdminSettingsEnum adminSettingsEnum,
  });
}
