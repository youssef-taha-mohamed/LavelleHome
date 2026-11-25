import 'dart:convert';
import '../../domain/entities/cart_info.dart';
import '../../domain/enum/fields.dart';

final class CartInfoDTO extends CartInfo {
  const CartInfoDTO({
    required super.cartId,
    required super.count,
    // required super.isRepurchased,
    // super.message,
  });

  CartInfoDTO copyWith({
    int? cartId,
    int? count,
    bool? isRepurchased,
    String? message,
  }) {
    return CartInfoDTO(
      cartId: cartId ?? this.cartId,
      count: count ?? this.count,
      // isRepurchased: isRepurchased ?? this.isRepurchased,
      // message: message ?? this.message,
    );
  }

  factory CartInfoDTO.fromJson(String json) {
    return CartInfoDTO.fromMap(
      Map<String, dynamic>.from(jsonDecode(json)),
    );
  }

  factory CartInfoDTO.fromMap(Map<String, dynamic> map) {
    return CartInfoDTO(
      cartId: map[CartFields.id.value] as int,
      count: map[CartFields.count.value] as int,
      // isRepurchased: (map[CartFields.isRepurchased.value] as bool?) ?? false,
      // message: map[CartFields.message.value] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      CartFields.id.value: cartId,
      CartFields.count.value: count,
      // CartFields.isRepurchased.value: isRepurchased,
      // CartFields.message.value: message,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory CartInfoDTO.fromEntity(CartInfo entity) {
    return CartInfoDTO(
      cartId: entity.cartId,
      count: entity.count,
      // isRepurchased: entity.isRepurchased,
      // message: entity.message,
    );
  }
}
