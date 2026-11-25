import '../../../../shared/model/api_response.dart';
import '../entities/parameters/change_email_para.dart';
import '../repositories/user.dart';

final class ChangeEmail {
  const ChangeEmail({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse> call({required ChangeEmailParameters parameters}) async {
    return _repository.changeEmail(parameters: parameters);
  }
}
