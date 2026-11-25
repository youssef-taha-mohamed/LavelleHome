import '../../../../shared/model/api_response.dart';
import '../entities/otp_confirmation_parameters.dart';
import '../repositories/authentication.dart';

final class ConfirmOtpToResetPassword {
  const ConfirmOtpToResetPassword({required this._repository});

  final AuthenticationBaseRepository _repository;

  Future<ApiResponse<String>> call({
    required OtpConfirmationParameters parameters,
  }) async {
    return _repository.confirmOtpToResetPassword(parameters: parameters);
  }
}
