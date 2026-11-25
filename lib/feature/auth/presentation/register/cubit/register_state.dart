part of 'register_cubit.dart';

enum RegisterStatus {
  initial,
  loading,
  success,
  error,
}

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String? successMessage;
  final String? errorMessage;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  bool get isLoading => status == RegisterStatus.loading;

  bool get isSuccess => status == RegisterStatus.success;

  bool get isError => status == RegisterStatus.error;

  RegisterState copyWith({
    RegisterStatus? status,
    String? successMessage,
    String? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, successMessage, errorMessage];
}
