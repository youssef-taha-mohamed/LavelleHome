import '../entities/address.dart';

abstract class AddressRepository {
  Future<List<SavedAddress>> list();
  Future<SavedAddress> add(AddressData data);
  Future<void> delete(String id);
  Future<String?> getSelectedId();
  Future<void> setSelectedId(String? id);
}

/// تخزين في الذاكرة للتجربة. استبدله بتنفيذ حقيقي:
/// المسجّل ← API، والضيف ← تخزين محلي (Hive).
class MockAddressRepository implements AddressRepository {
  final List<SavedAddress> _items;
  String? _selectedId;

  MockAddressRepository({bool withSamples = true})
    : _items = withSamples
          ? [
              const SavedAddress(
                id: 'a1',
                data: AddressData(
                  area: AddressArea.madinaty,
                  group: '36',
                  building: '12',
                  apartment: '21',
                ),
              ),
              const SavedAddress(
                id: 'a2',
                data: AddressData(
                  area: AddressArea.shorouk,
                  district: '1',
                  neighborhood: '1',
                  building: '36',
                  apartment: '12',
                ),
              ),
            ]
          : [],
      _selectedId = withSamples ? 'a1' : null;

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 300));

  @override
  Future<List<SavedAddress>> list() async {
    await _delay();
    return List.unmodifiable(_items);
  }

  @override
  Future<SavedAddress> add(AddressData data) async {
    await _delay();
    final saved = SavedAddress(
      id: 'a${DateTime.now().microsecondsSinceEpoch}',
      data: data,
    );
    _items.add(saved);
    return saved;
  }

  @override
  Future<void> delete(String id) async {
    await _delay();
    _items.removeWhere((a) => a.id == id);
    if (_selectedId == id) _selectedId = null;
  }

  @override
  Future<String?> getSelectedId() async => _selectedId;

  @override
  Future<void> setSelectedId(String? id) async => _selectedId = id;
}
