import '../../../../shared/model/api_response.dart';
import '../enums/admin_setting.dart';
import '../repositories/user.dart';

class AdminSettingUseCase {
  const AdminSettingUseCase({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse<int>> call({
    required AdminSettingsEnum adminSettingsEnum,
  }) {
    return _repository.appSettings(adminSettingsEnum: adminSettingsEnum);
  }
}
