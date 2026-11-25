import '../../../../shared/model/api_response.dart';
import '../repositories/user.dart';

final class ResendOtp {
  const ResendOtp({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse<Map>> call({required String email}) {
    return _repository.resendOtp(email: email);
  }
}
