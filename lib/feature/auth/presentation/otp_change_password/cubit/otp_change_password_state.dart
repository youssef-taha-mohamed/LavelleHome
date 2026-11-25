part of 'otp_change_password_cubit.dart';

enum OtpChangePasswordStatus {
  initial,
  loading,
  success,
  notValidOTP,
  resendOtp,
  errorResend,
  error,
}

extension OtpChangePasswordStateX on OtpChangePasswordState {
  bool get isLoading => status == OtpChangePasswordStatus.loading;

  bool get isSuccess => status == OtpChangePasswordStatus.success;

  bool get isError => status == OtpChangePasswordStatus.error;

  bool get isInitial => status == OtpChangePasswordStatus.initial;

  bool get isNotValidOTP => status == OtpChangePasswordStatus.notValidOTP;

  bool get isResendOtp => status == OtpChangePasswordStatus.resendOtp;

  bool get isErrorResend => status == OtpChangePasswordStatus.errorResend;
}

class OtpChangePasswordState extends Equatable {
  final OtpChangePasswordStatus status;
  final String? errorMessage;
  final String? successMessage;
  final String? formError;
  final String? userId;

  const OtpChangePasswordState({
    this.status = OtpChangePasswordStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.formError,
    this.userId,
  });

  OtpChangePasswordState copyWith({
    OtpChangePasswordStatus? status,
    String? errorMessage,
    String? successMessage,
    String? formError,
    String? userId,
  }) {
    return OtpChangePasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      formError: formError ?? this.formError,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        successMessage,
        formError,
        userId,
      ];
}
