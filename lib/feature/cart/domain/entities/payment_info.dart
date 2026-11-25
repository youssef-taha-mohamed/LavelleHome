import 'package:equatable/equatable.dart';
import '../enum/payment_enum.dart';

base class PaymentInfo extends Equatable {
  final List<PaymentEnum> availablePaymentGateways;
  final List<BankAccount> bankAccountLists;

  const PaymentInfo({
    required this.availablePaymentGateways,
    required this.bankAccountLists,
  });

  @override
  List<Object?> get props => [availablePaymentGateways, bankAccountLists];
}

base class BankAccount extends Equatable {
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final String? notes;
  final String iban;

  const BankAccount({
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    this.notes,
    required this.iban,
  });

  @override
  List<Object?> get props => [
        bankName,
        accountNumber,
        accountHolderName,
        notes,
        iban,
      ];
}
