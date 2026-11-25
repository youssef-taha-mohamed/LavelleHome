import '../../../../shared/model/api_response.dart';
import '../entities/app_status.dart';

abstract interface class SettingBaseRepository {
  Future<ApiResponse<AppStatus>> getAppStatus();
}
