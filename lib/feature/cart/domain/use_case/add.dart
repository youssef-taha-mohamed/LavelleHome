import '../../../../shared/model/api_response.dart';
import '../entities/cart_info.dart';
import '../entities/parameter/add_parameter.dart';
import '../repository/repository.dart';

class AddToCart {
  const AddToCart({required this._repository});

  final CartBaseRepository _repository;

  Future<ApiResponse<CartInfo>> call({
    required CartParameters parameters,
  }) async {
    return await _repository.add(parameters: parameters);
  }
}
