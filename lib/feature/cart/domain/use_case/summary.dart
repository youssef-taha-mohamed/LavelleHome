import '../../../../shared/model/api_response.dart';
import '../entities/summary.dart';
import '../repository/repository.dart';

class SummaryUseCase {
  SummaryUseCase({required this._repository});

  final CartBaseRepository _repository;

  Future<ApiResponse<OrderSummary>> call({required num cartId}) async {
    return _repository.summary(cartId: cartId);
  }
}
