import '../../../../shared/model/api_response.dart';
import '../datasource/base/base_datasource.dart';
import '../../domain/entities/app_status.dart';
import '../../domain/repository/repository.dart';
import '../module/app_status.dart';

class SettingRepository implements SettingBaseRepository {
  final SettingBaseDataSource dataSource;
  SettingRepository({required this.dataSource});
  @override
  Future<ApiResponse<AppStatus>> getAppStatus() async {
    final result = await dataSource.getAppStatus();
    return result.map((recordList) {
      return AppStatusDTO.fromMap(recordList);
    });
  }
}
