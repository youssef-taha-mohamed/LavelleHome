import '../../../../shared/model/api_response.dart';
import '../entities/parameter/parameter.dart';
import '../repository/repository.dart';

final class FetchNotificationsCount {
  FetchNotificationsCount({required this._repository});

  final NotificationBaseRepository _repository;

  Future<ApiResponse<int>> call({
    required NotificationParameter parameters,
  }) async {
    return _repository.count(parameters: parameters);
  }
}
