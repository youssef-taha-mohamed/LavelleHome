import '../../../../shared/model/api_response.dart';
import '../entities/reset_password_parameters.dart';
import '../repositories/authentication.dart';

final class ResetPassword {
  const ResetPassword({required this._repository});

  final AuthenticationBaseRepository _repository;

  Future<ApiResponse<Map>> call({
    required ResetPasswordParameters parameters,
  }) async {
    return _repository.resetPassword(parameters: parameters);
  }
}
