import '../../../shared/widgets/shared_widgets.dart';
import '../../laundry/data/laundry_details.dart';

/// 12 → "12"، 12.5 → "12.5"، 12.05 → "12.05"
String formatMoney(double v) {
  final r = (v * 100).round() / 100;
  if (r % 1 == 0) return r.toInt().toString();
  return r.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
}

String formatQuantity(double q) => formatMoney(q);

/// يقبل الأرقام العربية والفاصلة العربية أو العادية. null لو غير صالح أو ≤ 0
double? parseQuantity(String raw) {
  var s = raw
      .trim()
      .replaceAll('٫', '.')
      .replaceAll('،', '.')
      .replaceAll(',', '.');
  s = s.replaceAllMapped(
    RegExp('[٠-٩]'),
    (m) => (m[0]!.codeUnitAt(0) - 0x0660).toString(),
  );
  final v = double.tryParse(s);
  return (v == null || v <= 0) ? null : v;
}

/// "×3" للقطع، "2.5 كجم" للوزن، "12 م²" للمساحة
String quantityLabel(BuildContext context, PricingUnit unit, double q) {
  final n = formatQuantity(q);
  final l10n = context.l10n;
  switch (unit) {
    case PricingUnit.piece:
      return '×$n';
    case PricingUnit.kg:
      return '$n ${l10n.qty_unit_kg}';
    case PricingUnit.squareMeter:
      return '$n ${l10n.qty_unit_sqm}';
  }
}

String garmentFinishLabel(BuildContext context, GarmentFinish finish) {
  final l10n = context.l10n;
  return finish == GarmentFinish.hanging
      ? l10n.finish_hanging
      : l10n.finish_folded;
}

IconData garmentFinishIcon(GarmentFinish finish) =>
    finish == GarmentFinish.hanging
    ? Icons.checkroom_rounded
    : Icons.layers_rounded;

String orderKindLabel(BuildContext context, OrderKind kind) {
  final l10n = context.l10n;
  return kind == OrderKind.clothes
      ? l10n.order_kind_clothes
      : l10n.order_kind_carpet;
}

IconData orderKindIcon(OrderKind kind) =>
    kind == OrderKind.clothes ? Icons.checkroom_rounded : Icons.texture_rounded;
