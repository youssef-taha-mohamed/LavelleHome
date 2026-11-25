import 'package:equatable/equatable.dart';

base class ChangeEmailParameters extends Equatable {
  const ChangeEmailParameters({
    this.password,
    required this.userId,
    required this.newEmail,
    this.otp,
  });

  final String? password;
  final String newEmail;
  final String userId;
  final String? otp;

  @override
  List<Object?> get props {
    return <Object?>[
      newEmail,
      userId,
      password,
    ];
  }
}
