import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../../../user/domain/entities/preference_model.dart';
import '../../data/models/country.dart';
import '../enum/fields.dart';
import 'country.dart';

base class Definitions extends Equatable {
  final List<Countries> countries;
  final PreferenceModel preference;

  const Definitions({
    required this.countries,
    required this.preference,
  });

  @override
  List<Object?> get props => [
        countries,
        preference,
      ];
}

final class DefinitionsDTO extends Definitions {
  const DefinitionsDTO({
    required super.countries,
    required super.preference,
  });

  DefinitionsDTO copyWith({
    List<Countries>? countries,
    PreferenceModel? preference,
  }) {
    return DefinitionsDTO(
      countries: countries ?? this.countries,
      preference: preference ?? this.preference,
    );
  }

  factory DefinitionsDTO.fromJson(String json) {
    return DefinitionsDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  factory DefinitionsDTO.fromMap(Map<String, dynamic> map) {
    return DefinitionsDTO(
      countries: (map[CountryFields.countries.value] as List)
          .map(
            (e) => CountryDTO.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
      preference: PreferenceModelDTO.fromMap(
        map[CountryFields.preferences.value] as Map<String, dynamic>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      CountryFields.preferences.value:
          PreferenceModelDTO.fromEntity(preference).toMap(),
      CountryFields.countries.value:
          countries.map((e) => CountryDTO.fromEntity(e).toMap()).toList(),
    };
  }

  factory DefinitionsDTO.fromEntity(Definitions entity) {
    return DefinitionsDTO(
      countries: entity.countries,
      preference: entity.preference,
    );
  }
}
