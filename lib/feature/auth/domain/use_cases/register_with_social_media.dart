import '../../../../shared/model/api_response.dart';
import '../../../user/domain/entities/user.dart';
import '../entities/social_register_credentials.dart';
import '../repositories/authentication.dart';

final class RegisterWithSocialMedia {
  const RegisterWithSocialMedia({required this._repository});

  final AuthenticationBaseRepository _repository;

  Future<ApiResponse<User>> call({
    required SocialRegisterCredentials credentials,
  }) async {
    return _repository.registerWithSocialMedia(credentials: credentials);
  }
}
