import '../../../../shared/widgets/shared_widgets.dart';
import '../../domain/entities/address.dart';

String addressAreaLabel(BuildContext context, AddressArea area) {
  final l10n = context.l10n;
  switch (area) {
    case AddressArea.madinaty:
      return l10n.area_madinaty;
    case AddressArea.shorouk:
      return l10n.area_shorouk;
    case AddressArea.other:
      return l10n.area_other;
  }
}

IconData addressAreaIcon(AddressArea area) {
  switch (area) {
    case AddressArea.madinaty:
      return Icons.location_city_rounded;
    case AddressArea.shorouk:
      return Icons.apartment_rounded;
    case AddressArea.other:
      return Icons.add_location_alt_outlined;
  }
}

/// "مدينتي · 36-12-21" أو اسم المنطقة للعنوان الحر
String addressShortLabel(BuildContext context, AddressData d) {
  if (d.area == AddressArea.other) {
    return d.areaName.trim().isEmpty
        ? addressAreaLabel(context, d.area)
        : d.areaName.trim();
  }
  return '${addressAreaLabel(context, d.area)} · ${d.formatted}';
}

/// النص الظاهر في هيدر الرئيسية
String selectedLocationLabel(BuildContext context, SelectedLocation? s) {
  if (s == null) return context.l10n.select_location;
  if (s.address != null) return addressShortLabel(context, s.address!.data);
  return context.l10n.current_location;
}
