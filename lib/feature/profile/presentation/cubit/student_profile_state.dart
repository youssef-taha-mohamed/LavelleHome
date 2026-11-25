part of 'student_profile_cubit.dart';

enum StudentProfileStateEnum {
  initial,
  loading,
  loadingUser,
  success,
  error,
  formValid,
  emailChangedSuccess,
  confirmOTPSuccess,
  successFetchUser,
  resendOTPSuccess,
}

extension StudentProfileStateEnumX on StudentProfileState {
  bool get isInitial => state == StudentProfileStateEnum.initial;

  bool get isLoading => state == StudentProfileStateEnum.loading;
  bool get isLoadingUser => state == StudentProfileStateEnum.loadingUser;
  bool get isSuccess => state == StudentProfileStateEnum.success;
  bool get isError => state == StudentProfileStateEnum.error;
  bool get isFormValid => state == StudentProfileStateEnum.formValid;
  bool get isEmailChangedSuccess =>
      state == StudentProfileStateEnum.emailChangedSuccess;
  bool get isConfirmOTPSuccess =>
      state == StudentProfileStateEnum.confirmOTPSuccess;
  bool get isSuccessFetchUser =>
      state == StudentProfileStateEnum.successFetchUser;
  bool get isResendOTPSuccess =>
      state == StudentProfileStateEnum.resendOTPSuccess;
}


class StudentProfileState {
  final StudentProfileStateEnum state;
  final String? errorMessage;
  final String? successMessage;
  final UserDetails? userDetails;

  StudentProfileState({
    this.state = StudentProfileStateEnum.initial,
    this.errorMessage,
    this.successMessage,
    this.userDetails,
  });

  StudentProfileState copyWith({
    StudentProfileStateEnum? state,
    String? errorMessage,
    String? successMessage,
    UserDetails? userDetails,
  }) {
    return StudentProfileState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      userDetails: userDetails ?? this.userDetails,
    );
  }
}
