import 'package:equatable/equatable.dart';

class CartParameters extends Equatable {
  final num cartId;
  final String? userId;
  final List<num>? listIds;
  final num? planId;

  const CartParameters({
    required this.cartId,
    this.userId,
    this.listIds,
    this.planId,
  });

  @override
  List<Object?> get props => [
        cartId,
        userId,
        listIds,
        planId,
      ];
}
