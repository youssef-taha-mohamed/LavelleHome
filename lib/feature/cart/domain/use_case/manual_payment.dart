import '../../../../shared/model/api_response.dart';
import '../entities/parameter/manual_payment.dart';
import '../repository/repository.dart';

class ManualPaymentUseCase {
  ManualPaymentUseCase({required this._repository});

  final CartBaseRepository _repository;

  Future<ApiResponse<Map>> call({
    required ManualPaymentParameter parameters,
  }) async {
    return _repository.manualPayment(parameters: parameters);
  }
}
