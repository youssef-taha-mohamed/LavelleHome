import '../../../../shared/model/api_response.dart';
import '../entities/parameters/add_fcm_token.dart';
import '../repositories/user.dart';

final class AddFcmToken {
  const AddFcmToken({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse<Map>> call({required AddFcmTokenParameters parameters}) {
    return _repository.addFcmToken(parameters: parameters);
  }
}
