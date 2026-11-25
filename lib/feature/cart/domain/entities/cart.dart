import 'package:equatable/equatable.dart';
import 'cart_item.dart';

base class CartModel extends Equatable {
  final num cartId;
  final String currency;
  final num total;
  final List<CartItem> items;

  const CartModel({
    required this.cartId,
    required this.currency,
    required this.items,
    required this.total,
  });

  @override
  List<Object?> get props => [
        cartId,
        currency,
        items,
        total,
      ];
}
