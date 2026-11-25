import '../../../../shared/model/api_response.dart';
import '../repository/repository.dart';

final class SubscriptionUseCase {
  const SubscriptionUseCase({required this._repository});

  final CartBaseRepository _repository;

  Future<ApiResponse> call({
    required String userId,
    required num planId,
  }) async {
    return _repository.subscription(userId: userId, planId: planId);
  }
}
