import 'dart:convert';
import '../../../../core/network/client/base/client.dart';
import '../../../../core/network/response_handler/base/response_handler.dart';

class ConfigDataSource {
  ConfigDataSource({required this._client, required this._responseHandler});
  static const configurationsEndpoint = 'api/v1/list-configurations';

  final NetworkClient _client;
  final ResponseHandler _responseHandler;

  Future<List> getConfig() async {
    final response = await _client.get(uri: Uri.parse(configurationsEndpoint));
    return _responseHandler.handle<List>(
      response: response,
      expectedCases: [200, 201, 202],
      expectedCasesHandler: (record, status) {
        var jsonDecode = json.decode(response.body);
        var config = jsonDecode['data']['items'];
        return config;
      },
    );
  }
}
