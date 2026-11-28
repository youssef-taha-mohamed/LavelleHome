// المسار: lib/feature/order/presentation/widgets/measure_sheet.dart
// نافذة إدخال الكمية للأصناف المسعّرة بالكيلو أو بالمتر المربع.
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../../laundry/data/laundry_details.dart';
import '../../../../laundry/presentation/view/widgets/laundry_details_section.dart';
import '../../order_formatters.dart';

/// [initial] = الكمية الحالية (0 لو غير مضافة). [onSave] يستقبل الكمية الجديدة،
/// وتمرير 0 يعني إزالة الصنف.
Future<void> showMeasureSheet(
  BuildContext context, {
  required PriceItem item,
  required double initial,
  required ValueChanged<double> onSave,
}) {
  return showLavelleSheet<void>(
    context,
    title: item.name,
    builder: (_) =>
        _MeasureSheetBody(item: item, initial: initial, onSave: onSave),
  );
}

class _MeasureSheetBody extends StatefulWidget {
  final PriceItem item;
  final double initial;
  final ValueChanged<double> onSave;

  const _MeasureSheetBody({
    required this.item,
    required this.initial,
    required this.onSave,
  });

  @override
  State<_MeasureSheetBody> createState() => _MeasureSheetBodyState();
}

class _MeasureSheetBodyState extends State<_MeasureSheetBody> {
  late final TextEditingController _controller;
  final FocusNode _focus = FocusNode();

  bool get _isKg => widget.item.unit == PricingUnit.kg;

  List<double> get _quick =>
      _isKg ? const [1, 2, 3, 5, 10] : const [4, 6, 9, 12];

  double? get _value => parseQuantity(_controller.text);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initial > 0 ? formatQuantity(widget.initial) : '',
    )..addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _setQuick(double v) {
    _controller.text = formatQuantity(v);
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
  }

  void _save(double value) {
    widget.onSave(value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = LavelleTheme.of(context);
    final value = _value;
    final total = value == null ? null : value * widget.item.price;
    final editing = widget.initial > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainText(
            '${formatMoney(widget.item.price)} ${l10n.currency_egp} · ${pricingUnitLabel(context, widget.item.unit)}',
            fontSize: 13,
            color: t.subText,
          ),
          const SizedBox(height: 16),
          MainText(
            _isKg ? l10n.enter_weight : l10n.enter_area,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: t.text,
          ),
          const SizedBox(height: 8),
          MainTextField(
            controller: _controller,
            currentFocusNode: _focus,
            nextFocusNode: null,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hint: '0',
            textDirection: TextDirection.ltr,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9٠-٩.,٫،]')),
              LengthLimitingTextInputFormatter(6),
            ],
          ),
          const SizedBox(height: 14),
          MainText(
            l10n.quick_pick,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: t.subText,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final q in _quick)
                ActionChip(
                  label: MainText(
                    quantityLabel(context, widget.item.unit, q),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: t.accent,
                  ),
                  backgroundColor: t.accent.withValues(alpha: 0.08),
                  side: BorderSide(color: t.accent.withValues(alpha: 0.25)),
                  onPressed: () => _setQuick(q),
                ),
            ],
          ),
          const SizedBox(height: 18),
          if (total != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Expanded(
                    child: MainText(
                      l10n.item_total,
                      fontSize: 13,
                      color: t.subText,
                    ),
                  ),
                  MainText(
                    '${formatMoney(total)} ${l10n.currency_egp}',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: t.accent,
                  ),
                ],
              ),
            ),
          LavelleButton(
            title: editing ? l10n.update_quantity : l10n.add_to_order,
            icon: Icons.check_rounded,
            isDimmed: value == null,
            onTap: () {
              if (value != null) _save(value);
            },
          ),
          if (editing)
            Center(
              child: TextButton(
                onPressed: () => _save(0),
                child: MainText(
                  l10n.remove_item,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
