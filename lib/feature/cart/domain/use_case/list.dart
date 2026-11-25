import '../../../../shared/model/api_response.dart';
import '../entities/cart.dart';
import '../repository/repository.dart';

class ListOfCart {
  ListOfCart({required this._repository});

  final CartBaseRepository _repository;

  Future<ApiResponse<CartModel>> call({required num cartId}) async {
    return _repository.list(cartId: cartId);
  }
}
