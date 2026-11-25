import 'package:equatable/equatable.dart';

base class ChangePasswordParameters extends Equatable {
  const ChangePasswordParameters({
    required this.newPassword,
    required this.userId,
    required this.oldPassword,
    required this.confirmPassword,
  });

  final String newPassword;
  final String oldPassword;
  final String userId;
  final String confirmPassword;

  @override
  List<Object> get props {
    return <Object>[
      oldPassword,
      userId,
      newPassword,
      confirmPassword,
    ];
  }
}
