import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../domain/entities/parameter/manual_payment.dart';
import 'manual_payment_upload_helper.dart'
    if (dart.library.io) 'manual_payment_upload_helper_io.dart'
    if (dart.library.html) 'manual_payment_upload_helper_web.dart'
    if (dart.library.js_interop) 'manual_payment_upload_helper_web.dart';

final class ManualPaymentParameterDTO extends ManualPaymentParameter {
  const ManualPaymentParameterDTO({
    required super.orderNumber,
    super.note,
    super.receiptFile,
    super.receiptBytes,
    super.fileName,
  });

  factory ManualPaymentParameterDTO.fromEntity(
    ManualPaymentParameter entity,
  ) {
    return ManualPaymentParameterDTO(
      orderNumber: entity.orderNumber,
      note: entity.note,
      receiptFile: entity.receiptFile,
      receiptBytes: entity.receiptBytes,
      fileName: entity.fileName,
    );
  }

  Future<FormData> toFormData() async {
    final file = await ManualPaymentUploadHelper.getMultipartFile(
      receiptFile: receiptFile,
      receiptBytes: receiptBytes,
      fileName: fileName,
    );

    return FormData.fromMap({
      'orderNumber': orderNumber,
      if (note != null && note!.isNotEmpty) 'studentNote': note,
      'receiptFile': file,
    });
  }

  ManualPaymentParameterDTO copyWith({
    String? orderNumber,
    String? note,
    dynamic receiptFile,
    Uint8List? receiptBytes,
    String? fileName,
  }) {
    return ManualPaymentParameterDTO(
      orderNumber: orderNumber ?? this.orderNumber,
      note: note ?? this.note,
      receiptFile: receiptFile ?? this.receiptFile,
      receiptBytes: receiptBytes ?? this.receiptBytes,
      fileName: fileName ?? this.fileName,
    );
  }
}
