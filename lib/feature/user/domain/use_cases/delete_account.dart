import '../../../../shared/model/api_response.dart';
import '../repositories/user.dart';

final class DeleteAccountUseCase {
  const DeleteAccountUseCase({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse<Map>> call({required String childId}) async {
    return _repository.delete(childId: childId);
  }
}
