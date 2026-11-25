part of 'notifications_cubit.dart';

enum NotificationStatus {
  initial,
  loading,
  loaded,
  error,
  loadingMore,
  refresh,
  read,
}

class NotificationsState extends Equatable {
  final String errorMessage;
  final String successMessage;
  final NotificationStatus status;
  final NotificationStatus statusReadAll;
  final NotificationStatus readStatus;
  final NotificationStatus statusClear;
  final NotificationStatus statusDelete;
  final NotificationsApp? notifications;
  final NotificationType selectedType;
  final int page;
  final bool hasReachedMax;
  final int timestamp;

  const NotificationsState({
    this.errorMessage = '',
    this.successMessage = '',
    this.status = NotificationStatus.initial,
    this.statusReadAll = NotificationStatus.initial,
    this.statusClear = NotificationStatus.initial,
    this.statusDelete = NotificationStatus.initial,
    this.readStatus = NotificationStatus.initial,
    this.timestamp = 0,
    this.notifications,
    this.selectedType = NotificationType.all,
    this.page = 1,
    this.hasReachedMax = false,
  });

  NotificationsState copyWith({
    String? errorMessage,
    String? successMessage,
    NotificationStatus? status,
    NotificationStatus? statusReadAll,
    NotificationStatus? statusClear,
    NotificationStatus? statusDelete,
    int? timestamp,
    NotificationsApp? notifications,
    NotificationType? selectedType,
    NotificationStatus? readStatus,
    int? page,
    bool? hasReachedMax,
  }) {
    return NotificationsState(
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      notifications: notifications ?? this.notifications,
      statusReadAll: statusReadAll ?? this.statusReadAll,
      statusClear: statusClear ?? this.statusClear,
      statusDelete: statusDelete ?? this.statusDelete,
      readStatus: readStatus ?? this.readStatus,
      selectedType: selectedType ?? this.selectedType,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props {
    return [
      errorMessage,
      successMessage,
      status,
      timestamp,
      notifications,
      statusReadAll,
      statusClear,
      statusDelete,
      readStatus,
      selectedType,
      page,
      hasReachedMax,
    ];
  }
}
