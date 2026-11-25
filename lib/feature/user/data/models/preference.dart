import 'dart:convert';
import '../../domain/entities/preference.dart';
import '../../domain/enums/field.dart';

final class PreferenceDTO extends Preference {
  const PreferenceDTO({
    required super.theme,
    required super.languageId,
    required super.languageName,
    required super.languageCode,
  });

  @override
  PreferenceDTO copyWith({
    num? theme,
    num? languageId,
    String? languageName,
    String? languageCode,
  }) {
    return PreferenceDTO(
      theme: theme ?? this.theme,
      languageId: languageId ?? this.languageId,
      languageName: languageName ?? this.languageName,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  factory PreferenceDTO.fromJson(String json) {
    return PreferenceDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  factory PreferenceDTO.fromMap(Map<String, dynamic> map) {
    return PreferenceDTO(
      theme: map[UserField.theme.value] as num,
      languageId: map[UserField.languageId.value] as num,
      languageName: map[UserField.languageName.value] as String,
      languageCode: map[UserField.languageCode.value] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() {
    return {
      UserField.theme.value: theme,
      UserField.languageId.value: languageId,
      UserField.languageName.value: languageName,
      UserField.languageCode.value: languageCode,
    };
  }

  factory PreferenceDTO.fromEntity(Preference preference) {
    return PreferenceDTO(
      theme: preference.theme,
      languageId: preference.languageId,
      languageName: preference.languageName,
      languageCode: preference.languageCode,
    );
  }
}
