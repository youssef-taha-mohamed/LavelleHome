import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/style/app_colors.dart';
import '../../core/extension/extension_helper.dart';
import 'main_text.dart';

class CustomDatePickerField extends StatefulWidget {
  final String? label;
  final String? hint;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onDateSelected;
  final String? Function(DateTime?)? validator;
  final bool enabled;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool isDense;
  final String? helperText;
  final DateFormat? dateFormat;
  final String? errorText;
  final bool Function(DateTime)? selectableDayPredicate;
  final ThemeData? datePickerTheme;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? disabledDateColor;
  final Color? enabledDateColor;
  final Color? selectedDateColor;
  final Color? todayColor;
  final TextStyle? disabledDateTextStyle;
  final bool isTablet;

  const CustomDatePickerField({
    super.key,
    this.label,
    this.hint,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.validator,
    this.enabled = true,
    this.textStyle,
    this.labelStyle,
    this.prefixIcon,
    this.contentPadding,
    this.isDense = true,
    this.helperText,
    this.dateFormat,
    this.errorText,
    this.selectableDayPredicate,
    this.datePickerTheme,
    this.readOnly = false,
    this.onTap,
    this.disabledDateColor,
    this.enabledDateColor,
    this.selectedDateColor,
    this.todayColor,
    this.disabledDateTextStyle,
    this.isTablet = false,
  });

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  late FocusNode _focusNode;
  String? _errorMessage;
  bool _wasValidated = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _errorMessage = widget.errorText;
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;

      // Validate when field loses focus
      if (!_isFocused && !_wasValidated) {
        _wasValidated = true;
        _validateDate();
      }
    });
  }

  void _validateDate() {
    if (widget.validator != null) {
      setState(() {
        _errorMessage = widget.validator!(widget.selectedDate);
      });
    }
  }

  Future<void> _selectDate() async {
    if (!widget.enabled || widget.readOnly) return;

    // Custom onTap callback
    if (widget.onTap != null) {
      widget.onTap!();
    }

    final DateTime initialDate = widget.selectedDate ?? DateTime.now();
    final DateTime firstDate = widget.firstDate ?? DateTime(1900);
    final DateTime lastDate = widget.lastDate ?? DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate)
          ? firstDate
          : initialDate.isAfter(lastDate)
              ? lastDate
              : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: widget.selectableDayPredicate,
      builder: (context, child) {
        final theme = Theme.of(context);
        final datePickerTheme = theme.datePickerTheme;

        final tabletTheme = theme.copyWith(
          datePickerTheme: datePickerTheme.copyWith(
            headerHeadlineStyle: datePickerTheme.headerHeadlineStyle?.copyWith(
              fontSize: widget.isTablet ? 36 : null,
            ),
            dayStyle: datePickerTheme.dayStyle?.copyWith(
              fontSize: widget.isTablet ? 20 : null,
            ),
            yearStyle: datePickerTheme.yearStyle?.copyWith(
              fontSize: widget.isTablet ? 24 : null,
            ),
            headerHelpStyle: datePickerTheme.headerHelpStyle?.copyWith(
              fontSize: widget.isTablet ? 18 : null,
            ),
            weekdayStyle: datePickerTheme.weekdayStyle?.copyWith(
              fontSize: widget.isTablet ? 18 : null,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontSize: widget.isTablet ? 22 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

        Widget picker = Theme(data: tabletTheme, child: child!);

        if (widget.isTablet) {
          picker = Transform.scale(
            scale: 1.5,
            child: picker,
          );

          return Align(
            alignment:
                context.isArabic ? Alignment.centerLeft : Alignment.centerRight,
            child: Padding(
              // Increased padding to account for the scale expansion
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 750),
                child: picker,
              ),
            ),
          );
        }

        return picker;
      },
    );

    if (pickedDate != null) {
      widget.onDateSelected?.call(pickedDate);

      // Validate after selection
      _wasValidated = true;
      _validateDate();
    }
  }

  String get _displayText {
    if (widget.selectedDate == null) {
      return widget.hint ?? '';
    }

    final DateFormat formatter =
        widget.dateFormat ?? DateFormat('MMM dd, yyyy');
    return formatter.format(widget.selectedDate!);
  }

  @override
  void didUpdateWidget(CustomDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update error message if it changed from parent
    if (widget.errorText != oldWidget.errorText) {
      setState(() {
        _errorMessage = widget.errorText;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.enabled ? _selectDate : null,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          label: widget.label != null
              ? Text(
                  widget.label!,
                  style: widget.labelStyle ??
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: widget.isTablet ? 24 : 14,
                            fontWeight: FontWeight.w400,
                          ),
                )
              : null,
          labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: widget.isTablet ? 24 : 14,
                fontWeight: FontWeight.w400,
              ),
          helperText: widget.helperText,
          errorText: _errorMessage,
          isDense: widget.isDense,
          enabled: widget.enabled,
          contentPadding: widget.contentPadding ??
              EdgeInsets.symmetric(
                horizontal: 16,
                vertical: widget.isTablet ? 24 : 16,
              ),
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: widget.prefixIcon,
                )
              : Icon(
                  Icons.calendar_today,
                  color: MyColors.primaryColor,
                  size: widget.isTablet ? 32 : 20,
                ),
          suffixIconConstraints: BoxConstraints(minWidth: 40),
          hintText: widget.hint,
        ),
        child: MainText(
          _displayText,
          fontSize: widget.isTablet ? 20 : 12,
          fontWeight: FontWeight.w400,
          color:
              widget.selectedDate == null ? Theme.of(context).hintColor : null,
        ),
      ),
    );
  }
}

extension CustomDatePickerValidation on CustomDatePickerField {
  static String? requiredValidator(DateTime? date, String message) {
    return date == null ? message : null;
  }

  static String? minAgeValidator(DateTime? date, int minAge, String message) {
    if (date == null) return null;
    final now = DateTime.now();
    final age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      return age - 1 >= minAge ? null : message;
    }
    return age >= minAge ? null : message;
  }

  static String? dateRangeValidator(
      DateTime? date, DateTime? minDate, DateTime? maxDate, String message) {
    if (date == null) return null;
    if (minDate != null && date.isBefore(minDate)) return message;
    if (maxDate != null && date.isAfter(maxDate)) return message;
    return null;
  }
}
