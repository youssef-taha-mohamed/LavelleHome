import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../enums/field.dart';
import 'language.dart';
import 'theme_model.dart';

base class PreferenceModel extends Equatable {
  final List<LanguageModel> language;
  final List<ThemeModel> themes;

  const PreferenceModel({
    required this.language,
    required this.themes,
  });

  @override
  List<Object?> get props => [
        language,
        themes,
      ];
}

final class PreferenceModelDTO extends PreferenceModel {
  const PreferenceModelDTO({
    required super.language,
    required super.themes,
  });

  PreferenceModelDTO copyWith({
    List<LanguageModel>? language,
    List<ThemeModel>? themes,
  }) {
    return PreferenceModelDTO(
      language: language ?? this.language,
      themes: themes ?? this.themes,
    );
  }

  factory PreferenceModelDTO.fromJson(String json) {
    return PreferenceModelDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  factory PreferenceModelDTO.fromMap(Map<String, dynamic> map) {
    return PreferenceModelDTO(
      language: List<LanguageModel>.from(
        map[UserField.languages.value]?.map(
          (x) => LanguageModelDTO.fromMap(x as Map<String, dynamic>),
        ),
      ),
      themes: List<ThemeModel>.from(
        map[UserField.themes.value]?.map(
          (x) => ThemeModelDTO.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory PreferenceModelDTO.fromEntity(PreferenceModel entity) {
    return PreferenceModelDTO(
      language: entity.language,
      themes: entity.themes,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      UserField.languages.value:
          language.map((e) => LanguageModelDTO.fromEntity(e).toMap()).toList(),
      UserField.themes.value:
          themes.map((e) => ThemeModelDTO.fromEntity(e).toMap()).toList(),
    };
  }
}
