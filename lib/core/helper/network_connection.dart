import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() => _instance;

  NetworkService._internal();

  final InternetConnection _connection = InternetConnection.createInstance(
    checkInterval: const Duration(seconds: 10),
    customCheckOptions: [
      InternetCheckOption(
        uri: Uri.parse('https://1.1.1.1'),
        timeout: const Duration(seconds: 30),
      ),
      InternetCheckOption(
        uri: Uri.parse('https://8.8.8.8'),
        timeout: const Duration(seconds: 30),
      ),
      InternetCheckOption(
        uri: Uri.parse('https://www.google.com'),
        timeout: const Duration(seconds: 30),
      ),
    ],
  );

  Future<bool> get isConnected async {
    if (kIsWeb) return true;
    return await _connection.hasInternetAccess;
  }

  Stream<InternetStatus> get onStatusChange {
    if (kIsWeb) {
      return Stream.value(InternetStatus.connected);
    }
    return _connection.onStatusChange;
  }
}
