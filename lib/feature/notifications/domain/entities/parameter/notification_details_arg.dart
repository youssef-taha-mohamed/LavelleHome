import '../notification.dart';

class NotificationDetailsScreenArguments {
  final NotificationModel notification;
  final String? childId;
  final bool isTablet;

  NotificationDetailsScreenArguments({
    required this.notification,
    this.childId,
    this.isTablet = false,
  });
}
