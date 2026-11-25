part of 'otp_register_cubit.dart';

enum OtpRegisterStatus {
  initial,
  loading,
  success,
  notValidOTP,
  error,
}

extension OtpRegisterStateX on OtpRegisterState {
  bool get isLoading => status == OtpRegisterStatus.loading;

  bool get isSuccess => status == OtpRegisterStatus.success;

  bool get isError => status == OtpRegisterStatus.error;

  bool get isInitial => status == OtpRegisterStatus.initial;

  bool get isNotValidOTP => status == OtpRegisterStatus.notValidOTP;
}

class OtpRegisterState extends Equatable {
  final OtpRegisterStatus status;
  final String? errorMessage;
  final String? successMessage;
  final String? formError;
  final bool isFormValid;

  const OtpRegisterState({
    this.status = OtpRegisterStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.formError,
    this.isFormValid = false,
  });

  OtpRegisterState copyWith({
    OtpRegisterStatus? status,
    String? errorMessage,
    String? successMessage,
    String? formError,
    bool? isFormValid,
  }) {
    return OtpRegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      formError: formError ?? this.formError,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        successMessage,
        formError,
        isFormValid,
      ];
}
