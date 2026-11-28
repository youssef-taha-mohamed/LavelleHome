part of 'order_draft_cubit.dart';
class OrderDraftState {
  final String? laundryId;
  final String? laundryName;

  /// رسوم التوصيل من بيانات المغسلة (null = غير محددة)
  final double? deliveryFee;

  /// عنوان الاستلام والتسليم (عنوان محفوظ كامل)
  final SavedAddress? pickupAddress;
  final Map<String, OrderLine> lines;

  const OrderDraftState({
    this.laundryId,
    this.laundryName,
    this.deliveryFee,
    this.pickupAddress,
    this.lines = const {},
  });

  List<OrderLine> get items => lines.values.toList();
  int get lineCount => lines.length;
  bool get isEmpty => lines.isEmpty;

  double get subtotal => lines.values.fold(0, (sum, l) => sum + l.total);

  /// أنواع الطلب الموجودة فعلاً (ملابس و/أو سجاد). تحدد وسيلة الاستلام المناسبة.
  List<OrderKind> get kinds => OrderKind.values
      .where((k) => lines.values.any((l) => l.kind == k))
      .toList();

  /// الخصم غير محسوب بعد (لا قواعد له)
  OrderPricing get pricing =>
      OrderPricing(subtotal: subtotal, deliveryFee: deliveryFee);

  double quantityOf(String key) => lines[key]?.quantity ?? 0;

  OrderDraftState withLines(Map<String, OrderLine> lines) => OrderDraftState(
    laundryId: laundryId,
    laundryName: laundryName,
    deliveryFee: deliveryFee,
    pickupAddress: pickupAddress,
    lines: lines,
  );
}