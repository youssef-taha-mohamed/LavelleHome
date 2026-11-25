import 'shared_widgets.dart';

const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
const fillColor = MyColors.scaffoldColor;
const borderColor = Color(0xff4D4D4D);

// ignore: must_be_immutable
class CustomPhone extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(String)? onComplete;
  final Function(bool)? onEditing;
  void Function(String)? onChanged;
  void Function()? onTap;
  bool readOnly;
  final bool enabled;
  FocusNode? currentFocusNode;
  FocusNode? nextFocusNode;
  final String? initialCountryCode;
  final String? Function(PhoneNumber?)? validator;
  final void Function(PhoneNumber)? onChangedPhoneNumber;
  final String? label;
  final String? helperText;
  final bool showClearButton;
  final bool unFocusWhenTapOutside;
  final TextDirection? textDirection;
  final bool allowCountryChange;
  final bool isTablet;

  CustomPhone({
    super.key,
    this.controller,
    this.onChangedPhoneNumber,
    this.initialCountryCode,
    this.onComplete,
    this.onEditing,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.currentFocusNode,
    this.validator,
    this.label,
    this.helperText,
    this.showClearButton = true,
    this.unFocusWhenTapOutside = false,
    this.textDirection,
    this.nextFocusNode,
    this.allowCountryChange = true,
    this.isTablet = false,
  });

  @override
  State<CustomPhone> createState() => _CustomPhoneState();
}

class _CustomPhoneState extends State<CustomPhone> {
  late String selectedCountryCode;

  @override
  void initState() {
    super.initState();
    selectedCountryCode = widget.initialCountryCode ?? '+20';
  }

  @override
  void didUpdateWidget(CustomPhone oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCountryCode != oldWidget.initialCountryCode &&
        widget.initialCountryCode != null) {
      setState(() {
        selectedCountryCode = widget.initialCountryCode!;
      });
      widget.controller?.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      isTablet: widget.isTablet,
      allowCountryChange: widget.allowCountryChange,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      style: TextStyle(
        fontSize: widget.isTablet ? 24 : 14,
        fontWeight: FontWeight.w700,
      ),
      focusNode: widget.currentFocusNode,
      onSubmitted: (_) =>
          FocusScope.of(context).requestFocus(widget.nextFocusNode),
      controller: widget.controller,
      label: widget.label ?? context.l10n.phone_number,
      helperText: widget.helperText,
      showClearButton: widget.showClearButton,
      unFocusWhenTapOutside: widget.unFocusWhenTapOutside,
      textDirection: widget.textDirection ?? TextDirection.ltr,
      decoration: InputDecoration(hintText: context.l10n.phone_number),
      initialCountryCode: widget.initialCountryCode ?? 'EG',
      onChanged: widget.onChangedPhoneNumber,
      validator: (phone) {
        if (widget.validator != null) {
          return widget.validator!(phone);
        }
        if (phone == null || phone.completeNumber.isEmpty) {
          return context.l10n.please_enter_your_phone_number;
        }
        if (phone.number.length < phone.countryCode.length) {
          return context.l10n.invalid_phone;
        }
        if (phone.number.length > 15) {
          return context.l10n.invalid_phone;
        }
        return null;
      },
      disableLengthCheck: false,
      languageCode: context.l10n.localeName,
      searchText: context.l10n.select_country,
      invalidNumberMessage: context.l10n.invalid_phone,
    );
  }
}
