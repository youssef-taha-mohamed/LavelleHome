import '../../../../shared/model/api_response.dart';
import '../entities/definitions.dart';

abstract interface class CountryBaseRepository {
  Future<ApiResponse<Definitions>> getCountries();
}
