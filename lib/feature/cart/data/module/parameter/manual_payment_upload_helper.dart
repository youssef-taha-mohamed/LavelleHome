import 'package:dio/dio.dart';
import 'dart:typed_data';

abstract class ManualPaymentUploadHelper {
  static Future<MultipartFile> getMultipartFile({
    required dynamic receiptFile,
    required Uint8List? receiptBytes,
    String? fileName,
  }) {
    throw UnimplementedError('Platform not supported');
  }
}
