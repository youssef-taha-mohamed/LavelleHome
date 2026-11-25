import 'package:equatable/equatable.dart';

base class ResetPasswordParameters extends Equatable {
  const ResetPasswordParameters({
    required this.password,
    required this.email,
    required this.userId,
  });

  final String email;
  final String password;
  final String userId;


  @override
  List<Object?> get props {
    return <Object?>[
      email,
      password,
      userId,
    ];
  }
}
