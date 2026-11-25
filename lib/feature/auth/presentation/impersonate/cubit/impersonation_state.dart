import 'package:equatable/equatable.dart';
import '../../../../user/domain/entities/user.dart';

sealed class ImpersonationState extends Equatable {
  const ImpersonationState();

  @override
  List<Object?> get props => [];
}

final class ImpersonationInitial extends ImpersonationState {
  const ImpersonationInitial();
}

final class ImpersonationLoading extends ImpersonationState {
  const ImpersonationLoading();
}

final class ImpersonationSuccess extends ImpersonationState {
  const ImpersonationSuccess({
    required this.user,
    this.studentId,
  });

  final User user;
  final String? studentId;

  @override
  List<Object?> get props => [user, studentId];
}

final class ImpersonationFailure extends ImpersonationState {
  const ImpersonationFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
