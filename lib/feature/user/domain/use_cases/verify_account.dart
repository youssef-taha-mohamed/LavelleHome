import '../../../../shared/model/api_response.dart';
import '../entities/parameters/verify_account.dart';
import '../repositories/user.dart';

final class VerifyAccount {
  const VerifyAccount({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse> call({required VerifyAccountParameters parameters}) {
    return _repository.verifyAccount(parameters: parameters);
  }
}
