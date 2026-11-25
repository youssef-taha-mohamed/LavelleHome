import '../../../../shared/model/api_response.dart';
import '../entities/register_credentials.dart';
import '../repositories/authentication.dart';

final class Register {
  const Register({required this._repository});

  final AuthenticationBaseRepository _repository;

  Future<ApiResponse> call({required RegisterCredentials credentials}) async {
    return _repository.register(credentials: credentials);
  }
}
