import '../../../../shared/model/api_response.dart';
import '../entities/notification_modal.dart';
import '../entities/parameter/notification_parameter.dart';
import '../repository/repository.dart';

final class NotificationsUseCase {
  NotificationsUseCase({required this._repository});

  final NotificationBaseRepository _repository;

  Future<ApiResponse<NotificationsApp>> call({
    required NotificationListParameter parameters,
  }) async {
    return _repository.list(parameters: parameters);
  }
}
