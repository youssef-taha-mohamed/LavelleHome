part of 'read_notification_cubit.dart';

enum ReadNotificationStatus {
  initial,
  loading,
  success,
  error,
}

class ReadNotificationState extends Equatable {
  final String errorMessage;
  final String successMessage;
  final ReadNotificationStatus status;


  const ReadNotificationState({
    this.errorMessage = '',
    this.successMessage = '',
    this.status = ReadNotificationStatus.initial,
  });

  ReadNotificationState copyWith({
    String? errorMessage,
    String? successMessage,
    ReadNotificationStatus? status,
  }) {
    return ReadNotificationState(
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props {
    return [
      errorMessage,
      successMessage,
      status,
    ];
  }
}