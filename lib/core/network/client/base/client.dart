import 'dart:convert';
import 'dart:typed_data';
import 'response.dart';

abstract interface class NetworkClient {
  const NetworkClient();

  Future<NetworkResponse> head({
    required Uri uri,
    Map<String, String>? headers,
  });

  Future<NetworkResponse> get({
    required Uri uri,
    Map<String, String>? headers,
  });

  Future<NetworkResponse> post({
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });

  Future<NetworkResponse> put({
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });

  Future<NetworkResponse> patch({
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });

  Future<NetworkResponse> delete({
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });

    /// Sends a multipart PUT request.
  ///
  /// [fields] are the text form fields.
  /// [fileBytes] is the raw bytes of the file (used on Web and Mobile).
  /// [fileName] is the filename to attach (e.g. 'profile.jpg').
  /// [fileFieldName] is the form field name expected by the backend (e.g. 'image').
  Future<NetworkResponse> putMultipart({
    required Uri uri,
    Map<String, String>? headers,
    required Map<String, String> fields,
    Uint8List? fileBytes,
    String? fileName,
    String fileFieldName,
  });
}
