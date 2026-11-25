import 'dart:convert';
import '../../domain/entities/notification.dart';
import '../../domain/entities/notification_modal.dart';
import '../../domain/enum/fields.dart';
import 'notification_model.dart';

final class NotificationsAppDTO extends NotificationsApp {
  const NotificationsAppDTO({
    required super.totalCount,
    required super.notifications,
  });

  NotificationsAppDTO copyWith({
    num? totalCount,
    List<NotificationModel>? notifications,
  }) {
    return NotificationsAppDTO(
      totalCount: totalCount ?? this.totalCount,
      notifications: notifications ?? this.notifications,
    );
  }

  factory NotificationsAppDTO.fromJson(String json) {
    return NotificationsAppDTO.fromMap(
      Map<String, dynamic>.from(
        jsonDecode(json),
      ),
    );
  }

  factory NotificationsAppDTO.fromMap(Map<String, dynamic> map) {
    List<NotificationModel> notificationsList = [];
    if (map[NotificationFields.notifications.key] != null &&
        map[NotificationFields.notifications.key] is List) {
      notificationsList = List<NotificationModel>.from(
        (map[NotificationFields.notifications.key] as List).map(
          (x) => NotificationDTO.fromMap(x as Map<String, dynamic>),
        ),
      );
    }
    return NotificationsAppDTO(
      totalCount: map[NotificationFields.totalCount.key],
      notifications: notificationsList,
    );
  }

  factory NotificationsAppDTO.fromEntity(NotificationsApp entity) {
    return NotificationsAppDTO(
      totalCount: entity.totalCount,
      notifications: entity.notifications,
    );
  }
}
