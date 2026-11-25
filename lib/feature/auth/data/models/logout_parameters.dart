import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/logout_params.dart';
import '../../domain/enums/field.dart';

final class LogoutParametersDTO extends LogoutParameters {
  const LogoutParametersDTO({
    required super.fcmToken,
    required super.platform,
  });

  LogoutParametersDTO copyWith({
    String? fcmToken,
    TargetPlatform? platform,
  }) {
    return LogoutParametersDTO(
      fcmToken: fcmToken ?? this.fcmToken,
      platform: platform ?? this.platform,
    );
  }

  factory LogoutParametersDTO.fromJson(String json) {
    return LogoutParametersDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory LogoutParametersDTO.fromMap(Map<String, dynamic> json) {
    return LogoutParametersDTO(
      fcmToken: json[AuthField.fcmToken.value] as String,
      platform: TargetPlatform.values.firstWhere(
        (element) => element.name == json[AuthField.deviceType.value] as String,
      ),
    );
  }

  factory LogoutParametersDTO.fromEntity(
    LogoutParameters entity,
  ) {
    return LogoutParametersDTO(
      fcmToken: entity.fcmToken,
      platform: entity.platform,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      AuthField.fcmToken.value: fcmToken,
      AuthField.deviceType.value: platform == TargetPlatform.android ? 1 : 2,
    };
  }
}
