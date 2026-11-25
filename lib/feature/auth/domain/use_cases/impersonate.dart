import '../../../../shared/model/api_response.dart';
import '../entities/impersonate_result.dart';
import '../repositories/authentication.dart';

final class Impersonate {
  const Impersonate({required this._repository});

  final AuthenticationBaseRepository _repository;

  Future<ApiResponse<ImpersonateResult>> call({required String token}) async {
    return _repository.impersonate(token: token);
  }
}
