import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../../../domain/enum/fields.dart';

base class ExecutePaymentPara extends Equatable {
  final String orderNumber;
  final String studentId;
  final String paymentMethod;

  const ExecutePaymentPara({
    required this.orderNumber,
    required this.studentId,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [
        orderNumber,
        studentId,
        paymentMethod,
      ];
}

final class ExecutePaymentParaDTO extends ExecutePaymentPara {
  const ExecutePaymentParaDTO({
    required super.orderNumber,
    required super.studentId,
    required super.paymentMethod,
  });

  ExecutePaymentParaDTO copyWith({
    String? orderNumber,
    String? studentId,
    String? paymentMethod,
  }) {
    return ExecutePaymentParaDTO(
      orderNumber: orderNumber ?? this.orderNumber,
      studentId: studentId ?? this.studentId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  factory ExecutePaymentParaDTO.fromJson(String json) {
    return ExecutePaymentParaDTO.fromMap(
        Map<String, dynamic>.from(jsonDecode(json)));
  }

  factory ExecutePaymentParaDTO.fromMap(Map<String, dynamic> map) {
    return ExecutePaymentParaDTO(
      orderNumber: map[CartFields.orderNumber.value] as String,
      studentId: map[CartFields.studentId.value] as String,
      paymentMethod: map[CartFields.paymentMethod.value] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      CartFields.orderNumber.value: orderNumber,
      CartFields.studentId.value: studentId,
      CartFields.paymentMethod.value: paymentMethod,
    };
  }

  factory ExecutePaymentParaDTO.fromEntity(ExecutePaymentPara entity) {
    return ExecutePaymentParaDTO(
      orderNumber: entity.orderNumber,
      studentId: entity.studentId,
      paymentMethod: entity.paymentMethod,
    );
  }
}
