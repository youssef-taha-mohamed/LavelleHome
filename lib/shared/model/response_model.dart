import 'dart:convert';
import 'package:equatable/equatable.dart';

base class ReturnResponse extends Equatable {
  final String? message;
  final bool? status;
  final dynamic data;

  const ReturnResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  @override
  List<Object?> get props {
    return [
      message,
      status,
      data,
    ];
  }
}

final class ReturnResponseDTO extends ReturnResponse {
  const ReturnResponseDTO({
    required super.message,
    required super.status,
    required super.data,
  });

  ReturnResponseDTO copyWith({
    String? message,
    bool? status,
    dynamic data,
  }) {
    return ReturnResponseDTO(
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  factory ReturnResponseDTO.fromJson(String json) {
    return ReturnResponseDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ReturnResponseDTO.fromMap(Map<String, dynamic> map) {
    return ReturnResponseDTO(
      message: map['message'],
      status: map['status'],
      data: map['record'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
      'record': data,
    };
  }

  factory ReturnResponseDTO.fromEntity(ReturnResponse entity) {
    return ReturnResponseDTO(
      message: entity.message,
      status: entity.status,
      data: entity.data,
    );
  }
}
