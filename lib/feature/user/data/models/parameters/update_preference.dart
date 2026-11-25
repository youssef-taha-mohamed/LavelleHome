import 'dart:convert';
import '../../../domain/entities/parameters/update_preference.dart';
import '../../../domain/enums/field.dart';

final class UpdatePreferenceDTO extends UpdatePreference {
  const UpdatePreferenceDTO({
    super.childId,
    required super.themeId,
    required super.languageId,
  });

  UpdatePreferenceDTO copyWith({
    String? childId,
    num? themeId,
    num? languageId,
  }) {
    return UpdatePreferenceDTO(
      childId: childId ?? this.childId,
      themeId: themeId ?? this.themeId,
      languageId: languageId ?? this.languageId,
    );
  }

  factory UpdatePreferenceDTO.fromJson(String json) {
    return UpdatePreferenceDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  factory UpdatePreferenceDTO.fromMap(Map<String, dynamic> map) {
    return UpdatePreferenceDTO(
      childId: map[UserField.childId.value] as String?,
      themeId: map[UserField.theme.value] as num,
      languageId: map[UserField.languageId.value] as num,
    );
  }

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() {
    return {
      UserField.childId.value: childId,
      UserField.theme.value: themeId,
      UserField.languageId.value: languageId,
    };
  }

  factory UpdatePreferenceDTO.fromEntity(UpdatePreference entity) {
    return UpdatePreferenceDTO(
      childId: entity.childId,
      themeId: entity.themeId,
      languageId: entity.languageId,
    );
  }
}
