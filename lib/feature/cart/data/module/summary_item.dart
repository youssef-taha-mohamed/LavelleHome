import 'dart:convert';
import '../../domain/entities/summary_item.dart';
import '../../domain/enum/fields.dart';

final class SummaryItemDTO extends SummaryItem {
  const SummaryItemDTO({
    required super.currencyCode,
    required super.duration,
    required super.planName,
    required super.price,
    required super.sessionCount,
    required super.subjectName,
  });

  SummaryItemDTO copyWith({
    String? planName,
    String? subjectName,
    int? sessionCount,
    num? price,
    String? currencyCode,
    num? duration,
  }) {
    return SummaryItemDTO(
      currencyCode: currencyCode ?? this.currencyCode,
      duration: duration ?? this.duration,
      planName: planName ?? this.planName,
      price: price ?? this.price,
      sessionCount: sessionCount ?? this.sessionCount,
      subjectName: subjectName ?? this.subjectName,
    );
  }

  factory SummaryItemDTO.fromJson(String json) {
    return SummaryItemDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory SummaryItemDTO.fromMap(Map<String, dynamic> json) {
    return SummaryItemDTO(
      planName: json[CartFields.subscribePlanName.value] as String,
      subjectName: json[CartFields.subjectName.value] as String,
      sessionCount: json[CartFields.sessionsCount.value] as int,
      price: json[CartFields.unitPrice.value] as num,
      currencyCode: json[CartFields.currency.value] as String,
      duration: json[CartFields.duration.value] as num,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      CartFields.subscribePlanName.value: planName,
      CartFields.subjectName.value: subjectName,
      CartFields.sessionsCount.value: sessionCount,
      CartFields.unitPrice.value: price,
      CartFields.currency.value: currencyCode,
      CartFields.duration.value: duration,
    };
  }

  factory SummaryItemDTO.fromEntity(SummaryItem entity) {
    return SummaryItemDTO(
      currencyCode: entity.currencyCode,
      duration: entity.duration,
      planName: entity.planName,
      price: entity.price,
      sessionCount: entity.sessionCount,
      subjectName: entity.subjectName,
    );
  }
}
