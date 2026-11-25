import 'package:equatable/equatable.dart';
import '../../../user/domain/entities/user.dart';

base class ImpersonateResult extends Equatable {
  const ImpersonateResult({
    required this.user,
    this.studentId,
    required this.actAs,
    required this.actAsName,
    required this.imp,
  });

  final User user;
  final String? studentId;
  final String actAs;
  final String actAsName;
  final bool imp;

  @override
  List<Object?> get props => [user, studentId, actAs, actAsName, imp];
}
