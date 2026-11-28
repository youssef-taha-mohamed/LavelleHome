import '../../laundry/data/laundry_details.dart';

/// سطر في الطلب: صنف واحد من خدمة بكميته. يحمل نسخة من السعر والاسم وقت الاختيار
/// ليبقى ملخص الطلب مستقلاً عن شاشة تفاصيل المغسلة.
class OrderLine {
  final String key; // '${groupId}|${itemName}'
  final String groupId;
  final String groupName;
  final String itemName;
  final PricingUnit unit;
  final double unitPrice;
  final double quantity; // عدد قطع، كيلو، أو متر مربع حسب unit
  final GarmentFinish? finish;

  const OrderLine({
    required this.key,
    required this.groupId,
    required this.groupName,
    required this.itemName,
    required this.unit,
    required this.unitPrice,
    required this.quantity,
    this.finish
  });

  double get total => unitPrice * quantity;
}
