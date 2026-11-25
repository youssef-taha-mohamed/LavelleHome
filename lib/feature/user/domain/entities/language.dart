import 'dart:convert';
import 'package:equatable/equatable.dart';

base class LanguageModel extends Equatable {
  final String code;
  final String name;
  final num priority;
  final bool isDefault;

  @override
  List<Object?> get props => [
        code,
        name,
        priority,
        isDefault,
      ];

  const LanguageModel({
    required this.code,
    required this.name,
    required this.priority,
    required this.isDefault,
  });
}

final class LanguageModelDTO extends LanguageModel {
  const LanguageModelDTO({
    required super.code,
    required super.name,
    required super.priority,
    required super.isDefault,
  });

  LanguageModelDTO copyWith({
    String? code,
    String? name,
    num? priority,
    bool? isDefault,
  }) {
    return LanguageModelDTO(
      code: code ?? this.code,
      name: name ?? this.name,
      priority: priority ?? this.priority,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory LanguageModelDTO.fromJson(String json) {
    return LanguageModelDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  factory LanguageModelDTO.fromMap(Map<String, dynamic> map) {
    return LanguageModelDTO(
      code: map['code'] as String,
      name: map['name'] as String,
      priority: map['id'] as num,
      isDefault: map['isDefault'] as bool,
    );
  }

  factory LanguageModelDTO.fromEntity(LanguageModel entity) {
    return LanguageModelDTO(
      code: entity.code,
      name: entity.name,
      priority: entity.priority,
      isDefault: entity.isDefault,
    );
  }

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'id': priority,
      'isDefault': isDefault,
    };
  }
}
