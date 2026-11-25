import 'dart:convert';
import '../../domain/entities/reset_password_parameters.dart';
import '../../domain/enums/field.dart';

final class ResetPasswordParametersDTO extends ResetPasswordParameters {
  const ResetPasswordParametersDTO({
    required super.password,
    required super.email,
    required super.userId,
  });

  ResetPasswordParametersDTO copyWith({
    String? email,
    String? password,
    String? userId,
  }) {
    return ResetPasswordParametersDTO(
      email: email ?? this.email,
      password: password ?? this.password,
      userId: userId ?? this.userId,
    );
  }

  factory ResetPasswordParametersDTO.fromJson(String json) {
    return ResetPasswordParametersDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory ResetPasswordParametersDTO.fromMap(Map<String, dynamic> json) {
    return ResetPasswordParametersDTO(
      email: json[AuthField.email.value] as String,
      password: json[AuthField.newPassword.value] as String,
      userId: json[AuthField.userId.value] as String,
    );
  }

  factory ResetPasswordParametersDTO.fromEntity(
    ResetPasswordParameters entity,
  ) {
    return ResetPasswordParametersDTO(
      email: entity.email,
      password: entity.password,
      userId: entity.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      AuthField.email.value: email,
      AuthField.newPassword.value: password,
      AuthField.userId.value: userId,
    };
  }
}
