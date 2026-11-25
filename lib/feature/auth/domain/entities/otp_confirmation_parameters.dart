import 'package:equatable/equatable.dart';

base class OtpConfirmationParameters extends Equatable {
  const OtpConfirmationParameters({
    required this.otp,
    required this.email,
  });

  final String email;
  final String otp;

  @override
  List<Object?> get props {
    return <Object?>[
      email,
      otp,
    ];
  }
}
