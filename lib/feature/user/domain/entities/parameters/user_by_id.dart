import 'package:equatable/equatable.dart';

final class UserByIdParameter extends Equatable {
  const UserByIdParameter({
    this.userId,
  });

  final String? userId;

  @override
  List<Object?> get props {
    return <Object?>[
      userId,
    ];
  }
}
