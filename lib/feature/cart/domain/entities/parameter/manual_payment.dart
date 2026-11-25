import 'dart:typed_data';
import 'package:equatable/equatable.dart';

base class ManualPaymentParameter extends Equatable {
  final String orderNumber;
  final String? note;
  final dynamic receiptFile;
  final Uint8List? receiptBytes;
  final String? fileName;

  const ManualPaymentParameter({
    required this.orderNumber,
    required this.note,
    this.receiptFile,
    this.receiptBytes,
    this.fileName,
  });

  @override
  List<Object?> get props =>
      [orderNumber, note, receiptFile, receiptBytes, fileName];
}
