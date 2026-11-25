import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'countries.dart';
import 'country_picker_dialog.dart';
import 'phone_number.dart';

/// Returns a localized message telling the user not to type the country dial code.
String _countryCodeWarningMessage(String dialCode, String languageCode) {
  switch (languageCode.toLowerCase()) {
    case 'ar':
      return 'لا تكتب كود الدولة (+$dialCode) في خانة الرقم، هو موجود بالفعل على الجانب الأيسر.';
    case 'fr':
      return "N'entrez pas l'indicatif pays (+$dialCode) ici, il est déjà affiché à gauche.";
    default:
      return 'Do not type the country code (+$dialCode) here — it is already shown on the left side.';
  }
}

class PreventLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // لو النص الجديد بيبدأ بـ 0، نرجع للقيمة القديمة
    if (newValue.text.startsWith('0')) {
      // لو المستخدم كتب 0، نتجاهله ونرجع القديم
      return oldValue;
    }
    return newValue;
  }
}

/// Prevents the user from typing the country dial code inside the phone field.
/// Works automatically inside [IntlPhoneField] — no extra setup needed.
class PreventCountryCodeFormatter extends TextInputFormatter {
  PreventCountryCodeFormatter({required this.dialCode, this.onBlocked});

  /// The dial code WITHOUT the '+' sign (e.g. '20' for Egypt, '966' for Saudi Arabia).
  String dialCode;

  /// Called when an input is blocked (e.g. to show a warning to the user).
  final VoidCallback? onBlocked;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Block if starts with '+'
    if (text.startsWith('+')) {
      onBlocked?.call();
      return oldValue;
    }

    // Block if starts with '00' (international prefix)
    if (text.startsWith('00')) {
      onBlocked?.call();
      return oldValue;
    }

    // Block if starts with the selected country's dial code
    if (dialCode.isNotEmpty && text.startsWith(dialCode)) {
      onBlocked?.call();
      return oldValue;
    }

    return newValue;
  }
}

class IntlPhoneField extends StatefulWidget {
  /// The TextFormField key.
  final GlobalKey<FormFieldState>? formFieldKey;

  final Widget Function({
    required BuildContext context,
    String? counteryCode,
    String? dialCode,
    String? flag,
    String? formattedNumber,
    String? fullNumber,
    String? isoCode,
    Function? changeCounteryFunc,
    bool isTablet,
  })?
  prefixBulder;

  /// Whether to hide the text being edited (e.g., for passwords).
  final bool obscureText;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// How the text should be aligned vertically.
  final TextAlignVertical? textAlignVertical;
  final VoidCallback? onTap;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;
  final FormFieldSetter<PhoneNumber>? onSaved;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged] runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted], [onSelectionChanged]:
  ///    which are more specialized input change notifications.
  final ValueChanged<PhoneNumber>? onChanged;

  final ValueChanged<Country>? onCountryChanged;

  /// An optional method that validates an input. Returns an error string to display if the input is invalid, or null otherwise.
  ///
  /// A [PhoneNumber] is passed to the validator as argument.
  /// The validator can handle asynchronous validation when declared as a [Future].
  /// Or run synchronously when declared as a [Function].
  ///
  /// By default, the validator checks whether the input number length is between selected country's phone numbers min and max length.
  /// If `disableLengthCheck` is not set to `true`, your validator returned value will be overwritten by the default validator.
  /// But, if `disableLengthCheck` is set to `true`, your validator will have to check phone number length itself.
  final FutureOr<String?> Function(PhoneNumber?)? validator;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType keyboardType;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// focusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field.  The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [EditableText.onSubmitted] for an example of how to handle moving to
  ///    the next/previous field when using [TextInputAction.next] and
  ///    [TextInputAction.previous] for [textInputAction].
  final void Function(String)? onSubmitted;

  /// If false the widget is "disabled": it ignores taps, the [TextFormField]'s
  /// [decoration] is rendered in grey,
  /// [decoration]'s [InputDecoration.counterText] is set to `""`,
  /// and the drop down icon is hidden no matter [showDropdownIcon] value.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [Decoration.enabled] property.
  final bool enabled;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to the brightness of [ThemeData.brightness].
  final Brightness? keyboardAppearance;

  /// Initial Value for the field.
  /// This property can be used to pre-fill the field.
  final String? initialValue;

  final String languageCode;

  /// 2 letter ISO Code or country dial code.
  ///
  /// ```dart
  /// initialCountryCode: 'IN', // India
  /// initialCountryCode: '+225', // Côte d'Ivoire
  /// ```
  final String? initialCountryCode;

  /// List of Country to display see countries.dart for format
  final List<Country>? countries;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration decoration;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  final TextStyle? style;

  /// Disable view Min/Max Length check
  final bool disableLengthCheck;

  /// Won't work if [enabled] is set to `false`.
  final bool showDropdownIcon;

  final BoxDecoration dropdownDecoration;

  /// The style use for the country dial code.
  final TextStyle? dropdownTextStyle;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// The text that describes the search input field.
  ///
  /// When the input field is empty and unfocused, the label is displayed on top of the input field (i.e., at the same location on the screen where text may be entered in the input field). When the input field receives focus (or if the field is non-empty), the label moves above (i.e., vertically adjacent to) the input field.
  final String searchText;

  /// Position of an icon [leading, trailing]
  final IconPosition dropdownIconPosition;

  /// Icon of the drop down button.
  ///
  /// Default is [Icon(Icons.arrow_drop_down)]
  final Icon dropdownIcon;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Autovalidate mode for text form field.
  ///
  /// If [AutovalidateMode.onUserInteraction], this FormField will only auto-validate after its content changes.
  /// If [AutovalidateMode.always], it will auto-validate even without user interaction.
  /// If [AutovalidateMode.disabled], auto-validation will be disabled.
  ///
  /// Defaults to [AutovalidateMode.onUserInteraction].
  final AutovalidateMode? autovalidateMode;

  /// Whether to show or hide country flag.
  ///
  /// Default value is `true`.
  final bool showCountryFlag;

  /// Message to be displayed on autoValidate error
  ///
  /// Default value is `Invalid Mobile Number`.
  final String? invalidNumberMessage;

  /// The color of the cursor.
  final Color? cursorColor;

  /// How tall the cursor will be.
  final double? cursorHeight;

  /// How rounded the corners of the cursor should be.
  final Radius? cursorRadius;

  /// How thick the cursor will be.
  final double cursorWidth;

  /// Whether to show cursor.
  final bool? showCursor;

  /// The padding of the Flags Button.
  ///
  /// The amount of insets that are applied to the Flags Button.
  ///
  /// If unset, defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry flagsButtonPadding;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Optional set of styles to allow for customizing the country search
  /// & pick dialog
  final PickerDialogStyle? pickerDialogStyle;

  /// The margin of the country selector button.
  ///
  /// The amount of space to surround the country selector button.
  ///
  /// If unset, defaults to [EdgeInsets.zero].
  final EdgeInsets flagsButtonMargin;

  /// Enable the autofill hint for phone number.
  final bool disableAutoFillHints;

  /// If null, default magnification configuration will be used.
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// Label text for the phone field
  final String? label;

  /// Label style for the phone field
  final TextStyle? labelStyle;

  /// Helper text for the phone field
  final String? helperText;

  /// Whether to show clear button
  final bool showClearButton;

  /// Whether to unfocus when tap outside
  final bool unFocusWhenTapOutside;

  final bool allowCountryChange;

  /// Text direction for RTL/LTR support
  final TextDirection? textDirection;

  final bool isTablet;

  /// Whether to display Arab countries at the top of the country picker list.
  /// Defaults to `true`. Set to `false` to sort all countries alphabetically.
  final bool arabCountriesFirst;

  const IntlPhoneField({
    super.key,
    this.formFieldKey,
    this.initialCountryCode,
    this.languageCode = 'en',
    this.disableAutoFillHints = false,
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.textAlignVertical,
    this.onTap,
    this.prefixBulder,
    this.readOnly = false,
    this.initialValue,
    this.keyboardType = TextInputType.phone,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.style,
    this.dropdownTextStyle,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.countries,
    this.onCountryChanged,
    this.onSaved,
    this.showDropdownIcon = true,
    this.dropdownDecoration = const BoxDecoration(),
    this.inputFormatters,
    this.enabled = true,
    this.keyboardAppearance,
    @Deprecated('Use searchFieldInputDecoration of PickerDialogStyle instead')
    this.searchText = 'Search country',
    this.dropdownIconPosition = IconPosition.leading,
    this.dropdownIcon = const Icon(Icons.arrow_drop_down),
    this.autofocus = false,
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showCountryFlag = true,
    this.cursorColor,
    this.disableLengthCheck = false,
    this.flagsButtonPadding = EdgeInsets.zero,
    this.invalidNumberMessage = 'Invalid Mobile Number',
    this.cursorHeight,
    this.cursorRadius = Radius.zero,
    this.cursorWidth = 2.0,
    this.showCursor = true,
    this.pickerDialogStyle,
    this.flagsButtonMargin = EdgeInsets.zero,
    this.magnifierConfiguration,
    this.label,
    this.labelStyle,
    this.helperText,
    this.showClearButton = true,
    this.unFocusWhenTapOutside = false,
    this.textDirection,
    this.allowCountryChange = true,
    this.isTablet = false,
    this.arabCountriesFirst = true,
  });

  @override
  State<IntlPhoneField> createState() => _IntlPhoneFieldState();
}

class _IntlPhoneFieldState extends State<IntlPhoneField> {
  late List<Country> _countryList;
  late Country _selectedCountry;
  late List<Country> filteredCountries;
  late String number;

  String? validatorMessage;

  late FocusNode _focusNode;
  String? _errorMessage;
  bool _wasValidated = false;
  bool _isFocused = false;
  bool _hasText = false;
  late TextEditingController _controller;

  /// Temporary warning shown when the user attempts to type the country dial code.
  String? _countryCodeWarning;
  Timer? _warningTimer;

  @override
  void initState() {
    super.initState();
    _countryList = sortCountryList(
      widget.countries ?? countries,
      languageCode: widget.languageCode,
      arabCountriesFirst: widget.arabCountriesFirst,
    );
    filteredCountries = _countryList;
    number = widget.initialValue ?? '';
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _focusNode = widget.focusNode ?? FocusNode();

    if (number.startsWith('0')) {
      number = number.substring(1);
    }
    // Add listeners
    _controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);

    if (widget.initialCountryCode == null && number.startsWith('+')) {
      try {
        _selectedCountry = PhoneNumber.getCountry(number);
      } catch (e) {
        String numWithoutPlus = number.substring(1);
        _selectedCountry = countries.firstWhere(
          (country) => numWithoutPlus.startsWith(country.fullCountryCode),
          orElse: () => _countryList.first,
        );
      }

      // remove country code from the initial number value
      number = number.replaceFirst(
        RegExp("^\\+${_selectedCountry.fullCountryCode}"),
        "",
      );
    } else {
      _selectedCountry = _countryList.firstWhere(
        (item) => item.code == (widget.initialCountryCode ?? 'US'),
        orElse: () => _countryList.first,
      );

      // remove country code from the initial number value
      if (number.startsWith('+')) {
        number = number.replaceFirst(
          RegExp("^\\+${_selectedCountry.fullCountryCode}"),
          "",
        );
      } else {
        number = number.replaceFirst(
          RegExp("^${_selectedCountry.fullCountryCode}"),
          "",
        );
      }
    }

    // ✅ نتأكد تاني بعد معالجة الـ country code
    if (number.startsWith('0')) {
      number = number.substring(1);
      _controller.text = number;
    }

    if (widget.autovalidateMode == AutovalidateMode.always) {
      final initialPhoneNumber = PhoneNumber(
        countryISOCode: _selectedCountry.code,
        countryCode: '+${_selectedCountry.dialCode}',
        number: widget.initialValue ?? '',
      );

      final value = widget.validator?.call(initialPhoneNumber);

      if (value is String) {
        validatorMessage = value;
      } else {
        (value as Future).then((msg) {
          validatorMessage = msg;
        });
      }
    }
  }

  void _handleFocusChange() {
    if (!mounted) return;
    setState(() {
      _isFocused = _focusNode.hasFocus;

      // When field loses focus, validate if it has content
      if (!_isFocused) {
        _wasValidated = true;
        if (_controller.text.isEmpty) {
          _validateField();
        } else {
          _errorMessage = null;
        }
      }
    });
  }

  void _handleTextChange() {
    if (!mounted) return;
    setState(() {
      _hasText = _controller.text.isNotEmpty;

      // Clear error message immediately when typing starts
      if (_hasText) {
        _errorMessage = null;
      } else if (_wasValidated) {
        // Show error if field was previously validated and is now empty
        _validateField();
      }
    });
  }

  void _validateField() async {
    if (widget.validator != null) {
      final result = widget.validator!(_getPhoneNumber());
      if (result is String) {
        _errorMessage = result;
      } else if (result is Future<String?>) {
        _errorMessage = await result;
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  PhoneNumber _getPhoneNumber() {
    return PhoneNumber(
      countryISOCode: _selectedCountry.code,
      countryCode: '+${_selectedCountry.fullCountryCode}',
      number: _controller.text,
    );
  }

  void _showCountryCodeWarning() {
    if (!mounted) return;
    setState(() {
      _countryCodeWarning = _countryCodeWarningMessage(
        _selectedCountry.dialCode,
        widget.languageCode,
      );
    });
    _warningTimer?.cancel();
    _warningTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _countryCodeWarning = null);
    });
  }

  @override
  void dispose() {
    _warningTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChange);
    }
    if (widget.focusNode == null) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _changeCountry() async {
    filteredCountries = _countryList;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CountryPickerBottomSheet(
        languageCode: widget.languageCode.toLowerCase(),
        style: widget.pickerDialogStyle,
        filteredCountries: filteredCountries,
        searchText: widget.searchText,
        countryList: _countryList,
        selectedCountry: _selectedCountry,
        arabCountriesFirst: widget.arabCountriesFirst,
        onCountryChanged: (Country country) {
          _selectedCountry = country;
          widget.onCountryChanged?.call(country);
          setState(() {});
        },
      ),
    );
    if (mounted) setState(() {});
  }

  // إنشاء أيقونة للحقل
  Widget? _buildSuffixIcon() {
    if (widget.showClearButton && _hasText) {
      return IconButton(
        onPressed: () {
          _controller.clear();
          if (widget.onChanged != null) {
            widget.onChanged!(_getPhoneNumber());
          }
        },
        icon: Icon(Icons.clear, size: widget.isTablet ? 42 : 20),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final List<TextInputFormatter> effectiveInputFormatters = [
      PreventLeadingZeroFormatter(), // منع الصفر في الأول
      FilteringTextInputFormatter.digitsOnly, // أرقام بس
      PreventCountryCodeFormatter(
        dialCode: _selectedCountry.dialCode,
        onBlocked: _showCountryCodeWarning, // إظهار رسالة التحذير
      ),
      ...?widget.inputFormatters, // اللي جاي من بره
    ];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;
    final borderRadiusObj = BorderRadius.circular(12.0);

    final defaultOutline = OutlineInputBorder(
      borderRadius: borderRadiusObj,
      borderSide: BorderSide(
        color: scheme.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.30),
        width: 1.0,
      ),
    );

    final defaultFocused = OutlineInputBorder(
      borderRadius: borderRadiusObj,
      borderSide: BorderSide(
        color: scheme.primary,
        width: 1.5,
      ),
    );

    final defaultError = OutlineInputBorder(
      borderRadius: borderRadiusObj,
      borderSide: BorderSide(
        color: scheme.error,
        width: 1.0,
      ),
    );

    final defaultFocusedError = OutlineInputBorder(
      borderRadius: borderRadiusObj,
      borderSide: BorderSide(
        color: scheme.error,
        width: 1.5,
      ),
    );

    final defaultDisabled = OutlineInputBorder(
      borderRadius: borderRadiusObj,
      borderSide: BorderSide(
        color: scheme.outlineVariant.withValues(alpha: 0.18),
        width: 1.0,
      ),
    );

    final Color effectiveFillColor = widget.readOnly
        ? scheme.surfaceContainerLow.withValues(alpha: 0.35)
        : scheme.surfaceContainerLowest;

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadiusObj,
        boxShadow: [
          if (!widget.readOnly && widget.enabled)
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.15)
                  : scheme.primary.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
              spreadRadius: 0,
            ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextFormField(
          key: widget.formFieldKey,
          initialValue: (widget.controller == null) ? number : null,
          autofillHints: widget.disableAutoFillHints
              ? null
              : [AutofillHints.telephoneNumberNational],
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          cursorColor: widget.cursorColor,
          onTap: widget.onTap,
          controller: widget.controller,
          focusNode: widget.focusNode,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          cursorWidth: widget.cursorWidth,
          showCursor: widget.showCursor,
          onFieldSubmitted: widget.onSubmitted,
          magnifierConfiguration: widget.magnifierConfiguration,
          textDirection: widget.textDirection,
          style:
              widget.style ??
              Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: widget.isTablet ? 24 : 14,
                fontWeight: FontWeight.w400,
              ),
          validator: (value) {
            if (value != null && value.startsWith('0')) {
              return 'Phone number should not start with 0';
            }
            if (widget.validator != null) {
              _wasValidated = true;
              final result = widget.validator!(_getPhoneNumber());
              if (result is String) {
                _errorMessage = result;
                return _errorMessage;
              }
              // Handle async validation separately
              if (result is Future<String?>) {
                result.then((errorMsg) {
                  _errorMessage = errorMsg;
                  if (mounted) {
                    setState(() {});
                  }
                });
              }
            }
            return _errorMessage;
          },
          onChanged: (value) async {
            if (value.startsWith('0')) {
              _controller.text = value.substring(1);
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length),
              );
              return;
            }

            final phoneNumber = _getPhoneNumber();

            if (widget.autovalidateMode != AutovalidateMode.disabled) {
              validatorMessage = await widget.validator?.call(phoneNumber);
            }

            widget.onChanged?.call(phoneNumber);
          },
          onTapOutside: (event) {
            if (widget.unFocusWhenTapOutside) {
              FocusScope.of(context).unfocus();
            }
          },
          decoration: widget.decoration.copyWith(
            fillColor: widget.decoration.fillColor ?? effectiveFillColor,
            filled: widget.decoration.filled ?? true,
            hintStyle: widget.decoration.hintStyle ??
                TextStyle(
                  fontSize: widget.isTablet ? 24 : 14,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w400,
                ),
            label: widget.label != null
                ? Text(
                    widget.label!,
                    style:
                        widget.labelStyle ??
                        Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: widget.isTablet ? 24 : 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).hintColor,
                        ),
                  )
                : null,
            labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: widget.isTablet ? 24 : 14,
              fontWeight: FontWeight.w400,
            ),
            helperText: _countryCodeWarning ?? widget.helperText,
            helperStyle: _countryCodeWarning != null
                ? TextStyle(
                    color: Colors.orange.shade700,
                    fontSize: widget.isTablet ? 16 : 9,
                    fontWeight: FontWeight.w400,
                  )
                : null,
            errorText: _errorMessage,
            prefixIcon: widget.prefixBulder != null
                ? widget.prefixBulder!(
                    context: context,
                    counteryCode: _selectedCountry.code,
                    dialCode: _selectedCountry.dialCode,
                    flag:
                        'assets/flags/${_selectedCountry.code.toLowerCase()}.png',
                    formattedNumber: number,
                    fullNumber: '+${_selectedCountry.dialCode}$number',
                    changeCounteryFunc: _changeCountry,
                    isoCode: _selectedCountry.code,
                  )
                : _buildFlagsButton(false),
            suffixIcon: _buildSuffixIcon(),
            suffixIconConstraints: const BoxConstraints(minWidth: 40),
            counterText: !widget.enabled ? '' : null,
            contentPadding: widget.decoration.contentPadding ??
                (widget.isTablet
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
                    : const EdgeInsets.symmetric(horizontal: 14, vertical: 13)),
            border: widget.decoration.border ?? defaultOutline,
            enabledBorder: widget.decoration.enabledBorder ?? defaultOutline,
            focusedBorder: widget.decoration.focusedBorder ?? defaultFocused,
            errorBorder: widget.decoration.errorBorder ?? defaultError,
            focusedErrorBorder:
                widget.decoration.focusedErrorBorder ?? defaultFocusedError,
            disabledBorder: widget.decoration.disabledBorder ?? defaultDisabled,
          ),
          onSaved: (value) {
            String cleanValue = value ?? '';
            if (cleanValue.startsWith('0')) {
              cleanValue = cleanValue.substring(1);
            }
            widget.onSaved?.call(
              PhoneNumber(
                countryISOCode: _selectedCountry.code,
                countryCode:
                    '+${_selectedCountry.dialCode}${_selectedCountry.regionCode}',
                number: value!,
              ),
            );
          },
          maxLength: widget.disableLengthCheck
              ? null
              : _selectedCountry.maxLength,
          keyboardType: widget.keyboardType,
          inputFormatters: effectiveInputFormatters,
          enabled: widget.enabled,
          keyboardAppearance: widget.keyboardAppearance,
          autofocus: widget.autofocus,
          textInputAction: widget.textInputAction,
          autovalidateMode: widget.autovalidateMode,
        ),
      ),
    );
  }

  Container _buildFlagsButton(bool isRTL) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      margin: widget.flagsButtonMargin,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: (widget.enabled && widget.allowCountryChange)
              ? _changeCountry
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.showCountryFlag) ...[
                  SizedBox(
                    width: widget.isTablet ? 48 : 28,
                    height: widget.isTablet ? 32 : 18,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://flagcdn.com/80x60/${_selectedCountry.code.toLowerCase()}.png',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.withValues(alpha: 0.1),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.flag_rounded,
                          size: widget.isTablet ? 32 : 16,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                FittedBox(
                  child: Text(
                    '+${_selectedCountry.dialCode}',
                    style: widget.dropdownTextStyle ??
                        TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: widget.isTablet ? 20 : 13,
                        ),
                  ),
                ),
                if (widget.enabled && widget.showDropdownIcon) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: scheme.primary,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum IconPosition { leading, trailing }
