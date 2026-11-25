import 'package:equatable/equatable.dart';

base class LoginCredentials extends Equatable {
  const LoginCredentials({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object> get props {
    return <Object>[
      username,
      password,
    ];
  }
}
