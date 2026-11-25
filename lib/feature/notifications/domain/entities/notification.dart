import 'package:equatable/equatable.dart';

import '../enum/target_type.dart';

base class NotificationModel extends Equatable {
  final num notificationId;
  final String title;
  final String body;
  final String? target;
  final TargetType targetType;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.notificationId,
    required this.title,
    required this.body,
    this.target,
    required this.targetType,
    required this.isRead,
    required this.createdAt,
  });

  String get cleanTitle {
    if (title.contains(' ')) {
      return title.substring(title.indexOf(' ') + 1);
    }
    return title;
  }

  @override
  List<Object?> get props => [
        notificationId,
        title,
        body,
        target,
        targetType,
        isRead,
        createdAt,
      ];
}
