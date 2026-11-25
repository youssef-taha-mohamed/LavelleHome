import 'dart:convert';
import '../../domain/entities/country.dart';
import '../../domain/enum/fields.dart';

final class CountryDTO extends Countries {
  const CountryDTO({
    required super.name,
    required super.code,
    required super.flag,
    required super.id,
    required super.isoCode,
  });

  CountryDTO copyWith({
    String? name,
    String? code,
    String? flag,
    num? id,
    String? isoCode,
  }) {
    return CountryDTO(
      name: name ?? this.name,
      code: code ?? this.code,
      flag: flag ?? this.flag,
      id: id ?? this.id,
      isoCode: isoCode ?? this.isoCode,
    );
  }

  factory CountryDTO.fromJson(String json) {
    return CountryDTO.fromMap(
      Map<String, dynamic>.from(
        jsonDecode(json),
      ),
    );
  }

  factory CountryDTO.fromMap(Map<String, dynamic> map) {
    return CountryDTO(
      name: map[CountryFields.name.value] as String,
      code: map[CountryFields.code.value] as String,
      flag: map[CountryFields.flag.value] as String,
      id: map[CountryFields.id.value] as num,
      isoCode: map[CountryFields.isoCode.value] as String,
    );
  }

  Map<String, dynamic> toMap({
    String dateFormat = 'yyyy-MM-dd',
  }) {
    return {
      CountryFields.name.value: name,
      CountryFields.code.value: code,
      CountryFields.flag.value: flag,
      CountryFields.id.value: id,
      CountryFields.isoCode.value: isoCode,
    };
  }

  String toJson({
    String dateFormat = 'yyyy-MM-dd',
  }) {
    return jsonEncode(toMap(dateFormat: dateFormat));
  }

  factory CountryDTO.fromEntity(Countries entity) {
    return CountryDTO(
      name: entity.name,
      code: entity.code,
      flag: entity.flag,
      id: entity.id,
      isoCode: entity.isoCode,
    );
  }
}
