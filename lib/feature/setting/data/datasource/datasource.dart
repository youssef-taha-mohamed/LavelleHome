import '../../../../core/network/client/base/client.dart';
import '../../../../core/network/response_handler/base/response_handler.dart';
import '../../../../shared/model/api_response.dart';
import '../../../../core/constant/endpoint.dart';
import 'base/base_datasource.dart';

class SettingDataSource implements SettingBaseDataSource {
  const SettingDataSource({required this._client, required this._handler});

  final NetworkClient _client;
  final ResponseHandler _handler;

  @override
  Future<ApiResponse<Map<String, dynamic>>> getAppStatus() async {
    final response = await _client.get(uri: Uri.parse(ApiEndPoint.appStatus));
    return _handler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }
}
