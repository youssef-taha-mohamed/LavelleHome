import 'package:equatable/equatable.dart';

base class VerifyAccountParameters extends Equatable {
  const VerifyAccountParameters({
    required this.otp,
    required this.email,
  });

  final String otp;
  final String email;

  @override
  List<Object> get props {
    return <Object>[
      otp,
      email,
    ];
  }
}
