import 'dart:convert';
import 'dart:developer';
import '../../../../shared/enum/gender.dart';
import '../../../../shared/enum/user_role.dart';
import '../../../country/data/models/country.dart';
import '../../../country/domain/entities/country.dart';
import '../../domain/entities/preference.dart';
import '../../domain/entities/user_details.dart';
import '../../domain/enums/field.dart';
import 'preference.dart';

final class UserDetailsDTO extends UserDetails {
  const UserDetailsDTO({
    required super.id,
    required super.email,
    required super.username,
    super.address,
    super.birthday,
    required super.phone,
    required super.emailVerified,
    required super.fullName,
    super.gender,
    required super.role,
    super.image,
    required super.notificationEnabled,
    required super.country,
    super.notes,
    required super.isAdult,
    required super.preference,
    required super.phoneNumberCode,
  });

  @override
  UserDetailsDTO copyWith({
    String? id,
    String? email,
    String? username,
    String? address,
    DateTime? birthday,
    String? phone,
    bool? emailVerified,
    String? fullName,
    Gender? gender,
    UserRole? role,
    String? image,
    String? notes,
    Countries? country,
    bool? notificationEnabled,
    bool? isAdult,
    Preference? preference,
    String? phoneNumberCode,
  }) {
    return UserDetailsDTO(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      address: address ?? this.address,
      birthday: birthday ?? this.birthday,
      phone: phone ?? this.phone,
      emailVerified: emailVerified ?? this.emailVerified,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      image: image ?? this.image,
      country: country ?? this.country,
      notes: notes ?? this.notes,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      isAdult: isAdult ?? this.isAdult,
      preference: preference ?? this.preference,
      phoneNumberCode: phoneNumberCode ?? this.phoneNumberCode,
    );
  }

  factory UserDetailsDTO.fromJson(String str) {
    return UserDetailsDTO.fromMap(
      Map<String, dynamic>.from(json.decode(str) as Map),
    );
  }

  String toJson({String dateFormat = 'yyyy-MM-dd'}) {
    return json.encode(toMap(dateFormat: dateFormat));
  }

  factory UserDetailsDTO.fromMap(Map<String, dynamic> json) {
    final genderValue = json[UserField.gender.value];
    final roleValue = json[UserField.role.value];

    log('Gender value from API: $genderValue');
    log('Role value from API: $roleValue');

    Gender? gender;
    if (genderValue != null) {
      try {
        gender = Gender.values[genderValue as int];
      } catch (e, s) {
        log('Error converting gender value: $e');
        log('Error converting gender Youssef Location: $s');
        gender = null;
      }
    }

    UserRole role;
    try {
      if (roleValue is int) {
        role = UserRole.fromId(roleValue) ?? UserRole.student;
      } else if (roleValue is String) {
        role =
            UserRole.fromId(int.tryParse(roleValue) ?? 2) ?? UserRole.student;
      } else {
        role = UserRole.student;
      }
    } catch (e, s) {
      log('Error converting role value: $e');
      log('Error converting Youssef role Location: $s');
      role = UserRole.student;
    }

    final birthdayString = json[UserField.birthday.value] as String?;
    return UserDetailsDTO(
      id: json[UserField.id.value] as String,
      email: json[UserField.email.value] as String,
      username: json[UserField.userName.value] as String,
      address: json[UserField.address.value] as String?,
      birthday: birthdayString == null
          ? null
          : DateTime.tryParse(birthdayString),
      phone: (json[UserField.phone.value] as String?) ?? '',
      emailVerified: (json[UserField.emailVerified.value] as bool?) ?? false,
      fullName: (json[UserField.fullName.value] as String?) ?? '',
      gender: gender,
      role: role,
      image: json[UserField.image.value] as String?,
      notes: json[UserField.notes.value] as String?,
      notificationEnabled:
          (json[UserField.notificationEnabled.value] as bool?) ?? false,
      country: CountryDTO.fromMap(
        Map<String, dynamic>.from(json[UserField.country.value] as Map),
      ),
      isAdult: (json[UserField.isAdult.value] as bool?) ?? false,
      preference: PreferenceDTO.fromMap(
        Map<String, dynamic>.from(json[UserField.preference.value] as Map),
      ),
      phoneNumberCode: json[UserField.phoneNumberCode.value] as String,
    );
  }

  factory UserDetailsDTO.fromEntity(UserDetails entity) {
    return UserDetailsDTO(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      address: entity.address,
      birthday: entity.birthday,
      phone: entity.phone,
      emailVerified: entity.emailVerified,
      fullName: entity.fullName,
      gender: entity.gender,
      role: entity.role,
      image: entity.image,
      country: entity.country,
      notificationEnabled: entity.notificationEnabled,
      notes: entity.notes,
      isAdult: entity.isAdult,
      preference: entity.preference,
      phoneNumberCode: entity.phoneNumberCode,
    );
  }

  Map<String, dynamic> toMap({String dateFormat = 'yyyy-MM-dd'}) {
    return <String, dynamic>{
      UserField.id.value: id,
      UserField.email.value: email,
      UserField.userName.value: username,
      UserField.address.value: address,
      UserField.birthday.value: birthday?.toIso8601String(),
      UserField.phone.value: phone,
      UserField.emailVerified.value: emailVerified,
      UserField.fullName.value: fullName,
      UserField.gender.value: gender?.id,
      UserField.role.value: role.id,
      UserField.image.value: image,
      UserField.country.value: CountryDTO.fromEntity(country).toMap(),
      UserField.notificationEnabled.value: notificationEnabled,
      UserField.notes.value: notes,
      UserField.isAdult.value: isAdult,
      UserField.preference.value: PreferenceDTO.fromEntity(preference).toMap(),
      UserField.phoneNumberCode.value: phoneNumberCode,
    };
  }
}
