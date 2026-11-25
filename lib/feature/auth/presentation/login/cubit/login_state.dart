part of 'login_cubit.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  emailNotVerified,
  error,
}

extension LoginStateX on LoginState {
  bool get isInitial => status == LoginStatus.initial;

  bool get isLoading => status == LoginStatus.loading;

  bool get isLoggedIn => status == LoginStatus.success;

  bool get isEmailNotVerified => status == LoginStatus.emailNotVerified;

  bool get isError => status == LoginStatus.error;
}

base class LoginState extends Equatable {
  final String? errorMessage;
  final LoginStatus? status;
  final String? successMessage;
  final String? formError;
  final bool isFormValid;

  const LoginState({
    this.errorMessage,
    this.status,
    this.successMessage,
    this.formError,
    this.isFormValid = false,
  });

  @override
  List<Object?> get props => [
        errorMessage,
        status,
        successMessage,
        formError,
        isFormValid,
      ];

  LoginState copyWith({
    String? errorMessage,
    LoginStatus? status,
    String? successMessage,
    String? formError,
    bool? isFormValid,
  }) {
    return LoginState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      formError: formError ?? this.formError,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}
