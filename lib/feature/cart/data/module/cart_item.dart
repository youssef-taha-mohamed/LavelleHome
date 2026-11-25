import 'dart:convert';
import '../../domain/entities/cart_item.dart';
import '../../domain/enum/fields.dart';

final class CartItemDTO extends CartItem {
  const CartItemDTO({
    required super.id,
    required super.currency,
    required super.duration,
    required super.packageName,
    required super.planId,
    required super.sessionCount,
    required super.subjectId,
    required super.subjectName,
    required super.totalPrice,
    required super.isPriceChanged,
  });

  CartItemDTO copyWith({
    num? id,
    num? subjectId,
    num? planId,
    String? subjectName,
    String? packageName,
    int? sessionCount,
    double? totalPrice,
    int? duration,
    String? currency,
    bool? isPriceChanged,
  }) {
    return CartItemDTO(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      packageName: packageName ?? this.packageName,
      sessionCount: sessionCount ?? this.sessionCount,
      totalPrice: totalPrice ?? this.totalPrice,
      duration: duration ?? this.duration,
      currency: currency ?? this.currency,
      planId: planId ?? this.planId,
      subjectId: subjectId ?? this.subjectId,
      isPriceChanged: isPriceChanged ?? this.isPriceChanged,
    );
  }

  factory CartItemDTO.fromJson(String json) {
    return CartItemDTO.fromMap(
      Map<String, dynamic>.from(
        jsonDecode(json),
      ),
    );
  }

  factory CartItemDTO.fromMap(Map<String, dynamic> map) {
    return CartItemDTO(
      id: map[CartFields.id.value] as num,
      subjectName: map[CartFields.subjectName.value] as String,
      packageName: map[CartFields.planName.value] as String,
      sessionCount: map[CartFields.sessionsCount.value] as int,
      totalPrice: (map[CartFields.price.value] as num).toDouble(),
      duration: map[CartFields.duration.value] as int,
      currency: map[CartFields.currency.value] as String,
      planId: map[CartFields.planId.value] as num,
      subjectId: map[CartFields.subjectId.value] as num,
      isPriceChanged: (map[CartFields.isPriceChanged.value] as bool?) ?? false,
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      CartFields.id.value: id,
      CartFields.subjectName.value: subjectName,
      CartFields.planName.value: packageName,
      CartFields.sessionsCount.value: sessionCount,
      CartFields.price.value: totalPrice,
      CartFields.duration.value: duration,
      CartFields.currency.value: currency,
      CartFields.planId.value: planId,
      CartFields.subjectId.value: subjectId,
      CartFields.isPriceChanged.value: isPriceChanged,
    };
  }

  factory CartItemDTO.fromEntity(CartItem entity) {
    return CartItemDTO(
      id: entity.id,
      currency: entity.currency,
      duration: entity.duration,
      packageName: entity.packageName,
      planId: entity.planId,
      sessionCount: entity.sessionCount,
      subjectId: entity.subjectId,
      subjectName: entity.subjectName,
      totalPrice: entity.totalPrice,
      isPriceChanged: entity.isPriceChanged,
    );
  }

  // السعر الإجمالي منسق
  String get formattedTotalPrice => '${totalPrice.toStringAsFixed(0)} ';

  // المدة منسقة
  String get formattedDuration => '$duration ';

  // عدد الحصص منسق
  String get formattedSessionCount => '$sessionCount ';

  // التحقق من الحد الأقصى للحصص
  bool get hasMaximumSessions => sessionCount >= 16;

  // التحقق من الحد الأدنى للحصص
  bool get hasMinimumSessions => sessionCount <= 4;

  // إجمالي المدة لجميع الحصص
  int get totalDuration => duration * sessionCount;

  // إجمالي المدة منسق
  String get formattedTotalDuration {
    final hours = totalDuration ~/ 60;
    final minutes = totalDuration % 60;
    if (hours > 0) {
      return '$hours  $minutes ';
    }
    return '$minutes ';
  }
}
