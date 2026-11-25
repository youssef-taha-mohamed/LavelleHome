import '../../../../shared/model/api_response.dart';
import '../entities/definitions.dart';
import '../repository/repository.dart';

final class FetchCountries {
  const FetchCountries({required this._repository});
  final CountryBaseRepository _repository;

  Future<ApiResponse<Definitions>> call() async {
    return _repository.getCountries();
  }
}
