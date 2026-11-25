import 'dart:convert';
import '../../../domain/entities/parameters/change_email_para.dart';
import '../../../domain/enums/field.dart';

final class ChangeEmailParametersDTO extends ChangeEmailParameters {
  const ChangeEmailParametersDTO({
    super.otp,
    super.password,
    required super.newEmail,
    required super.userId,
  });

  ChangeEmailParametersDTO copyWith({
    String? otp,
    String? password,
    String? newEmail,
    String? userId,
  }) {
    return ChangeEmailParametersDTO(
      otp: otp ?? this.otp,
      password: password ?? this.password,
      newEmail: newEmail ?? this.newEmail,
      userId: userId ?? this.userId,
    );
  }

  factory ChangeEmailParametersDTO.fromJson(String json) {
    return ChangeEmailParametersDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  factory ChangeEmailParametersDTO.fromMap(Map<String, dynamic> json) {
    return ChangeEmailParametersDTO(
      otp: json[UserField.otp.value] as String,
      password: json[UserField.password.value] as String,
      newEmail: json[UserField.newEmail.value] as String,
      userId: json[UserField.userId.value] as String,
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      UserField.newEmail.value: newEmail,
      UserField.userId.value: userId,
      UserField.otp.value: otp,
      UserField.password.value: password,
    }..removeWhere(
        (key, value) => value == null || value == '',
      );
  }

  factory ChangeEmailParametersDTO.fromEntity(ChangeEmailParameters entity) {
    return ChangeEmailParametersDTO(
      otp: entity.otp,
      password: entity.password,
      newEmail: entity.newEmail,
      userId: entity.userId,
    );
  }
}
