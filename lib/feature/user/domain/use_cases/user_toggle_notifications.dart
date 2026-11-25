import '../../../../shared/model/api_response.dart';
import '../repositories/user.dart';

final class UserToggleNotification {
  UserToggleNotification({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse> call() async {
    return _repository.toggleNotification();
  }
}
