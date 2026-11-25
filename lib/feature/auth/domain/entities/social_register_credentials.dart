import 'package:equatable/equatable.dart';
import '../../../../shared/enum/gender.dart';
import '../../../../shared/enum/user_role.dart';
import '../enums/social_media.dart';

base class SocialRegisterCredentials extends Equatable {
  const SocialRegisterCredentials({
    required this.socialMedia,
    required this.token,
    required this.email,
    required this.fullName,
    required this.userName,
    required this.phone,
    required this.countryId,
    required this.gender,
    required this.type,
    required this.languageId,
    required this.themeId,
    required this.birthDay,
    required this.password,
    this.address,
    this.note,
  });

  final SocialMediaAuthentication socialMedia;
  final String token;
  final String email;
  final String fullName;
  final String userName;
  final String phone;
  final num countryId;
  final Gender gender;
  final UserRole type;
  final num languageId;
  final num themeId;
  final DateTime? birthDay;
  final String? address;
  final String? note;
  final String password;

  @override
  List<Object?> get props => [
        socialMedia,
        token,
        email,
        fullName,
        userName,
        phone,
        countryId,
        gender,
        type,
        languageId,
        themeId,
        birthDay,
        address,
        note,
        password,
      ];
}
