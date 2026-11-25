import '../../../../shared/model/api_response.dart';
import '../repositories/authentication.dart';

final class SendOtpToResetPassword {
  const SendOtpToResetPassword({required this._repository});

  final AuthenticationBaseRepository _repository;

  Future<ApiResponse<Map>> call({required String email}) async {
    return _repository.sendOtpToResetPassword(email: email);
  }
}
