import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../../shared/enum/gender.dart';
import '../../../../shared/enum/user_role.dart';
import '../../domain/entities/register_credentials.dart';
import '../../domain/enums/field.dart';

final class RegisterCredentialsDTO extends RegisterCredentials {
  const RegisterCredentialsDTO({
    required super.email,
    required super.userName,
    required super.fullName,
    required super.password,
    required super.type,
    required super.gender,
    required super.phone,
    required super.countryId,
    required super.languageId,
    required super.themeId,
    required super.phoneNumberCode,
    required super.isoCode,
    super.birthDay,
    super.address,
    super.note,
  });

  RegisterCredentialsDTO copyWith({
    String? address,
    DateTime? birthDay,
    String? email,
    String? userName,
    Gender? gender,
    String? fullName,
    String? password,
    String? phone,
    UserRole? type,
    String? note,
    num? countryId,
    num? languageId,
    num? themeId,
    String? phoneNumberCode,
    String? isoCode,
  }) {
    return RegisterCredentialsDTO(
      birthDay: birthDay ?? this.birthDay,
      type: type ?? this.type,
      email: email ?? this.email,
      userName: email ?? this.userName,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      note: note ?? this.note,
      countryId: countryId ?? this.countryId,
      languageId: languageId ?? this.languageId,
      themeId: themeId ?? this.themeId,
      phoneNumberCode: phoneNumberCode ?? this.phoneNumberCode,
      isoCode: isoCode ?? this.isoCode,
    );
  }

  factory RegisterCredentialsDTO.fromJson(String json) {
    return RegisterCredentialsDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  String toJson({
    String dateFormat = 'yyyy-MM-dd',
  }) {
    return jsonEncode(toMap(dateFormat: dateFormat));
  }

  factory RegisterCredentialsDTO.fromMap(Map<String, dynamic> json) {
    return RegisterCredentialsDTO(
      birthDay: DateTime.tryParse(
            json[AuthField.birthDay.value] as String,
          ) ??
          DateTime.now(),
      email: json[AuthField.email.value] as String,
      userName: json[AuthField.userName.value] as String,
      fullName: json[AuthField.fullName.value] as String,
      gender: Gender.parseById(json[AuthField.gender.value] as int),
      address: json[AuthField.address.value] as String,
      password: json[AuthField.password.value] as String,
      phone: json[AuthField.phoneNumber.value] as String,
      type: UserRole.fromId(json[AuthField.type.value] as int) ??
          UserRole.student,
      note: json[AuthField.notes.value] as String?,
      countryId: json[AuthField.countryId.value] as num,
      languageId: json[AuthField.languageId.value] as num,
      themeId: json[AuthField.theme.value] as num,
      phoneNumberCode: json[AuthField.phoneNumberCode.value] as String,
      isoCode: json[AuthField.isoCode.value] as String,
    );
  }

  factory RegisterCredentialsDTO.fromEntity(
    RegisterCredentials entity,
  ) {
    return RegisterCredentialsDTO(
      type: entity.type,
      birthDay: entity.birthDay,
      email: entity.email,
      userName: entity.userName,
      address: entity.address,
      gender: entity.gender,
      fullName: entity.fullName,
      password: entity.password,
      phone: entity.phone,
      note: entity.note,
      countryId: entity.countryId,
      languageId: entity.languageId,
      themeId: entity.themeId,
      phoneNumberCode: entity.phoneNumberCode,
      isoCode: entity.isoCode,
    );
  }

  Map<String, dynamic> toMap({
    String dateFormat = 'yyyy-MM-dd',
  }) {
    final map = <String, dynamic>{
      AuthField.type.value: type.id,
      AuthField.email.value: email,
      AuthField.userName.value: userName,
      AuthField.gender.value: gender.id,
      AuthField.fullName.value: fullName,
      AuthField.password.value: password,
      AuthField.phoneNumber.value: phone,
      AuthField.countryId.value: countryId,
      AuthField.languageId.value: languageId,
      AuthField.theme.value: themeId,
      AuthField.phoneNumberCode.value: phoneNumberCode,
      AuthField.isoCode.value: isoCode,
    }..removeWhere((key, value) => value == null || value == '');

    if (type != UserRole.parent) {
      if (birthDay != null) {
        map[AuthField.birthDay.value] =
            DateFormat(dateFormat, 'en').format(birthDay!);
      }
      if (address != null && address!.isNotEmpty) {
        map[AuthField.address.value] = address;
      }
    }
    if (address != null && address!.isNotEmpty) {
      map[AuthField.address.value] = address;
    }

    if (note != null && note!.isNotEmpty) {
      map[AuthField.notes.value] = note;
    }

    return map;
  }
}
