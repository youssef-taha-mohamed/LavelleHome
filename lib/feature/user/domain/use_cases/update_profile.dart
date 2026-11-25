import '../../../../shared/model/api_response.dart';
import '../entities/profile_modification_data.dart';
import '../entities/user_details.dart';
import '../repositories/user.dart';

final class UpdateProfile {
  const UpdateProfile({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse<UserDetails>> call({
    required ProfileModificationData parameter,
  }) async {
    return _repository.update(data: parameter);
  }
}
