// المسار: lib/feature/order/domain/order_pricing.dart

/// تسعير الطلب. الأسعار نفسها ثابتة كما حددتها المغسلة، والإجمالي يبقى تقديرياً.
/// discount و deliveryFee اختياريان: null = غير موجود ولا يظهر في الملخص.
class OrderPricing {
  final double subtotal;
  final double? discount;
  final double? deliveryFee;

  const OrderPricing({required this.subtotal, this.discount, this.deliveryFee});

  double get total => subtotal - (discount ?? 0) + (deliveryFee ?? 0);
}
