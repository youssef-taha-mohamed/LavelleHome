part of 'change_password_cubit.dart';

enum ChangePasswordStatus {
  initial,
  loading,
  success,
  error,
}

class ChangePasswordState extends Equatable {
  final ChangePasswordStatus status;
  final String? errorMessage;
  final String? successMessage;
  final bool isFormValid;


  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.isFormValid = false,
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? errorMessage,
    String? successMessage,
    bool? isFormValid,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props =>
      [
        status,
        errorMessage,
        successMessage,
        isFormValid,
      ];
}