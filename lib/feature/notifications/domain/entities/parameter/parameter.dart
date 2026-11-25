import 'package:equatable/equatable.dart';

base class NotificationParameter extends Equatable {
  final num? notificationId;
  final String? childId;

  const NotificationParameter({
    this.notificationId,
    this.childId,
  });

  @override
  List<Object?> get props => [
        notificationId,
        childId,
      ];

  NotificationParameter copyWith({
    num? notificationId,
    String? childId,
    bool clearChildId = false,
  }) {
    return NotificationParameter(
      notificationId: notificationId ?? this.notificationId,
      childId: clearChildId ? null : (childId ?? this.childId),
    );
  }
}
