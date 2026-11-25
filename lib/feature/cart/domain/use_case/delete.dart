import '../../../../shared/model/api_response.dart';
import '../entities/cart_info.dart';
import '../entities/parameter/add_parameter.dart';
import '../repository/repository.dart';

class DeleteCart {
  const DeleteCart({required this._repository});

  final CartBaseRepository _repository;

  Future<ApiResponse<CartInfo>> call({
    required CartParameters parameters,
  }) async {
    return _repository.delete(parameters: parameters);
  }
}
