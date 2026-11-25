import 'dart:convert';
import '../../domain/entities/app_status.dart';

final class AppStatusDTO extends AppStatus {
  const AppStatusDTO({required super.appStatus});

  AppStatusDTO copyWith({int? appStatus}) {
    return AppStatusDTO(
      appStatus: appStatus ?? this.appStatus,
    );
  }

  factory AppStatusDTO.fromJson(String json) {
    return AppStatusDTO.fromMap(jsonDecode(json));
  }
  factory AppStatusDTO.fromEntity(AppStatus entity) {
    return AppStatusDTO(
      appStatus: entity.appStatus,
    );
  }
  factory AppStatusDTO.fromMap(Map<String, dynamic> map) {
    return AppStatusDTO(
      appStatus: map['appStatus'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'appStatus': appStatus,
    };
  }

  String toJson() => jsonEncode(toMap());
}
