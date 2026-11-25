import 'dart:typed_data';
import 'package:dio/dio.dart';

class ManualPaymentUploadHelper {
  static Future<MultipartFile> getMultipartFile({
    required dynamic receiptFile,
    required Uint8List? receiptBytes,
    String? fileName,
  }) async {
    return MultipartFile.fromBytes(
      receiptBytes!,
      filename: fileName ?? 'receipt.jpg',
    );
  }
}
