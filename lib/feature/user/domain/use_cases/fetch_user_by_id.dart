import '../../../../shared/model/api_response.dart';
import '../entities/user_details.dart';
import '../repositories/user.dart';

final class FetchUserById {
  const FetchUserById({required this._repository});

  final UserBaseRepository _repository;

  Future<ApiResponse<UserDetails>> call({String? childId}) {
    return _repository.userById(childId: childId);
  }
}
