import '../../../../shared/model/api_response.dart';
import '../entities/parameters/change_password.dart';
import '../repositories/user.dart';

final class ChangePassword {
  const ChangePassword({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse<Map>> changePassword({
    required ChangePasswordParameters parameters,
  }) async {
    return _repository.changePassword(parameters: parameters);
  }
}
