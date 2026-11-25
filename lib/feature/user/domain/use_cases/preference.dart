import '../../../../shared/model/api_response.dart';
import '../entities/preference_model.dart';
import '../repositories/user.dart';

final class FetchPreference {
  const FetchPreference({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse<PreferenceModel>> call({String? childId}) {
    return _repository.getPreference(childId: childId);
  }
}
