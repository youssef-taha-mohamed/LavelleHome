import 'dart:convert';
import '../../../../core/utils/format_data.dart';
import '../../domain/entities/notification.dart';
import '../../domain/enum/fields.dart';
import '../../domain/enum/target_type.dart';

final class NotificationDTO extends NotificationModel {
  const NotificationDTO({
    required super.notificationId,
    required super.title,
    required super.body,
    required super.createdAt,
    required super.targetType,
    required super.isRead,
    super.target,
  });

  NotificationDTO copyWith({
    num? notificationId,
    String? title,
    String? body,
    DateTime? createdAt,
    TargetType? targetType,
    bool? isRead,
    String? target,
  }) {
    return NotificationDTO(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      target: target ?? this.target,
      isRead: isRead ?? this.isRead,
      targetType: targetType ?? this.targetType,
    );
  }

  factory NotificationDTO.fromJson(String json) {
    return NotificationDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  factory NotificationDTO.fromEntity(NotificationModel entity) {
    return NotificationDTO(
      notificationId: entity.notificationId,
      title: entity.title,
      body: entity.body,
      createdAt: entity.createdAt,
      target: entity.target,
      isRead: entity.isRead,
      targetType: entity.targetType,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory NotificationDTO.fromMap(Map<String, dynamic> json) {
    final date = DateFormatter.parseDate(
      json[NotificationFields.createdOn.key] ?? "",
    );
    return NotificationDTO(
      notificationId: json[NotificationFields.id.key] as num,
      title: json[NotificationFields.title.key] as String,
      body: json[NotificationFields.body.key] as String,
      createdAt: date ?? DateTime.now(),
      target: json[NotificationFields.target1.key] as String?,
      isRead: json[NotificationFields.isRead.key] as bool,
      targetType: TargetType.fromId(json[NotificationFields.targetType.key]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      NotificationFields.id.key: notificationId,
      NotificationFields.title.key: title,
      NotificationFields.body.key: body,
      NotificationFields.target1.key: target,
      NotificationFields.isRead.key: isRead,
      NotificationFields.createdOn.key: createdAt.toIso8601String(),
      NotificationFields.targetType.key: targetType.id,
    };
  }
}
