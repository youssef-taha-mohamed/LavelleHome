import '../../../../shared/model/api_response.dart';
import '../../domain/entities/definitions.dart';
import '../../domain/repository/repository.dart';
import '../datasource/base/datasource.dart';

class CountryRepository implements CountryBaseRepository {
  const CountryRepository({required this._dataSource});

  final CountryBaseDataSource _dataSource;

  @override
  Future<ApiResponse<Definitions>> getCountries() async {
    final result = await _dataSource.getCountries();
    return result.map((recordList) {
      return DefinitionsDTO.fromMap(recordList);
    });
  }
}
