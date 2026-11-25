import 'package:equatable/equatable.dart';

base class Countries extends Equatable {
  final String name;
  final String code;
  final String flag;
  final num id;
  final String isoCode;

  const Countries({
    required this.name,
    required this.code,
    required this.flag,
    required this.id,
    required this.isoCode,
  });

  @override
  List<Object?> get props => [
        name,
        code,
        id,
        flag,
        isoCode,
      ];
}
