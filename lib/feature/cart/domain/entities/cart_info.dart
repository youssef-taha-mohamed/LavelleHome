import 'package:equatable/equatable.dart';

base class CartInfo extends Equatable {
  final int cartId;
  final int count;
  // final bool isRepurchased;
  // final String? message;

  const CartInfo({
    required this.cartId,
    required this.count,
    // required this.isRepurchased,
    // this.message,
  });

  @override
  List<Object?> get props => [
        cartId,
        count,
        // isRepurchased,
        // message,
      ];
}
