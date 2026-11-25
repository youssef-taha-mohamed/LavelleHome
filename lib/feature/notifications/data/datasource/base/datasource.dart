import '../../../../../shared/model/api_response.dart';
import '../../../domain/entities/parameter/notification_parameter.dart';
import '../../../domain/entities/parameter/parameter.dart';

abstract interface class NotificationBaseDatasource {
  const NotificationBaseDatasource();

  Future<ApiResponse<Map<String, dynamic>>> list({
    required NotificationListParameter parameters,
  });

  Future<ApiResponse<Map>> read({
    required NotificationParameter parameters,
  });

  Future<ApiResponse<Map>> readAll({
    required NotificationParameter parameters,
  });

  Future<ApiResponse<Map>> delete({
    required NotificationParameter parameters,
  });

  Future<ApiResponse<Map>> clear({
    required NotificationParameter parameters,
  });

  Future<ApiResponse<int>> count({
    required NotificationParameter parameters,
  });

  Future<String?> allowNotification(bool allow);
}
