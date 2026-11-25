import '../../../../shared/model/api_response.dart';
import '../entities/parameter/parameter.dart';
import '../repository/repository.dart';

final class ClearUseCase {
  ClearUseCase({required this._repository});

  final NotificationBaseRepository _repository;

  Future<ApiResponse<Map>> call({
    required NotificationParameter parameters,
  }) async {
    return _repository.clear(parameters: parameters);
  }
}
