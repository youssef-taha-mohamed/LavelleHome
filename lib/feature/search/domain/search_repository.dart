import '../../address/domain/entities/address.dart';
import '../../laundry/data/module/laundry_model.dart';
import '../../laundry/domain/repository/laundry_repository.dart';

abstract class SearchRepository {
  /// بحث بالاسم أو بالمنطقة فقط (لا فلاتر إضافية). [location] لترتيب/تحديد المغاسل القريبة.
  Future<List<Laundry>> search(String query, {SelectedLocation? location});
}

/// يوحّد الكتابة العربية للمقارنة: يشيل التشكيل ويوحّد الألف والياء والتاء المربوطة
String normalizeSearch(String s) {
  var r = s.trim().toLowerCase();
  r = r.replaceAll(RegExp('[\u064B-\u0652\u0640]'), '');
  r = r
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه');
  return r;
}

enum SearchScenario { normal, error, noConnection }

/// بحث تجريبي على بيانات الرئيسية. في الإنتاج الـ API هو من يبحث.
class MockSearchRepository implements SearchRepository {
  final SearchScenario scenario;

  const MockSearchRepository({this.scenario = SearchScenario.normal});

  @override
  Future<List<Laundry>> search(
    String query, {
    SelectedLocation? location,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    switch (scenario) {
      case SearchScenario.error:
        throw Exception('mock server error');
      case SearchScenario.noConnection:
        throw const NoConnectionException();
      case SearchScenario.normal:
        break;
    }

    final q = normalizeSearch(query);
    final results = MockHomeRepository.laundries.where((l) {
      return normalizeSearch(l.name).contains(q) ||
          normalizeSearch(l.area ?? '').contains(q);
    }).toList();

    results.sort(
      (a, b) => (a.distanceKm ?? 999).compareTo(b.distanceKm ?? 999),
    );
    return results;
  }
}

/// تخزين عمليات البحث الأخيرة محلياً (على الجهاز)
abstract class RecentSearchesStore {
  Future<List<String>> load();
  Future<void> save(List<String> items);
}

/// في الذاكرة للتجربة. بدّله بـ Hive/SharedPreferences.
class MockRecentSearchesStore implements RecentSearchesStore {
  static List<String> _items = [];

  const MockRecentSearchesStore();

  @override
  Future<List<String>> load() async => List.of(_items);

  @override
  Future<void> save(List<String> items) async => _items = List.of(items);
}
