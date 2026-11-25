import 'dart:convert';
import '../../domain/entities/payment_info.dart';
import '../../domain/enum/fields.dart';
import '../../domain/enum/payment_enum.dart';

final class PaymentInfoDTO extends PaymentInfo {
  const PaymentInfoDTO({
    required super.availablePaymentGateways,
    required super.bankAccountLists,
  });

  PaymentInfoDTO copyWith({
    List<PaymentEnum>? availablePaymentGateways,
    List<BankAccount>? bankAccountLists,
  }) {
    return PaymentInfoDTO(
      availablePaymentGateways:
          availablePaymentGateways ?? this.availablePaymentGateways,
      bankAccountLists: bankAccountLists ?? this.bankAccountLists,
    );
  }

  factory PaymentInfoDTO.fromJson(String json) {
    return PaymentInfoDTO.fromMap(Map<String, dynamic>.from(jsonDecode(json)));
  }

  factory PaymentInfoDTO.fromMap(Map<String, dynamic> map) {
    return PaymentInfoDTO(
      availablePaymentGateways: map[CartFields.availablePaymentGateways.value]
          .map<PaymentEnum>((x) => PaymentEnum.fromId(x))
          .toList(),
      bankAccountLists: map[CartFields.bankAccountLists.value]
          .map<BankAccount>((x) => BankAccountDTO.fromMap(x))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      CartFields.availablePaymentGateways.value:
          availablePaymentGateways.map((e) => e.id).toList(),
      CartFields.bankAccountLists.value: bankAccountLists
          .map((e) => BankAccountDTO.fromEntity(e).toMap())
          .toList(),
    };
  }

  String toJson() => jsonEncode(toMap());

  factory PaymentInfoDTO.fromEntity(PaymentInfo entity) {
    return PaymentInfoDTO(
      availablePaymentGateways: entity.availablePaymentGateways,
      bankAccountLists: entity.bankAccountLists,
    );
  }
}

final class BankAccountDTO extends BankAccount {
  const BankAccountDTO({
    required super.bankName,
    required super.accountNumber,
    required super.accountHolderName,
    super.notes,
    required super.iban,
  });

  BankAccountDTO copyWith({
    String? bankName,
    String? accountNumber,
    String? accountHolderName,
    String? notes,
    String? iban,
  }) {
    return BankAccountDTO(
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      notes: notes ?? this.notes,
      iban: iban ?? this.iban,
    );
  }

  factory BankAccountDTO.fromJson(String json) {
    return BankAccountDTO.fromMap(Map<String, dynamic>.from(jsonDecode(json)));
  }

  factory BankAccountDTO.fromMap(Map<String, dynamic> map) {
    return BankAccountDTO(
      bankName: map[CartFields.bankName.value] as String,
      accountNumber: map[CartFields.accountNumber.value] as String,
      accountHolderName: map[CartFields.accountHolderName.value] as String,
      notes: map[CartFields.note.value] as String?,
      iban: map[CartFields.iban.value] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      CartFields.bankName.value: bankName,
      CartFields.accountNumber.value: accountNumber,
      CartFields.accountHolderName.value: accountHolderName,
      CartFields.note.value: notes,
      CartFields.iban.value: iban,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory BankAccountDTO.fromEntity(BankAccount entity) {
    return BankAccountDTO(
      bankName: entity.bankName,
      accountNumber: entity.accountNumber,
      accountHolderName: entity.accountHolderName,
      notes: entity.notes,
      iban: entity.iban,
    );
  }
}
