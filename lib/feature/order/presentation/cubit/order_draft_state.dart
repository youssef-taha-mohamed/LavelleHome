// مسوّدة الطلب الحالية (مغسلة واحدة في كل مرة). يُوفَّر مرة واحدة فوق MaterialApp
// لأن شاشات الطلب (الاختيار، الملخص، العنوان، الدفع) كلها تقرؤه.

part of 'order_draft_cubit.dart';

class OrderDraftState {
  final String? laundryId;
  final String? laundryName;
  final OrderKind? kind; // نوع الطلب: ملابس أو سجاد (واحد فقط لكل طلب)
  final Map<String, OrderLine> lines;

  const OrderDraftState({
    this.laundryId,
    this.laundryName,
    this.kind,
    this.lines = const {},
  });

  List<OrderLine> get items => lines.values.toList();
  int get lineCount => lines.length;
  bool get isEmpty => lines.isEmpty;

  double get subtotal => lines.values.fold(0, (sum, l) => sum + l.total);

  /// الخصم غير محسوب بعد (لا قواعد له)، ورسوم التوصيل من order_config
  OrderPricing get pricing =>
      OrderPricing(subtotal: subtotal, deliveryFee: kDeliveryFee);

  double quantityOf(String key) => lines[key]?.quantity ?? 0;

  OrderDraftState copyWith({OrderKind? kind, Map<String, OrderLine>? lines}) {
    return OrderDraftState(
      laundryId: laundryId,
      laundryName: laundryName,
      kind: kind ?? this.kind,
      lines: lines ?? this.lines,
    );
  }
}
