import '../../../../shared/widgets/shared_widgets.dart';
import '../../../address/domain/entities/address.dart';
import '../../../address/presentation/widgets/address_labels.dart';

class AddressForm extends StatefulWidget {
  final AddressData? initial;
  final ValueChanged<AddressData> onChanged;

  const AddressForm({super.key, this.initial, required this.onChanged});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  late AddressArea _area;

  final _groupC = TextEditingController();
  final _districtC = TextEditingController();
  final _neighborhoodC = TextEditingController();
  final _buildingC = TextEditingController();
  final _apartmentC = TextEditingController();
  final _areaNameC = TextEditingController();
  final _detailsC = TextEditingController();

  final _groupF = FocusNode();
  final _districtF = FocusNode();
  final _neighborhoodF = FocusNode();
  final _buildingF = FocusNode();
  final _apartmentF = FocusNode();
  final _areaNameF = FocusNode();
  final _detailsF = FocusNode();

  late final List<TextEditingController> _controllers = [
    _groupC,
    _districtC,
    _neighborhoodC,
    _buildingC,
    _apartmentC,
    _areaNameC,
    _detailsC,
  ];

  @override
  void initState() {
    super.initState();
    final i = widget.initial ?? const AddressData();
    _area = i.area;
    _groupC.text = i.group;
    _districtC.text = i.district;
    _neighborhoodC.text = i.neighborhood;
    _buildingC.text = i.building;
    _apartmentC.text = i.apartment;
    _areaNameC.text = i.areaName;
    _detailsC.text = i.details;
    for (final c in _controllers) {
      c.addListener(_changed);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.removeListener(_changed);
      c.dispose();
    }
    for (final f in [
      _groupF,
      _districtF,
      _neighborhoodF,
      _buildingF,
      _apartmentF,
      _areaNameF,
      _detailsF,
    ]) {
      f.dispose();
    }
    super.dispose();
  }

  AddressData get _data => AddressData(
    area: _area,
    group: _groupC.text.trim(),
    district: _districtC.text.trim(),
    neighborhood: _neighborhoodC.text.trim(),
    building: _buildingC.text.trim(),
    apartment: _apartmentC.text.trim(),
    areaName: _areaNameC.text.trim(),
    details: _detailsC.text.trim(),
  );

  void _changed() {
    if (!mounted) return;
    setState(() {});
    widget.onChanged(_data);
  }

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final data = _data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainText(
          context.l10n.select_area,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: t.text,
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          children: [
            for (final a in AddressArea.values)
              Expanded(
                child: _AreaChip(
                  label: addressAreaLabel(context, a),
                  icon: addressAreaIcon(a),
                  selected: _area == a,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() => _area = a);
                    widget.onChanged(_data);
                  },
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // تبديل فوري للحقول + حركة في الارتفاع
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: Column(
            key: ValueKey<AddressArea>(_area),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _fields(context, t),
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: data.isValid
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _AddressPreview(
                    label: context.l10n.address_preview,
                    value: data.formatted,
                    isLtr: _area == AddressArea.madinaty,
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  List<Widget> _fields(BuildContext context, LavelleTheme t) {
    final l10n = context.l10n;

    switch (_area) {
      // 36-12-21
      case AddressArea.madinaty:
        return [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _num(
                context,
                t,
                l10n.group_number,
                '36',
                _groupC,
                _groupF,
                _buildingF,
              ),
              _num(
                context,
                t,
                l10n.building_number,
                '12',
                _buildingC,
                _buildingF,
                _apartmentF,
              ),
              _num(
                context,
                t,
                l10n.apartment_number,
                '21',
                _apartmentC,
                _apartmentF,
                null,
              ),
            ],
          ),
        ];

      // م١م١ع٣٦ش١٢
      case AddressArea.shorouk:
        return [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              _num(
                context,
                t,
                l10n.district_number,
                '1',
                _districtC,
                _districtF,
                _neighborhoodF,
              ),
              _num(
                context,
                t,
                l10n.neighborhood_number,
                '1',
                _neighborhoodC,
                _neighborhoodF,
                _buildingF,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              _num(
                context,
                t,
                l10n.building_number,
                '36',
                _buildingC,
                _buildingF,
                _apartmentF,
              ),
              _num(
                context,
                t,
                l10n.apartment_number,
                '12',
                _apartmentC,
                _apartmentF,
                null,
              ),
            ],
          ),
        ];

      // عنوان حر
      case AddressArea.other:
        return [
          MainTextField(
            withLabel: true,
            labelOut: l10n.area_name,
            controller: _areaNameC,
            currentFocusNode: _areaNameF,
            nextFocusNode: _detailsF,
            keyboardType: TextInputType.text,
            textDirection: context.isArabic
                ? TextDirection.rtl
                : TextDirection.ltr,
            prefixIcon: Icon(Icons.map_outlined, color: t.accent),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? l10n.field_required : null,
          ),
          const SizedBox(height: 16),
          MainTextField(
            withLabel: true,
            labelOut: l10n.address_details,
            controller: _detailsC,
            currentFocusNode: _detailsF,
            nextFocusNode: null,
            keyboardType: TextInputType.streetAddress,
            textDirection: context.isArabic
                ? TextDirection.rtl
                : TextDirection.ltr,
            prefixIcon: Icon(Icons.location_on_outlined, color: t.accent),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? l10n.field_required : null,
          ),
        ];
    }
  }

  /// حقل رقمي صغير بعنوان فوقه (يقبل الأرقام العربية والإنجليزية)
  Widget _num(
    BuildContext context,
    LavelleTheme t,
    String label,
    String hint,
    TextEditingController c,
    FocusNode focus,
    FocusNode? next,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainText(
            label,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: t.text,
          ),
          const SizedBox(height: 8),
          MainTextField(
            controller: c,
            currentFocusNode: focus,
            nextFocusNode: next,
            keyboardType: TextInputType.number,
            hint: hint,
            textDirection: TextDirection.ltr,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9٠-٩]')),
              LengthLimitingTextInputFormatter(4),
            ],
            validator: (v) => (v == null || v.trim().isEmpty)
                ? context.l10n.field_required
                : null,
          ),
        ],
      ),
    );
  }
}

class _AreaChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _AreaChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final radius = BorderRadius.circular(16);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: selected ? LavelleGradients.primary : null,
        color: selected ? null : t.accent.withValues(alpha: 0.05),
        border: Border.all(
          color: selected
              ? Colors.transparent
              : t.accent.withValues(alpha: 0.2),
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: t.accent.withValues(alpha: 0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Icon(icon, size: 24, color: selected ? Colors.white : t.accent),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: MainText(
                    label,
                    fontSize: 12.5,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected ? Colors.white : t.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// يعرض العنوان كما سيُحفظ (36-12-21 أو م١م١ع٣٦ش١٢)
class _AddressPreview extends StatelessWidget {
  final String label;
  final String value;
  final bool isLtr;

  const _AddressPreview({
    required this.label,
    required this.value,
    required this.isLtr,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: MyColors.skyBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MyColors.skyBlue.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(Icons.place_rounded, color: t.accent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                MainText(
                  label,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: t.text.withValues(alpha: 0.65),
                ),
                MainText(
                  value,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: t.accent,
                  textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
