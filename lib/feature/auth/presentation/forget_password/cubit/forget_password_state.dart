part of 'forget_password_cubit.dart';

enum ForgetPasswordStatus {
  initial,
  loading,
  success,
  notValidOTP,
  notValidPassword,
  error,
}

extension ForgetPasswordStatusExtension on ForgetPasswordState {
  bool get isInitial => status == ForgetPasswordStatus.initial;

  bool get isLoading => status == ForgetPasswordStatus.loading;

  bool get isSuccess => status == ForgetPasswordStatus.success;

  bool get isNotValidOTP => status == ForgetPasswordStatus.notValidOTP;

  bool get isNotValidPassword =>
      status == ForgetPasswordStatus.notValidPassword;

  bool get isError => status == ForgetPasswordStatus.error;
}

final class ForgetPasswordState extends Equatable {
  final ForgetPasswordStatus status;
  final String? formError;
  final String? successMessage;
  final String? errorMessage;
  final bool isFormValid;

  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
    this.formError,
    this.successMessage,
    this.errorMessage,
    this.isFormValid = false,
  });

  @override
  List<Object?> get props => [
        status,
        formError,
        successMessage,
        errorMessage,
        isFormValid,
      ];

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
    String? formError,
    String? successMessage,
    String? errorMessage,
    bool? isFormValid,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      formError: formError ?? this.formError,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}
