import 'dart:convert';

import 'package:equatable/equatable.dart';

base class ThemeModel extends Equatable {
  final num theme;
  final bool isDefault;

  const ThemeModel({
    required this.theme,
    required this.isDefault,
  });

  @override
  List<Object?> get props => [
        theme,
        isDefault,
      ];
}

final class ThemeModelDTO extends ThemeModel {
  const ThemeModelDTO({
    required super.theme,
    required super.isDefault,
  });

  ThemeModelDTO copyWith({
    num? theme,
    bool? isDefault,
  }) {
    return ThemeModelDTO(
      theme: theme ?? this.theme,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory ThemeModelDTO.fromJson(String json) {
    return ThemeModelDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  factory ThemeModelDTO.fromMap(Map<String, dynamic> map) {
    return ThemeModelDTO(
      theme: map['theme'] as num,
      isDefault: map['isDefault'] as bool,
    );
  }

  factory ThemeModelDTO.fromEntity(ThemeModel entity) {
    return ThemeModelDTO(
      theme: entity.theme,
      isDefault: entity.isDefault,
    );
  }

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'theme': theme,
      'isDefault': isDefault,
    };
  }
}
