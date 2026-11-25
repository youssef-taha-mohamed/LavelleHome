import '../../../../../shared/model/api_response.dart';

abstract interface class CountryBaseDataSource {
  const CountryBaseDataSource();

  Future<ApiResponse<Map<String, dynamic>>> getCountries();
}
