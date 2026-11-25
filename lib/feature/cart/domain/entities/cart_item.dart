import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final num id;
  final num subjectId;
  final num planId;
  final String subjectName;
  final String packageName;
  final int sessionCount;
  final double totalPrice;
  final int duration;
  final String currency;
  final bool isPriceChanged;

  const CartItem({
    required this.id,
    required this.subjectId,
    required this.planId,
    required this.subjectName,
    required this.packageName,
    required this.sessionCount,
    required this.totalPrice,
    required this.duration,
    required this.currency,
    required this.isPriceChanged,
  });

  @override
  List<Object?> get props => [
        id,
        subjectName,
        packageName,
        sessionCount,
        totalPrice,
        duration,
        planId,
        subjectId,
        currency,
        isPriceChanged,
      ];
}
