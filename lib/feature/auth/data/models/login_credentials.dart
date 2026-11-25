import 'dart:convert';
import '../../domain/entities/login_credentials.dart';
import '../../domain/enums/field.dart';

final class LoginCredentialsDTO extends LoginCredentials {
  const LoginCredentialsDTO({
    required super.username,
    required super.password,
  });

  LoginCredentialsDTO copyWith({
    String? username,
    String? password,
  }) {
    return LoginCredentialsDTO(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  factory LoginCredentialsDTO.fromJson(String json) {
    return LoginCredentialsDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory LoginCredentialsDTO.fromMap(Map<String, dynamic> json) {
    return LoginCredentialsDTO(
      username: json[AuthField.usernameOrEmail.value] as String,
      password: json[AuthField.password.value] as String,
    );
  }

  factory LoginCredentialsDTO.fromEntity(LoginCredentials entity) {
    return LoginCredentialsDTO(
      username: entity.username,
      password: entity.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      AuthField.usernameOrEmail.value: username,
      AuthField.password.value: password,
      "appType": 1,
    };
  }
}
