// المسار: lib/feature/address/domain/address.dart

/// المناطق المدعومة. لإضافة منطقة: أضف قيمة هنا ثم حالة في isValid و formatted
/// وفي حقول AddressForm.
enum AddressArea { madinaty, shorouk, other }

enum LocationPermissionStatus {
  unknown,
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

String _toLatin(String s) => s.replaceAllMapped(
  RegExp('[٠-٩]'),
  (m) => (m[0]!.codeUnitAt(0) - 0x0660).toString(),
);

String _toArabicDigits(String s) => s.replaceAllMapped(
  RegExp('[0-9]'),
  (m) => String.fromCharCode(0x0660 + int.parse(m[0]!)),
);

/// بيانات عنوان (بدون id). الشكل النهائي حسب المنطقة:
///   مدينتي:  36-12-21        (مجموعة - عمارة - شقة)
///   الشروق:  م١م١ع٣٦ش١٢      (منطقة - مجاورة - عمارة - شقة)
///   أخرى:    اسم المنطقة - التفاصيل
class AddressData {
  final AddressArea area;
  final String group;
  final String district;
  final String neighborhood;
  final String building;
  final String apartment;
  final String areaName;
  final String details;

  const AddressData({
    this.area = AddressArea.madinaty,
    this.group = '',
    this.district = '',
    this.neighborhood = '',
    this.building = '',
    this.apartment = '',
    this.areaName = '',
    this.details = '',
  });

  static bool _has(String s) => s.trim().isNotEmpty;

  bool get isValid {
    switch (area) {
      case AddressArea.madinaty:
        return _has(group) && _has(building) && _has(apartment);
      case AddressArea.shorouk:
        return _has(district) &&
            _has(neighborhood) &&
            _has(building) &&
            _has(apartment);
      case AddressArea.other:
        return _has(areaName) && _has(details);
    }
  }

  String get formatted {
    String lat(String s) => _toLatin(s.trim());
    String ar(String s) => _toArabicDigits(_toLatin(s.trim()));

    switch (area) {
      case AddressArea.madinaty:
        return '${lat(group)}-${lat(building)}-${lat(apartment)}';
      case AddressArea.shorouk:
        return 'م${ar(district)}م${ar(neighborhood)}ع${ar(building)}ش${ar(apartment)}';
      case AddressArea.other:
        return '${areaName.trim()} - ${details.trim()}';
    }
  }
}

class SavedAddress {
  final String id;
  final AddressData data;

  const SavedAddress({required this.id, required this.data});

  String get formatted => data.formatted;
}

class GeoPoint {
  final double lat;
  final double lng;

  const GeoPoint(this.lat, this.lng);
}

/// الموقع المختار حالياً: عنوان محفوظ، أو موقع GPS فقط.
/// ملاحظة: موقع GPS وحده يكفي لعرض المغاسل القريبة، لكن الطلب يحتاج عنواناً كاملاً.
class SelectedLocation {
  final SavedAddress? address;
  final GeoPoint? point;

  const SelectedLocation({this.address, this.point});

  bool get isCurrentPosition => address == null && point != null;

  /// مفتاح للمقارنة (هل تغيّر الموقع؟)
  String get key => address?.id ?? '${point?.lat},${point?.lng}';
}
