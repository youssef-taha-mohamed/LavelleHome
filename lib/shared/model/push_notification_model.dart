import 'package:equatable/equatable.dart';
import '../../feature/notifications/domain/enum/target_type.dart';

class PushNotificationModel extends Equatable {
  final String? entityId;
  final String? notificationId;
  final TargetType? notificationType;

  const PushNotificationModel({
    this.entityId,
    this.notificationId,
    this.notificationType,
  });

  PushNotificationModel copyWith({
    String? entityId,
    String? notificationId,
    TargetType? notificationType,
  }) {
    return PushNotificationModel(
      entityId: entityId ?? this.entityId,
      notificationId: notificationId ?? this.notificationId,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) {
    final int? parsedId =
        int.tryParse(json['NotificationType']?.toString() ?? '');
    final bool isIdValid = parsedId != null &&
        TargetType.values.any((element) => element.id == parsedId);
    return PushNotificationModel(
      entityId: json['EntityId'],
      notificationId: json['NotificationId'],
      notificationType: isIdValid ? TargetType.fromId(parsedId) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EntityId': entityId,
      'NotificationId': notificationId,
      'NotificationType': notificationType,
    };
  }

  @override
  List<Object?> get props {
    return [
      entityId,
      notificationId,
      notificationType,
    ];
  }
}
