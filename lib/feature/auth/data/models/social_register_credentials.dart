import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../../shared/enum/gender.dart';
import '../../../../shared/enum/user_role.dart';
import '../../domain/entities/social_register_credentials.dart';
import '../../domain/enums/field.dart';
import '../../domain/enums/social_media.dart';

final class SocialRegisterCredentialsDTO extends SocialRegisterCredentials {
  const SocialRegisterCredentialsDTO({
    required super.socialMedia,
    required super.token,
    required super.email,
    required super.fullName,
    required super.userName,
    required super.phone,
    required super.countryId,
    required super.gender,
    required super.type,
    required super.languageId,
    required super.themeId,
    required super.birthDay,
    required super.password,
    super.address,
    super.note,
  });

  SocialRegisterCredentialsDTO copyWith({
    SocialMediaAuthentication? socialMedia,
    String? token,
    String? email,
    String? fullName,
    String? userName,
    String? phone,
    num? countryId,
    Gender? gender,
    UserRole? type,
    num? languageId,
    num? themeId,
    DateTime? birthDay,
    String? address,
    String? note,
    String? password,
  }) {
    return SocialRegisterCredentialsDTO(
      socialMedia: socialMedia ?? this.socialMedia,
      token: token ?? this.token,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      countryId: countryId ?? this.countryId,
      gender: gender ?? this.gender,
      type: type ?? this.type,
      languageId: languageId ?? this.languageId,
      themeId: themeId ?? this.themeId,
      birthDay: birthDay ?? this.birthDay,
      address: address ?? this.address,
      note: note ?? this.note,
      password: password ?? this.password,
    );
  }

  factory SocialRegisterCredentialsDTO.fromJson(String json) {
    return SocialRegisterCredentialsDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  factory SocialRegisterCredentialsDTO.fromEntity(
    SocialRegisterCredentials entity,
  ) {
    return SocialRegisterCredentialsDTO(
      socialMedia: entity.socialMedia,
      token: entity.token,
      email: entity.email,
      fullName: entity.fullName,
      userName: entity.userName,
      phone: entity.phone,
      countryId: entity.countryId,
      gender: entity.gender,
      type: entity.type,
      languageId: entity.languageId,
      themeId: entity.themeId,
      birthDay: entity.birthDay,
      address: entity.address,
      note: entity.note,
      password: entity.password,
    );
  }

  factory SocialRegisterCredentialsDTO.fromMap(Map<String, dynamic> json) {
    throw UnimplementedError('fromMap is not used for SocialRegisterCredentialsDTO');
  }

  Map<String, dynamic> toMap({
    String dateFormat = 'yyyy-MM-dd',
  }) {
    final map = <String, dynamic>{
      AuthField.socialMedia.value: socialMedia.id,
      AuthField.token.value: token,
      AuthField.platform.value: kIsWeb
          ? 3
          : (defaultTargetPlatform == TargetPlatform.iOS ? 2 : 1),
      AuthField.email.value: email,
      AuthField.fullName.value: fullName,
      AuthField.userName.value: userName,
      AuthField.phoneNumber.value: phone,
      AuthField.countryId.value: countryId,
      AuthField.gender.value: gender.id,
      AuthField.type.value: type.id,
      AuthField.languageId.value: languageId,
      AuthField.theme.value: themeId,
      AuthField.password.value: password,
    }..removeWhere((key, value) => value == null || value == '');

    if (birthDay != null) {
      map[AuthField.birthDay.value] =
          DateFormat(dateFormat, 'en').format(birthDay!);
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
