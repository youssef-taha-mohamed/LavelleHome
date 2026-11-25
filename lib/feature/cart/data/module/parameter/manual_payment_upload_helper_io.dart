import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class ManualPaymentUploadHelper {
  static Future<MultipartFile> getMultipartFile({
    required dynamic receiptFile,
    required Uint8List? receiptBytes,
    String? fileName,
  }) async {
    if (receiptFile is File) {
      return await MultipartFile.fromFile(
        receiptFile.path,
        filename: receiptFile.path.split('/').last,
      );
    }
    return MultipartFile.fromBytes(
      receiptBytes!,
      filename: fileName ?? 'receipt.jpg',
    );
  }
}
