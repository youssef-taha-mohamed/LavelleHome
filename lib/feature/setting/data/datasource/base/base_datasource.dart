import '../../../../../shared/model/api_response.dart';

abstract interface class SettingBaseDataSource {
  Future<ApiResponse<Map<String, dynamic>>> getAppStatus();
}
