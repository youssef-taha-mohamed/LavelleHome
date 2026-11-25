import '../../../../shared/model/api_response.dart';
import '../entities/parameters/update_preference.dart';
import '../repositories/user.dart';

final class UpdatePreferenceUseCase {
  const UpdatePreferenceUseCase({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse<Map>> call({required UpdatePreference parameters}) {
    return _repository.updatePreference(data: parameters);
  }
}
