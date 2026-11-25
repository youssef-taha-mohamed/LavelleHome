import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../base/client.dart';
import '../base/response.dart';

final class HttpNetworkClient implements NetworkClient {
  const HttpNetworkClient();

  @override
  Future<NetworkResponse> delete({
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await http.delete(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _adaptResponse(response);
  }

  @override
  Future<NetworkResponse> get({
    required Uri uri,
    Map<String, String>? headers,
  }) async {
    final response = await http.get(
      uri,
      headers: headers,
    );
    return _adaptResponse(response);
  }

  @override
  Future<NetworkResponse> head({
    required Uri uri,
    Map<String, String>? headers,
  }) async {
    final response = await http.head(
      uri,
      headers: headers,
    );
    return _adaptResponse(response);
  }

  @override
  Future<NetworkResponse> patch({
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await http.patch(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _adaptResponse(response);
  }

  @override
  Future<NetworkResponse> post({
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await http.post(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _adaptResponse(response);
  }

  @override
  Future<NetworkResponse> put({
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await http.put(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _adaptResponse(response);
  }


  @override
  Future<NetworkResponse> putMultipart({
    required Uri uri,
    Map<String, String>? headers,
    required Map<String, String> fields,
    Uint8List? fileBytes,
    String? fileName,
    String fileFieldName = 'image',
  }) async {
    final request = http.MultipartRequest('PUT', uri);

    // Add auth & custom headers (skip Content-Type — http sets it automatically)
    if (headers != null) {
      headers.forEach((key, value) {
        if (key.toLowerCase() != 'content-type') {
          request.headers[key] = value;
        }
      });
    }

    // Add text fields
    request.fields.addAll(fields);

    // Add file if provided
    if (fileBytes != null) {
      _guessMimeType(fileName);
      request.files.add(
        http.MultipartFile.fromBytes(
          fileFieldName,
          fileBytes,
          filename: fileName ?? 'image.jpg',
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _adaptResponse(response);
  }

  /// Guesses the MIME type from the file extension.
  String _guessMimeType(String? fileName) {
    if (fileName == null) return 'image/jpeg';
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }


  NetworkResponse _adaptResponse(http.Response response) {
    return NetworkResponse(
      statusCode: response.statusCode,
      body: response.body,
      headers: response.headers,
    );
  }
}
