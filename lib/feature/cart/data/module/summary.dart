import 'dart:convert';
import '../../domain/entities/summary.dart';
import '../../domain/entities/summary_item.dart';
import '../../domain/enum/fields.dart';
import 'summary_item.dart';

final class OrderSummaryDTO extends OrderSummary {
  const OrderSummaryDTO({
    required super.currencyCode,
    required super.items,
    required super.orderNumber,
    required super.tax,
    required super.totalAfterTax,
    required super.totalPrice,
  });

  OrderSummaryDTO copyWith({
    String? orderNumber,
    num? totalPrice,
    num? tax,
    num? totalAfterTax,
    String? currencyCode,
    List<SummaryItem>? items,
  }) {
    return OrderSummaryDTO(
      currencyCode: currencyCode ?? this.currencyCode,
      items: items ?? this.items,
      orderNumber: orderNumber ?? this.orderNumber,
      tax: tax ?? this.tax,
      totalAfterTax: totalAfterTax ?? this.totalAfterTax,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  factory OrderSummaryDTO.fromJson(String json) {
    return OrderSummaryDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory OrderSummaryDTO.fromMap(Map<String, dynamic> json) {
    return OrderSummaryDTO(
      totalAfterTax: json[CartFields.totalAfterTax.value] as num,
      tax: json[CartFields.tax.value] as num,
      totalPrice: json[CartFields.total.value] as num,
      currencyCode: json[CartFields.currency.value] as String,
      items: (json[CartFields.items.value] as List)
          .map((e) => SummaryItemDTO.fromMap(e))
          .toList(),
      orderNumber: json[CartFields.orderNumber.value] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      CartFields.totalAfterTax.value: totalAfterTax,
      CartFields.tax.value: tax,
      CartFields.total.value: totalPrice,
      CartFields.currency.value: currencyCode,
      CartFields.items.value:
          items.map((e) => SummaryItemDTO.fromEntity(e).toMap()).toList(),
      CartFields.orderNumber.value: orderNumber,
    };
  }
}
