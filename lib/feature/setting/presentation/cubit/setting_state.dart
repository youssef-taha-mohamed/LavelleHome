part of 'setting_cubit.dart';

enum SettingStatus {
  initial,
  loadingToggle,
  successToggle,
  errorToggle,
  loadingDelete,
  successDelete,
  errorDelete,
}

extension SettingStatusExtension on SettingState {
  bool get isInitial => status == SettingStatus.initial;

  bool get isLoadingToggle => status == SettingStatus.loadingToggle;

  bool get isSuccessToggle => status == SettingStatus.successToggle;

  bool get isErrorToggle => status == SettingStatus.errorToggle;

  bool get isLoadingDelete => status == SettingStatus.loadingDelete;

  bool get isSuccessDelete => status == SettingStatus.successDelete;

  bool get isErrorDelete => status == SettingStatus.errorDelete;
}

class SettingState extends Equatable {
  final SettingStatus status;
  final String? errorMessage;
  final String? successMessage;
  final bool isNotificationOn;

  const SettingState({
    this.status = SettingStatus.initial,
    this.errorMessage,
    this.isNotificationOn = false,
    this.successMessage,
  });

  SettingState copyWith({
    SettingStatus? status,
    String? errorMessage,
    bool? isNotificationOn,
    String? successMessage,
  }) {
    return SettingState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isNotificationOn,
        successMessage,
      ];
}
