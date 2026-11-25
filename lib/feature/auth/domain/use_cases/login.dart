import '../../../../shared/model/api_response.dart';
import '../../../user/domain/entities/user.dart';
import '../entities/login_credentials.dart';
import '../repositories/authentication.dart';

final class Login {
  const Login({required this._repository});

  final AuthenticationBaseRepository _repository;

  Future<ApiResponse<User>> call({
    required LoginCredentials credentials,
  }) async {
    return _repository.login(credentials: credentials);
  }
}
