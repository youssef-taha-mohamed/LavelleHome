import 'dart:convert';
import '../../../domain/entities/parameters/change_password.dart';
import '../../../domain/enums/field.dart';

final class ChangePasswordParametersDTO extends ChangePasswordParameters {
  const ChangePasswordParametersDTO({
    required super.oldPassword,
    required super.newPassword,
    required super.confirmPassword,
    required super.userId,
  });

  ChangePasswordParametersDTO copyWith({
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
    String? userId,
  }) {
    return ChangePasswordParametersDTO(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      userId: userId ?? this.userId,
    );
  }

  factory ChangePasswordParametersDTO.fromJson(String json) {
    return ChangePasswordParametersDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  factory ChangePasswordParametersDTO.fromMap(Map<String, dynamic> map) {
    return ChangePasswordParametersDTO(
      oldPassword: map[UserField.oldPassword.value] as String,
      newPassword: map[UserField.newPassword.value] as String,
      confirmPassword: map[UserField.confirmPassword.value] as String,
      userId: map[UserField.userId.value] as String,
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      UserField.oldPassword.value: oldPassword,
      UserField.newPassword.value: newPassword,
      UserField.confirmPassword.value: confirmPassword,
      UserField.userId.value: userId,
    }..removeWhere((key, value) => value == null || value == '');
  }

  factory ChangePasswordParametersDTO.fromEntity(
      ChangePasswordParameters entity) {
    return ChangePasswordParametersDTO(
      oldPassword: entity.oldPassword,
      newPassword: entity.newPassword,
      confirmPassword: entity.confirmPassword,
      userId: entity.userId,
    );
  }
}
