import '../entities/app_status.dart';
import '../../../../shared/model/api_response.dart';
import '../repository/repository.dart';

class GetAppStatusUseCase {
  final SettingBaseRepository repository;
  GetAppStatusUseCase({required this.repository});

  Future<ApiResponse<AppStatus>> call(void params) {
    return repository.getAppStatus();
  }
}
