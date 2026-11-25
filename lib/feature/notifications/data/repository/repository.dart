import '../../../../shared/model/api_response.dart';
import '../../domain/entities/notification_modal.dart';
import '../../domain/entities/parameter/notification_parameter.dart';
import '../../domain/entities/parameter/parameter.dart';
import '../../domain/repository/repository.dart';
import '../datasource/base/datasource.dart';
import '../model/notification_modal.dart';

class NotificationRepository implements NotificationBaseRepository {
  final NotificationBaseDatasource _datasource;

  const NotificationRepository({required this._datasource});

  @override
  Future<String?> allowNotification(bool allow) {
    return _datasource.allowNotification(allow);
  }

  @override
  Future<ApiResponse<Map>> clear({
    required NotificationParameter parameters,
  }) async {
    final result = await _datasource.clear(parameters: parameters);
    return result;
  }

  @override
  Future<ApiResponse<int>> count({
    required NotificationParameter parameters,
  }) async {
    final result = await _datasource.count(parameters: parameters);
    return result;
  }

  @override
  Future<ApiResponse<Map>> delete({
    required NotificationParameter parameters,
  }) async {
    final result = await _datasource.delete(parameters: parameters);
    return result;
  }

  @override
  Future<ApiResponse<NotificationsApp>> list({
    required NotificationListParameter parameters,
  }) async {
    final result = await _datasource.list(parameters: parameters);
    return result.map((recordList) {
      return NotificationsAppDTO.fromMap(recordList);
    });
  }

  @override
  Future<ApiResponse<Map>> read({
    required NotificationParameter parameters,
  }) async {
    final result = await _datasource.read(parameters: parameters);
    return result;
  }

  @override
  Future<ApiResponse<Map>> readAll({
    required NotificationParameter parameters,
  }) async {
    final result = await _datasource.readAll(parameters: parameters);
    return result;
  }
}
