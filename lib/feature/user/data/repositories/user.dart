import '../../../../shared/model/api_response.dart';
import '../../domain/entities/parameters/add_fcm_token.dart';
import '../../domain/entities/parameters/change_email_para.dart';
import '../../domain/entities/parameters/change_password.dart';
import '../../domain/entities/parameters/update_preference.dart';
import '../../domain/entities/parameters/verify_account.dart';
import '../../domain/entities/preference_model.dart';
import '../../domain/entities/profile_modification_data.dart';
import '../../domain/entities/user_details.dart';
import '../../domain/enums/admin_setting.dart';
import '../../domain/repositories/user.dart';
import '../data_sources/base/data_source.dart';
import '../models/user_details.dart';

final class UserRepository implements UserBaseRepository {
  const UserRepository({required this._dataSource});

  final UserDataSource _dataSource;

  @override
  Future<ApiResponse<Map>> addFcmToken({
    required AddFcmTokenParameters parameters,
  }) async {
    final result = await _dataSource.addFcmToken(parameters: parameters);
    return result.map((recordMap) {
      return recordMap;
    });
  }

  @override
  Future<ApiResponse<Map>> delete({required String childId}) async {
    return await _dataSource.deleteAccount(childId: childId);
  }

  @override
  Future<ApiResponse<Map>> resendOtp({required String email}) async {
    final result = await _dataSource.resendOtp(email: email);

    return result.map((recordMap) {
      return recordMap;
    });
  }

  @override
  Future<ApiResponse<UserDetails>> userById({String? childId}) async {
    final result = await _dataSource.userById(childId: childId);
    return result.map((recordMap) {
      return UserDetailsDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<UserDetails>> update({
    required ProfileModificationData data,
  }) async {
    final result = await _dataSource.update(data: data);
    return result.map((recordMap) {
      return UserDetailsDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<Map>> toggleNotification() async {
    return await _dataSource.toggleNotification();
  }

  @override
  Future<ApiResponse> verifyAccount({
    required VerifyAccountParameters parameters,
  }) async {
    final result = await _dataSource.verifyAccount(parameters: parameters);

    return result;
  }

  @override
  Future<ApiResponse> changeEmail({
    required ChangeEmailParameters parameters,
  }) async {
    final result = await _dataSource.changeEmail(parameters: parameters);

    return result;
  }

  @override
  Future<ApiResponse<Map>> changePassword({
    required ChangePasswordParameters parameters,
  }) async {
    final result = await _dataSource.changePassword(parameters: parameters);

    return result;
  }

  @override
  Future<ApiResponse> confirmChangeEmail({
    required ChangeEmailParameters parameters,
  }) async {
    final result = await _dataSource.confirmChangeEmail(parameters: parameters);
    return result;
  }

  @override
  Future<ApiResponse<PreferenceModel>> getPreference({String? childId}) async {
    final result = await _dataSource.getPreference(childId: childId);
    return result.map((recordMap) {
      return PreferenceModelDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<Map<dynamic, dynamic>>> updatePreference({
    required UpdatePreference data,
  }) async {
    final result = await _dataSource.updatePreference(data: data);
    return result;
  }

  @override
  Future<ApiResponse<int>> appSettings({
    required AdminSettingsEnum adminSettingsEnum,
  }) async {
    return await _dataSource.appSettings(adminSettingsEnum: adminSettingsEnum);
  }
}
