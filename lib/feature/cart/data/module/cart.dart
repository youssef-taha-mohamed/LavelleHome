import 'dart:convert';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/enum/fields.dart';
import 'cart_item.dart';

final class CartDTO extends CartModel {
  const CartDTO({
    required super.cartId,
    required super.currency,
    required super.items,
    required super.total,
  });

  CartDTO copyWith({
    num? cartId,
    String? currency,
    num? total,
    List<CartItem>? items,
  }) {
    return CartDTO(
      cartId: cartId ?? this.cartId,
      currency: currency ?? this.currency,
      items: items ?? this.items,
      total: total ?? this.total,
    );
  }

  factory CartDTO.fromJson(String json) {
    return CartDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  factory CartDTO.fromMap(Map<String, dynamic> map) {
    return CartDTO(
      cartId: map[CartFields.id.value] as num,
      currency: map[CartFields.currency.value] != null
          ? map[CartFields.currency.value] as String
          : "",
      items: (map[CartFields.item.value] as List)
          .map((e) => CartItemDTO.fromMap(e))
          .toList(),
      total: map[CartFields.total.value] as num,
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      CartFields.id.value: cartId,
      CartFields.currency.value: currency,
      CartFields.total.value: total,
      CartFields.item.value:
          items.map((e) => CartItemDTO.fromEntity(e).toMap()).toList(),
    };
  }

  factory CartDTO.fromEntity(CartModel entity) {
    return CartDTO(
      cartId: entity.cartId,
      currency: entity.currency,
      items: entity.items,
      total: entity.total,
    );
  }
}
