import '../../../../shared/model/api_response.dart';
import '../entities/notification_modal.dart';
import '../entities/parameter/notification_parameter.dart';
import '../entities/parameter/parameter.dart';

abstract interface class NotificationBaseRepository {
  const NotificationBaseRepository();

  Future<ApiResponse<NotificationsApp>> list({
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
