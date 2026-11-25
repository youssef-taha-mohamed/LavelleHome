import 'dart:convert';
import '../../../domain/entities/parameter/parameter.dart';
import '../../../domain/enum/fields.dart';

final class NotificationParameterDTO extends NotificationParameter {
  const NotificationParameterDTO({
    super.notificationId,
    super.childId,
  });

  @override
  NotificationParameterDTO copyWith({
    num? notificationId,
    String? childId,
    bool clearChildId = false,
  }) =>
      NotificationParameterDTO(
        notificationId: notificationId ?? this.notificationId,
        childId: clearChildId ? null : (childId ?? this.childId),
      );

  factory NotificationParameterDTO.fromJson(String json) {
    return NotificationParameterDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  factory NotificationParameterDTO.fromMap(Map<String, dynamic> map) {
    return NotificationParameterDTO(
      notificationId: map[NotificationFields.notificationId.key] != null
          ? map[NotificationFields.notificationId.key] as num
          : null,
      childId: map[NotificationFields.childId.key] != null
          ? map[NotificationFields.childId.key] as String
          : null,
    );
  }

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() {
    return {
      NotificationFields.notificationId.key: notificationId,
      NotificationFields.childId.key: childId,
    }..removeWhere(
        (key, value) => value == null || value == '',
      );
  }

  factory NotificationParameterDTO.fromEntity(NotificationParameter entity) {
    return NotificationParameterDTO(
      notificationId: entity.notificationId,
      childId: entity.childId,
    );
  }
}
