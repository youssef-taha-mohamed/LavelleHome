import '../../address/domain/entities/address.dart';

/// حدود الجزء المرئي من الخريطة (جنوب/غرب/شمال/شرق)
class MapBounds {
  final double south;
  final double west;
  final double north;
  final double east;

  const MapBounds({
    required this.south,
    required this.west,
    required this.north,
    required this.east,
  });

  /// مربع حول نقطة (delta بالدرجات، 0.05 ≈ 5.5 كم)
  factory MapBounds.around(GeoPoint center, {double delta = 0.05}) {
    return MapBounds(
      south: center.lat - delta,
      west: center.lng - delta,
      north: center.lat + delta,
      east: center.lng + delta,
    );
  }

  bool contains(GeoPoint p) =>
      p.lat >= south && p.lat <= north && p.lng >= west && p.lng <= east;
}

/// مركز افتراضي (القاهرة) لو لا يوجد موقع مختار
const GeoPoint kDefaultMapCenter = GeoPoint(30.0444, 31.2357);

const Map<AddressArea, GeoPoint> _areaCenters = {
  AddressArea.madinaty: GeoPoint(30.1070, 31.6360),
  AddressArea.shorouk: GeoPoint(30.1200, 31.6100),
};

/// مركز الخريطة الابتدائي من الموقع المختار:
/// GPS ← نقطته، عنوان في مدينتي/الشروق ← مركز المنطقة، غير ذلك ← الافتراضي
GeoPoint centerFor(SelectedLocation? selected) {
  if (selected == null) return kDefaultMapCenter;
  if (selected.point != null) return selected.point!;
  final area = selected.address?.data.area;
  return _areaCenters[area] ?? kDefaultMapCenter;
}
