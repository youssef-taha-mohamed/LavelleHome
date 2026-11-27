import '../../../laundry/data/module/laundry_model.dart';
import '../../../laundry/domain/repository/laundry_repository.dart';
import '../map_bounds.dart';

abstract class MapRepository {
  /// المغاسل داخل حدود الخريطة المرئية فقط، ليتحمّل التطبيق أي عدد من المغاسل
  /// دون تغيير التصميم (تحميل حسب المنطقة وليس الكل دفعة واحدة).
  Future<List<Laundry>> laundriesIn(MapBounds bounds);
}

enum MapScenario { normal, error, noConnection }

class MockMapRepository implements MapRepository {
  final MapScenario scenario;

  const MockMapRepository({this.scenario = MapScenario.normal});

  @override
  Future<List<Laundry>> laundriesIn(MapBounds bounds) async {
    await Future.delayed(const Duration(milliseconds: 600));

    switch (scenario) {
      case MapScenario.error:
        throw Exception('mock server error');
      case MapScenario.noConnection:
        throw const NoConnectionException();
      case MapScenario.normal:
        break;
    }

    // المغاسل بلا إحداثيات لا تظهر على الخريطة
    return MockHomeRepository.laundries
        .where((l) => l.location != null && bounds.contains(l.location!))
        .toList();
  }
}
