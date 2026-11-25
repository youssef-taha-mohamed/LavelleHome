import 'package:equatable/equatable.dart';
import 'notification.dart';

base class NotificationsApp extends Equatable {
  final num totalCount;
  final List<NotificationModel> notifications;

  const NotificationsApp({
    required this.totalCount,
    required this.notifications,
  });

  @override
  List<Object?> get props => [
        totalCount,
        notifications,
      ];
}
