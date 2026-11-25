import 'dart:convert';
import '../../../../../shared/enum/gender.dart';
import '../../../../core/utils/format_data.dart';
import '../../domain/entities/profile_modification_data.dart';
import '../../domain/enums/field.dart';

final class ProfileModificationDataDTO extends ProfileModificationData {
  const ProfileModificationDataDTO({
    super.userId,
    required super.countryId,
    super.birthDate,
    super.fullName,
    super.gender,
    super.imagePath,
    super.imageBytes,
    super.imageName,
    super.imageUrl,
    super.userName,
    super.phone,
    super.notes,
    super.address,
    super.phoneNumberCode,
    super.isoCode,
  });

  factory ProfileModificationDataDTO.fromJson(String json) {
    return ProfileModificationDataDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  factory ProfileModificationDataDTO.fromMap(Map<String, dynamic> map) {
    return ProfileModificationDataDTO(
      userId: map[UserField.childId.value] as String?,
      fullName: map[UserField.fullName.value] as String?,
      phone: map[UserField.phone.value] as String?,
      notes: map[UserField.notes.value] as String?,
      userName: map[UserField.userName.value] as String?,
      birthDate: map[UserField.birthday.value] != null
          ? DateTime.tryParse(map[UserField.birthday.value])
          : null,
      gender: Gender.fromId(map[UserField.gender.value]),
      countryId: map[UserField.countryId.value] as int,
      address: map[UserField.address.value] as String?,
      phoneNumberCode: map[UserField.phoneNumberCode.value] as String?,
      isoCode: map[UserField.isoCode.value] as String?,
    );
  }

  String toJson({String dateFormat = 'yyyy-MM-dd'}) {
    return jsonEncode(toMap(dateFormat: dateFormat));
  }

  /// Returns all text fields as a Map for JSON body (NO image).
  /// Image is sent separately as multipart.
  Map<String, dynamic> toMap({String dateFormat = 'yyyy-MM-dd'}) {
    return <String, dynamic>{
      UserField.fullName.value: fullName,
      UserField.phone.value: phone,
      UserField.notes.value: notes,
      UserField.userName.value: userName,
      UserField.birthday.value: birthDate != null
          ? DateFormatter.formatCustom(birthDate!, dateFormat, locale: 'en')
          : null,
      UserField.gender.value: gender?.id.toString(),
      UserField.countryId.value: countryId,
      UserField.childId.value: userId,
      UserField.address.value: address,
      UserField.phoneNumberCode.value: phoneNumberCode,
      UserField.isoCode.value: isoCode,
      if (imageUrl != null) UserField.image.value: imageUrl,
    }..removeWhere((key, value) => value == null || value.toString().isEmpty);
  }

  Map<String, String> toFormFields({String dateFormat = 'yyyy-MM-dd'}) {
    return toMap(
      dateFormat: dateFormat,
    ).map((key, value) => MapEntry(key, value.toString()));
  }

  factory ProfileModificationDataDTO.fromEntity(
    ProfileModificationData entity,
  ) {
    return ProfileModificationDataDTO(
      userId: entity.userId,
      fullName: entity.fullName,
      phone: entity.phone,
      imagePath: entity.imagePath,
      imageBytes: entity.imageBytes,
      imageName: entity.imageName,
      imageUrl: entity.imageUrl,
      notes: entity.notes,
      userName: entity.userName,
      birthDate: entity.birthDate,
      gender: entity.gender,
      countryId: entity.countryId,
      address: entity.address,
      phoneNumberCode: entity.phoneNumberCode,
      isoCode: entity.isoCode,
    );
  }
}
