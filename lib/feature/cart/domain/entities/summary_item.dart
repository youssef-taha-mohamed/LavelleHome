import 'package:equatable/equatable.dart';

base class SummaryItem extends Equatable {
  final String planName;
  final String subjectName;
  final int sessionCount;
  final num price;
  final String currencyCode;
  final num duration;

  const SummaryItem({
    required this.planName,
    required this.subjectName,
    required this.sessionCount,
    required this.price,
    required this.currencyCode,
    required this.duration,
  });

  @override
  List<Object?> get props => [
        planName,
        subjectName,
        sessionCount,
        price,
        currencyCode,
        duration,
      ];
}
