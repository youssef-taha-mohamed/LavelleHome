import '../../../../shared/model/api_response.dart';
import '../entities/payment_info.dart';
import '../repository/repository.dart';

class PaymentMethodsUseCase {
  PaymentMethodsUseCase({required this._repository});
  final CartBaseRepository _repository;
  Future<ApiResponse<PaymentInfo>> call() async {
    return _repository.paymentMethods();
  }
}
