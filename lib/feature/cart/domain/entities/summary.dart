import 'package:equatable/equatable.dart';
import 'summary_item.dart';

base class OrderSummary extends Equatable {
  final String orderNumber;
  final num totalPrice;
  final num tax;
  final num totalAfterTax;
  final String currencyCode;
  final List<SummaryItem> items;

  const OrderSummary({
    required this.totalAfterTax,
    required this.tax,
    required this.totalPrice,
    required this.currencyCode,
    required this.items,
    required this.orderNumber,
  });

  num get numberOfSession {
    return items.fold(
      0,
      (previousValue, item) => previousValue + item.sessionCount,
    );
  }

  @override
  List<Object?> get props => [
        totalAfterTax,
        tax,
        currencyCode,
        items,
        currencyCode,
        orderNumber,
      ];
}
