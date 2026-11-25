import 'dart:convert';
import '../../domain/entities/otp_confirmation_parameters.dart';
import '../../domain/enums/field.dart';

final class OtpConfirmationParametersDTO extends OtpConfirmationParameters {
  const OtpConfirmationParametersDTO({
    required super.otp,
    required super.email,
  });

  OtpConfirmationParametersDTO copyWith({
    String? email,
    String? otp,
  }) {
    return OtpConfirmationParametersDTO(
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }

  factory OtpConfirmationParametersDTO.fromJson(String json) {
    return OtpConfirmationParametersDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json) as Map),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory OtpConfirmationParametersDTO.fromMap(Map<String, dynamic> json) {
    return OtpConfirmationParametersDTO(
      email: json[AuthField.email.value] as String,
      otp: json[AuthField.otp.value] as String,
    );
  }

  factory OtpConfirmationParametersDTO.fromEntity(
    OtpConfirmationParameters entity,
  ) {
    return OtpConfirmationParametersDTO(
      email: entity.email,
      otp: entity.otp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      AuthField.email.value: email,
      AuthField.otp.value: otp,
    }..removeWhere((key, value) => value == null);
  }
}
