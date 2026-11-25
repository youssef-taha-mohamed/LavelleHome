part of 'reset_password_cubit.dart';

enum ResetPasswordStatus {
  initial,
  loading,
  success,
  error,
}

extension ResetPasswordStatusExtension on ResetPasswordState {
  bool get isInitial => status == ResetPasswordStatus.initial;

  bool get isLoading => status == ResetPasswordStatus.loading;

  bool get isSuccess => status == ResetPasswordStatus.success;

  bool get isError => status == ResetPasswordStatus.error;
}

final class ResetPasswordState extends Equatable {
  final ResetPasswordStatus status;
  final String? error;
   final String? successMessage;
   final String? formError;
   final bool isFormValid;
 
   const ResetPasswordState({
     this.status = ResetPasswordStatus.initial,
     this.error,
     this.successMessage,
     this.formError,
     this.isFormValid = false,
   });

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
     String? error,
     String? successMessage,
     String? formError,
     bool? isFormValid,
   }) {
     return ResetPasswordState(
       status: status ?? this.status,
       error: error ?? this.error,
       successMessage: successMessage ?? this.successMessage,
       formError: formError ?? this.formError,
       isFormValid: isFormValid ?? this.isFormValid,
     );
   }

  @override
  List<Object?> get props => [
        status,
         error,
         successMessage,
         formError,
         isFormValid,
       ];
}
