import '../../../../shared/model/api_response.dart';
import '../../../user/domain/entities/user.dart';
import '../entities/social_media_credentials.dart';
import '../repositories/authentication.dart';

final class LoginWithSocialMedia {
  const LoginWithSocialMedia({required this._repository});

  final AuthenticationBaseRepository _repository;

  Future<ApiResponse<User>> call({
    required SocialMediaCredentials credentials,
  }) async {
    return _repository.loginWithSocialMedia(credentials: credentials);
  }
}
