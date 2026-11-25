import '../../../../shared/model/api_response.dart';
import '../entities/cart_info.dart';
import '../repository/repository.dart';

class GetCartId {
  const GetCartId({required this._repository});

  final CartBaseRepository _repository;

  Future<ApiResponse<CartInfo>> call({String? childId}) async {
    return _repository.getCartId(childId: childId);
  }
}
