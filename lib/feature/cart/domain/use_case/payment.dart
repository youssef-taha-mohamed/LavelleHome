import '../../../../shared/model/api_response.dart';
import '../../data/module/parameter/payment_parameter.dart';
import '../entities/parameter/subscription_parameter.dart';
import '../repository/repository.dart';

class ExecutePaymentUseCase {
  ExecutePaymentUseCase({required this._repository});

  final CartBaseRepository _repository;

  Future<ApiResponse<SubscriptionParameter>> call({
    required ExecutePaymentPara parameters,
  }) async {
    return _repository.executePayment(parameters: parameters);
  }
}
