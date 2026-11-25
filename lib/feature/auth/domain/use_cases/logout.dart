import '../../../../shared/model/api_response.dart';
import '../entities/logout_params.dart';
import '../repositories/authentication.dart';

final class Logout {
  const Logout({required this._repository});

  final AuthenticationBaseRepository _repository;

  Future<ApiResponse<Map>> call({required LogoutParameters parameters}) async {
    return _repository.logout(parameters: parameters);
  }
}
