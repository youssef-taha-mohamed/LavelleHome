import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../core/utils/app_responsive.dart';
import '../../../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../otp_register/view/otp_register.dart';
import '../cubit/register_cubit.dart';

/// المناطق المدعومة. لإضافة منطقة جديدة: أضف قيمة هنا ثم حالة في
/// [_isAddressValid] و[_formattedAddress] و[_buildAddressFields].
enum _Area { madinaty, shorouk, other }

class RegisterView extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final RegisterCubit _cubit;
  final _formKey = GlobalKey<FormState>();

  _Area _area = _Area.madinaty;
  PhoneNumber? _phone;

  // ── Controllers ──
  final _nameC = TextEditingController();
  final _phoneC = TextEditingController();
  // مدينتي: المجموعة - العمارة - الشقة
  final _groupC = TextEditingController();
  // الشروق: المنطقة - المجاورة - العمارة - الشقة
  final _districtC = TextEditingController();
  final _neighborhoodC = TextEditingController();
  // مشتركة بين مدينتي والشروق
  final _buildingC = TextEditingController();
  final _apartmentC = TextEditingController();
  // منطقة أخرى: عنوان حر
  final _areaNameC = TextEditingController();
  final _detailsC = TextEditingController();

  // ── Focus nodes ──
  final _nameF = FocusNode();
  final _phoneF = FocusNode();
  final _groupF = FocusNode();
  final _districtF = FocusNode();
  final _neighborhoodF = FocusNode();
  final _buildingF = FocusNode();
  final _apartmentF = FocusNode();
  final _areaNameF = FocusNode();
  final _detailsF = FocusNode();

  late final List<TextEditingController> _controllers = [
    _nameC,
    _phoneC,
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
    _cubit = context.read<RegisterCubit>();
    for (final c in _controllers) {
      c.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.removeListener(_onChanged);
      c.dispose();
    }
    for (final f in [
      _nameF,
      _phoneF,
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

  void _onChanged() {
    if (mounted) setState(() {});
  }

  // ───────────────────────── التحقق وتكوين العنوان ─────────────────────────

  bool _has(TextEditingController c) => c.text.trim().isNotEmpty;

  bool get _isNameValid => _nameC.text.trim().length >= 3;

  bool get _isPhoneValid =>
      _phone != null &&
      _phone!.completeNumber.replaceAll(RegExp(r'\D'), '').length >= 11;

  bool get _isAddressValid {
    switch (_area) {
      case _Area.madinaty:
        return _has(_groupC) && _has(_buildingC) && _has(_apartmentC);
      case _Area.shorouk:
        return _has(_districtC) &&
            _has(_neighborhoodC) &&
            _has(_buildingC) &&
            _has(_apartmentC);
      case _Area.other:
        return _has(_areaNameC) && _has(_detailsC);
    }
  }

  bool get _isFormValid => _isNameValid && _isPhoneValid && _isAddressValid;

  /// ٣٦ → 36
  String _toLatin(String s) => s.replaceAllMapped(
    RegExp('[٠-٩]'),
    (m) => (m[0]!.codeUnitAt(0) - 0x0660).toString(),
  );

  /// 36 → ٣٦
  String _toArabicDigits(String s) => s.replaceAllMapped(
    RegExp('[0-9]'),
    (m) => String.fromCharCode(0x0660 + int.parse(m[0]!)),
  );

  /// مدينتي:  36-12-21        (مجموعة - عمارة - شقة)
  /// الشروق:  م١م١ع٣٦ش١٢      (منطقة - مجاورة - عمارة - شقة)
  /// أخرى:    اسم المنطقة - التفاصيل
  String get _formattedAddress {
    String lat(TextEditingController c) => _toLatin(c.text.trim());
    String ar(TextEditingController c) =>
        _toArabicDigits(_toLatin(c.text.trim()));

    switch (_area) {
      case _Area.madinaty:
        return '${lat(_groupC)}-${lat(_buildingC)}-${lat(_apartmentC)}';
      case _Area.shorouk:
        return 'م${ar(_districtC)}م${ar(_neighborhoodC)}ع${ar(_buildingC)}ش${ar(_apartmentC)}';
      case _Area.other:
        return '${_areaNameC.text.trim()} - ${_detailsC.text.trim()}';
    }
  }

  FocusNode get _firstAddressFocus {
    switch (_area) {
      case _Area.madinaty:
        return _groupF;
      case _Area.shorouk:
        return _districtF;
      case _Area.other:
        return _areaNameF;
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid || !_isFormValid) {
      ToastService.showError(
        context,
        context.l10n.please_fill_all_required_fields,
      );
      return;
    }

    _cubit.register(
      fullName: _nameC.text.trim(),
      phone: _phone!,
      area: _area.name, // madinaty | shorouk | other
      address: _formattedAddress,
    );
  }

  // ───────────────────────── الواجهة ─────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDark = context.isDark;
    final accent = isDark ? MyColors.skyBlue : MyColors.primaryColor;

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: _stateHandler,
      builder: (context, state) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = MediaQuery.of(context).size.height;
              final heroHeight = (screenHeight * 0.34).clamp(280.0, 340.0);
              final topInset = MediaQuery.of(context).padding.top;

              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: heroHeight,
                              child: const _HeroBackground(),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                AppResponsive.getPadding(context),
                                topInset + 20,
                                AppResponsive.getPadding(context),
                                32,
                              ),
                              child: Column(
                                children: [
                                  _Reveal(child: _buildHeader(context)),
                                  28.ph,
                                  _Reveal(
                                    begin: 0.2,
                                    dy: 40,
                                    child: _buildCard(
                                      context: context,
                                      state: state,
                                      colors: colors,
                                      isDark: isDark,
                                      accent: accent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // زر الرجوع الزجاجي
                    PositionedDirectional(
                      top: topInset + 8,
                      start: 16,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.16),
            border: Border.all(
              color: MyColors.skyBlue.withValues(alpha: 0.55),
              width: 1.2,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              height: 58,
              width: 58,
              child: const Center(child: AppLogo()),
            ),
          ),
        ),
        14.ph,
        MainText(
          context.l10n.create_account,
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          textAlign: TextAlign.center,
          letterSpacing: 0.3,
        ),
        6.ph,
        MainText(
          context.l10n.register_subtitle,
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 13.5,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required RegisterState state,
    required AppColorsExtension colors,
    required bool isDark,
    required Color accent,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
      decoration: BoxDecoration(
        color: isDark ? MyColors.darkItemBG5 : MyColors.cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: MyColors.skyBlue.withValues(alpha: isDark ? 0.18 : 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : MyColors.primaryColor.withValues(alpha: 0.15),
            blurRadius: 40,
            spreadRadius: -4,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── 1) البيانات الشخصية ─────
            _SectionHeader(
              icon: Icons.person_rounded,
              title: context.l10n.personal_information,
              color: colors.textColor,
            ),
            12.ph,
            MainTextField(
              withLabel: true,
              labelOut: context.l10n.full_name,
              controller: _nameC,
              currentFocusNode: _nameF,
              nextFocusNode: _phoneF,
              hint: context.l10n.please_enter_name,
              keyboardType: TextInputType.name,
              textDirection: context.isArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              prefixIcon: Icon(Icons.person_outline, color: accent),
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.startsWith(' ')) return oldValue;
                  if (newValue.text.contains('  ')) return oldValue;
                  if (newValue.text.length > 40) return oldValue;
                  return newValue;
                }),
              ],
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return context.l10n.full_name_validation;
                }
                return null;
              },
            ),
            12.ph,
            CustomPhone(
              controller: _phoneC,
              label: context.l10n.phone_number,
              allowCountryChange: true,
              currentFocusNode: _phoneF,
              nextFocusNode: _firstAddressFocus,
              showClearButton: true,
              unFocusWhenTapOutside: true,
              textDirection: TextDirection.ltr,
              initialCountryCode: 'EG',
              onChangedPhoneNumber: (PhoneNumber number) {
                _phone = number;
                _onChanged();
              },
              validator: (phone) {
                if (phone == null || phone.completeNumber.isEmpty) {
                  return context.l10n.please_enter_your_phone_number;
                }
                return null;
              },
            ),

            16.ph,
            _softDivider(),
            16.ph,

            // ───── 2) العنوان ─────
            _SectionHeader(
              icon: Icons.location_on_rounded,
              title: context.l10n.delivery_address,
              color: colors.textColor,
            ),
            12.ph,
            MainText(
              context.l10n.select_area,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.textColor,
            ),
            8.ph,
            _buildAreaSelector(context, colors, accent),
            12.ph,

            // الحقول تتغير حسب المنطقة (تبديل فوري + حركة في الارتفاع)
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: Column(
                key: ValueKey<_Area>(_area),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildAddressFields(context, colors, accent),
              ),
            ),

            // معاينة شكل العنوان النهائي
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: _isAddressValid
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _AddressPreview(
                        label: context.l10n.address_preview,
                        value: _formattedAddress,
                        isLtr: _area == _Area.madinaty,
                        accent: accent,
                        textColor: colors.textColor,
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),

            16.ph,

            // زر التسجيل
            _GradientButton(
              title: context.l10n.register,
              isDimmed: !_isFormValid,
              isLoading: state.isLoading,
              onTap: _submit,
            ),

            12.ph,
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  MainText(
                    context.l10n.you_have_account,
                    fontSize: 12.5,
                    color: colors.subTextColor,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: MainText(
                      context.l10n.login,
                      color: accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _softDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.skyBlue.withValues(alpha: 0.0),
            MyColors.skyBlue.withValues(alpha: 0.55),
            MyColors.skyBlue.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }

  // ───────────────────────── اختيار المنطقة ─────────────────────────

  Widget _buildAreaSelector(
    BuildContext context,
    AppColorsExtension colors,
    Color accent,
  ) {
    final options = [
      (_Area.madinaty, context.l10n.area_madinaty, Icons.location_city_rounded),
      (_Area.shorouk, context.l10n.area_shorouk, Icons.apartment_rounded),
      (_Area.other, context.l10n.area_other, Icons.add_location_alt_outlined),
    ];

    return Row(
      spacing: 10,
      children: [
        for (final o in options)
          Expanded(
            child: _AreaChip(
              label: o.$2,
              icon: o.$3,
              selected: _area == o.$1,
              accent: accent,
              textColor: colors.textColor,
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() => _area = o.$1);
              },
            ),
          ),
      ],
    );
  }

  // ───────────────────────── حقول العنوان حسب المنطقة ─────────────────────────

  List<Widget> _buildAddressFields(
    BuildContext context,
    AppColorsExtension colors,
    Color accent,
  ) {
    switch (_area) {
      // 36-12-21  →  مجموعة 36 / عمارة 12 / شقة 21
      case _Area.madinaty:
        return [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _numField(
                context,
                colors,
                label: context.l10n.group_number,
                hint: '36',
                controller: _groupC,
                focus: _groupF,
                next: _buildingF,
              ),
              _numField(
                context,
                colors,
                label: context.l10n.building_number,
                hint: '12',
                controller: _buildingC,
                focus: _buildingF,
                next: _apartmentF,
              ),
              _numField(
                context,
                colors,
                label: context.l10n.apartment_number,
                hint: '21',
                controller: _apartmentC,
                focus: _apartmentF,
              ),
            ],
          ),
        ];

      // م١م١ع٣٦ش١٢  →  منطقة 1 / مجاورة 1 / عمارة 36 / شقة 12
      case _Area.shorouk:
        return [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              _numField(
                context,
                colors,
                label: context.l10n.district_number,
                hint: '1',
                controller: _districtC,
                focus: _districtF,
                next: _neighborhoodF,
              ),
              _numField(
                context,
                colors,
                label: context.l10n.neighborhood_number,
                hint: '1',
                controller: _neighborhoodC,
                focus: _neighborhoodF,
                next: _buildingF,
              ),
            ],
          ),
          14.ph,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              _numField(
                context,
                colors,
                label: context.l10n.building_number,
                hint: '36',
                controller: _buildingC,
                focus: _buildingF,
                next: _apartmentF,
              ),
              _numField(
                context,
                colors,
                label: context.l10n.apartment_number,
                hint: '12',
                controller: _apartmentC,
                focus: _apartmentF,
              ),
            ],
          ),
        ];

      // منطقة أخرى: عنوان حر
      case _Area.other:
        return [
          MainTextField(
            withLabel: true,
            labelOut: context.l10n.area_name,
            controller: _areaNameC,
            currentFocusNode: _areaNameF,
            nextFocusNode: _detailsF,
            keyboardType: TextInputType.text,
            textDirection: context.isArabic
                ? TextDirection.rtl
                : TextDirection.ltr,
            prefixIcon: Icon(Icons.map_outlined, color: accent),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? context.l10n.field_required
                : null,
          ),
          16.ph,
          MainTextField(
            withLabel: true,
            labelOut: context.l10n.address_details,
            controller: _detailsC,
            currentFocusNode: _detailsF,
            nextFocusNode: null,
            keyboardType: TextInputType.streetAddress,
            textDirection: context.isArabic
                ? TextDirection.rtl
                : TextDirection.ltr,
            prefixIcon: Icon(Icons.location_on_outlined, color: accent),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? context.l10n.field_required
                : null,
          ),
        ];
    }
  }

  /// حقل رقمي صغير بعنوان فوقه (يقبل الأرقام العربية والإنجليزية)
  Widget _numField(
    BuildContext context,
    AppColorsExtension colors, {
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focus,
    FocusNode? next,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainText(
            label,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: colors.textColor,
          ),
          8.ph,
          MainTextField(
            controller: controller,
            currentFocusNode: focus,
            nextFocusNode: next,
            keyboardType: TextInputType.number,
            hint: hint,
            textDirection: TextDirection.ltr,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9٠-٩]')),
              LengthLimitingTextInputFormatter(4),
            ],
            validator: (value) => (value == null || value.trim().isEmpty)
                ? context.l10n.field_required
                : null,
          ),
        ],
      ),
    );
  }

  void _stateHandler(BuildContext context, RegisterState state) {
    if (state.isLoading) return;

    if (state.isError && state.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: state.errorMessage ?? context.l10n.something_went_wrong,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: MyColors.appRed,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      });
      return;
    }

    if (state.isSuccess) {
      final successMessage = state.successMessage!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastService.showSuccess(context, successMessage);
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            OTPRegisterView.routeName,
            arguments: _phone?.completeNumber,
            (route) => false,
          );
        }
      });
      return;
    }
  }
}

// ═════════════════════════════════════════════════════════════
// Private widgets
// ═════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [MyColors.primaryColor, MyColors.primaryContainer],
            ),
            boxShadow: [
              BoxShadow(
                color: MyColors.primaryColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MainText(
            title,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _AreaChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color accent;
  final Color textColor;
  final VoidCallback onTap;

  const _AreaChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.accent,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: selected
            ? const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [MyColors.primaryColor, MyColors.primaryContainer],
              )
            : null,
        color: selected ? null : accent.withValues(alpha: 0.05),
        border: Border.all(
          color: selected ? Colors.transparent : accent.withValues(alpha: 0.2),
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: MyColors.primaryColor.withValues(alpha: 0.32),
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
                Icon(icon, size: 24, color: selected ? Colors.white : accent),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: MainText(
                    label,
                    fontSize: 12.5,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected ? Colors.white : textColor,
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

/// يعرض شكل العنوان كما سيُحفظ (36-12-21 أو م١م١ع٣٦ش١٢)
class _AddressPreview extends StatelessWidget {
  final String label;
  final String value;
  final bool isLtr;
  final Color accent;
  final Color textColor;

  const _AddressPreview({
    required this.label,
    required this.value,
    required this.isLtr,
    required this.accent,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
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
          Icon(Icons.place_rounded, color: accent, size: 22),
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
                  color: textColor.withValues(alpha: 0.65),
                ),
                MainText(
                  value,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: accent,
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

/// ظهور تدريجي + انزلاق خفيف عند فتح الشاشة
class _Reveal extends StatelessWidget {
  final Widget child;
  final double begin;
  final double dy;

  const _Reveal({required this.child, this.begin = 0.0, this.dy = 24});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1100),
      child: child,
      builder: (context, t, child) {
        final v = Interval(begin, 1.0, curve: Curves.easeOutCubic).transform(t);
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * dy),
            child: child,
          ),
        );
      },
    );
  }
}

/// زر بتدرج الهوية. [isDimmed] يغيّر الشكل فقط، والضغط يعرض أخطاء الفورم.
class _GradientButton extends StatelessWidget {
  final String title;
  final bool isDimmed;
  final bool isLoading;
  final VoidCallback onTap;

  const _GradientButton({
    required this.title,
    required this.isDimmed,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    final active = !isDimmed || isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: active
              ? const [MyColors.primaryColor, MyColors.primaryContainer]
              : [
                  MyColors.primaryColor.withValues(alpha: 0.4),
                  MyColors.primaryContainer.withValues(alpha: 0.4),
                ],
        ),
        boxShadow: active && !isLoading
            ? [
                BoxShadow(
                  color: MyColors.primaryColor.withValues(alpha: 0.38),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: isLoading ? null : onTap,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MainText(
                        title,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _HeroBackground extends StatelessWidget {
  const _HeroBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipPath(
        clipper: _HeroWaveClipper(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                MyColors.deepBlue,
                MyColors.primaryColor,
                MyColors.primaryContainer,
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            children: [
              _bubble(top: -50, right: -40, size: 180, alpha: 0.07),
              _bubble(top: 100, left: -60, size: 150, alpha: 0.06),
              _bubble(top: 60, left: 80, size: 30, alpha: 0.12),
              _bubble(top: 170, right: 50, size: 22, alpha: 0.14),
              _bubble(top: 30, right: 120, size: 14, alpha: 0.18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bubble({
    double? top,
    double? left,
    double? right,
    required double size,
    required double alpha,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
          border: Border.all(
            color: MyColors.skyBlue.withValues(alpha: alpha + 0.08),
          ),
        ),
      ),
    );
  }
}

class _HeroWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 50)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height,
        size.width * 0.55,
        size.height - 28,
      )
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height - 62,
        size.width,
        size.height - 24,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
