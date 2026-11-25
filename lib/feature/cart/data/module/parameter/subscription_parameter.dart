import 'dart:convert';
import '../../../domain/entities/parameter/subscription_parameter.dart';
import '../../../domain/enum/fields.dart';

final class SubscriptionParameterDTO extends SubscriptionParameter {
  const SubscriptionParameterDTO({
    required super.formUrl,
    // required super.parameters,
  });

  SubscriptionParameterDTO copyWith({
    String? formUrl,
    // PaymentParameter? parameters,
  }) {
    return SubscriptionParameterDTO(
      formUrl: formUrl ?? this.formUrl,
      // parameters: parameters ?? this.parameters,
    );
  }

  factory SubscriptionParameterDTO.fromJson(String json) {
    return SubscriptionParameterDTO.fromMap(
      Map<String, dynamic>.from(
        jsonDecode(json),
      ),
    );
  }

  factory SubscriptionParameterDTO.fromMap(Map<String, dynamic> json) {
    return SubscriptionParameterDTO(
      formUrl: json[CartFields.formUrl.value] as String,
      // parameters: PaymentParameterDTO.fromMap(
      //   Map<String, dynamic>.from(
      //     json[CartFields.parameters.value] as Map,
      //   ),
      // ),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      CartFields.formUrl.value: formUrl,
      // CartFields.parameters.value:
      //     PaymentParameterDTO.fromEntity(parameters).toMap(),
    };
  }

  factory SubscriptionParameterDTO.fromEntity(SubscriptionParameter entity) {
    return SubscriptionParameterDTO(
      formUrl: entity.formUrl,
      // parameters: PaymentParameterDTO.fromEntity(entity.parameters),
    );
  }
}

final class PaymentParameterDTO extends PaymentParameter {
  const PaymentParameterDTO({
    required super.command,
    required super.accessCode,
    required super.merchantIdentifier,
    required super.merchantReference,
    required super.amount,
    required super.currency,
    required super.language,
    required super.signature,
    required super.customerEmail,
    super.returnUrl,
  });

  PaymentParameterDTO copyWith({
    String? command,
    String? accessCode,
    String? merchantIdentifier,
    String? merchantReference,
    String? amount,
    String? currency,
    String? language,
    String? signature,
    String? customerEmail,
    String? returnUrl,
  }) {
    return PaymentParameterDTO(
      command: command ?? this.command,
      accessCode: accessCode ?? this.accessCode,
      merchantIdentifier: merchantIdentifier ?? this.merchantIdentifier,
      merchantReference: merchantReference ?? this.merchantReference,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      language: language ?? this.currency,
      signature: signature ?? this.signature,
      customerEmail: customerEmail ?? this.customerEmail,
      returnUrl: returnUrl ?? this.returnUrl,
    );
  }

  factory PaymentParameterDTO.fromJson(String json) {
    return PaymentParameterDTO.fromMap(
      Map<String, dynamic>.from(
        jsonDecode(json),
      ),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory PaymentParameterDTO.fromMap(Map<String, dynamic> json) {
    return PaymentParameterDTO(
      command: json[CartFields.command.value] as String,
      accessCode: json[CartFields.accessCode.value] as String,
      merchantIdentifier: json[CartFields.merchantIdentifier.value] as String,
      merchantReference: json[CartFields.merchantReference.value] as String,
      amount: json[CartFields.amount.value] as String,
      currency: json[CartFields.currencyp.value] as String,
      language: json[CartFields.language.value],
      signature: json[CartFields.signature.value],
      customerEmail: json[CartFields.customerEmail.value] as String,
      returnUrl: json[CartFields.returnUrl.value] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      CartFields.command.value: command,
      CartFields.accessCode.value: accessCode,
      CartFields.merchantIdentifier.value: merchantIdentifier,
      CartFields.merchantReference.value: merchantReference,
      CartFields.amount.value: amount,
      CartFields.currencyp.value: currency,
      CartFields.language.value: language,
      CartFields.signature.value: signature,
      CartFields.customerEmail.value: customerEmail,
      CartFields.returnUrl.value: returnUrl,
    }..removeWhere(
        (key, value) => value == null || value.isEmpty || value == '',
      );
  }

  factory PaymentParameterDTO.fromEntity(PaymentParameter entity) {
    return PaymentParameterDTO(
      command: entity.command,
      accessCode: entity.accessCode,
      merchantIdentifier: entity.merchantIdentifier,
      merchantReference: entity.merchantReference,
      amount: entity.amount,
      currency: entity.currency,
      language: entity.language,
      signature: entity.signature,
      customerEmail: entity.customerEmail,
      returnUrl: entity.returnUrl,
    );
  }
}
