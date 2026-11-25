import 'package:equatable/equatable.dart';
import '../../../../shared/enum/gender.dart';
import '../../../../shared/enum/user_role.dart';

base class RegisterCredentials extends Equatable {
  const RegisterCredentials({
    this.email = '',
    required this.fullName,
    this.password = '',
    this.userName = '',
    this.countryId = 1,
    required this.phone,
    this.type = UserRole.student,
    this.gender = Gender.male,
    this.languageId = 1,
    this.themeId = 1,
    this.note,
    this.address,
    this.birthDay,
    required this.phoneNumberCode,
    required this.isoCode,
  });

  final String userName;
  final String email;
  final String password;
  final String? address;
  final String fullName;
  final String phone;
  final DateTime? birthDay;
  final UserRole type;
  final Gender gender;
  final String? note;
  final num countryId;
  final num languageId;
  final num themeId;
  final String phoneNumberCode;
  final String isoCode;

  @override
  List<Object?> get props {
    return <Object?>[
      birthDay,
      email,
      fullName,
      gender,
      password,
      phone,
      userName,
      address,
      type,
      note,
      countryId,
      languageId,
      themeId,
      phoneNumberCode,
      isoCode,
    ];
  }
}
