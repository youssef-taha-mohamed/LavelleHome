import '../../../../core/constant/endpoint.dart';
import '../../../../core/network/client/base/client.dart';
import '../../../../core/network/response_handler/base/response_handler.dart';
import '../../../../shared/model/api_response.dart';
import 'base/datasource.dart';

class CountryDataSource implements CountryBaseDataSource {
  const CountryDataSource({required this._client, required this._handler});

  final NetworkClient _client;
  final ResponseHandler _handler;

  @override
  Future<ApiResponse<Map<String, dynamic>>> getCountries() async {
    final response = await _client.get(uri: Uri.parse(ApiEndPoint.getCountry));
    return _handler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200, 201, 202],
      expectedCasesHandler: (jsonBody, status) {
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
