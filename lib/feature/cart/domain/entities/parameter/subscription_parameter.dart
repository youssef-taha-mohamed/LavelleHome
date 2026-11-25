import 'package:equatable/equatable.dart';

base class SubscriptionParameter extends Equatable {
  final String formUrl;
  //final PaymentParameter parameters;

  const SubscriptionParameter({
    required this.formUrl,
    //required this.parameters,
  });

  @override
  List<Object?> get props => [
        formUrl,
        //parameters,
      ];
}

base class PaymentParameter extends Equatable {
  final String command;
  final String accessCode;
  final String merchantIdentifier;
  final String merchantReference;
  final String amount;
  final String currency;
  final String language;
  final String signature;
  final String customerEmail;
  final String? returnUrl;

  const PaymentParameter({
    required this.command,
    required this.accessCode,
    required this.merchantIdentifier,
    required this.merchantReference,
    required this.amount,
    required this.currency,
    required this.language,
    required this.signature,
    required this.customerEmail,
    this.returnUrl,
  });

  @override
  List<Object?> get props => [
        command,
        accessCode,
        merchantIdentifier,
        merchantReference,
        amount,
        currency,
        language,
        signature,
        customerEmail,
        returnUrl,
      ];
}
