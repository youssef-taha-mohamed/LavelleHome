import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/style/app_colors.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/style/theme/extensions/app_colors_extension.dart';
import '../../core/style/theme/extensions/app_theme_extension.dart';
import 'main_text.dart';
import 'validation_rule.dart';

class MainTextField extends StatefulWidget {
  final String? hint;
  final String? label;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final IconData? prefixIcons;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool isDense;
  final EdgeInsetsGeometry? contentPadding;
  final bool readOnly;
  final bool enabled;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final bool unFocusWhenTapOutside;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final BoxConstraints? prefixIconConstraints;
  final String? initialCode;
  final String? helperText;
  final Function(CountryCode)? onCountryCodeChange;
  final String? autofillHints;
  final bool showClearButton;
  final bool autofocus;
  final TextDirection? textDirection;
  final TextCapitalization? textCapitalization;
  final String? labelOut;
  final bool withLabel;
  final double labelFontSize;
  final bool isTablet;

  /// Optional list of validation rules to display below the field.
  /// When provided, rules appear on focus and give real-time visual feedback.
  final List<ValidationRule>? validationRules;
  final List<TextInputFormatter>? inputFormatters;

  const MainTextField({
    super.key,
    this.hint,
    this.label,
    this.textStyle,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.isDense = true,
    this.contentPadding,
    this.readOnly = false,
    this.enabled = true,
    this.currentFocusNode,
    this.unFocusWhenTapOutside = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.validator,
    this.onCountryCodeChange,
    this.isPassword = false,
    this.initialCode,
    this.helperText,
    this.prefixIconConstraints,
    this.autofillHints,
    this.showClearButton = true,
    this.autofocus = false,
    this.labelStyle,
    this.textDirection,
    this.prefixIcons,
    this.nextFocusNode,
    this.textCapitalization,
    this.labelOut,
    this.withLabel = false,
    this.validationRules,
    this.inputFormatters,
    this.labelFontSize = 14,
    this.isTablet = false,
  });

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  late bool _obscureText;
  late TextEditingController _controller;
  bool _hasText = false;
  late FocusNode _focusNode;
  String? _errorMessage;
  bool _wasValidated = false;
  bool _isFocused = false;

  /// Tracks whether the field has ever lost focus (used to trigger red state).
  bool _hasBeenUnfocused = false;

  /// True when ALL rules were satisfied the last time the field lost focus.
  /// When true, rules stay hidden on re-focus until the user actually breaks a rule.
  bool _allSatisfiedOnLastUnfocus = false;

  /// Tracks the text value at the moment all rules were satisfied on unfocus.
  /// If the user changes text after that, rules can reappear.
  String _textWhenAllSatisfied = '';

  @override
  void initState() {
    super.initState();

    _obscureText = widget.isPassword;
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _focusNode = widget.currentFocusNode ?? FocusNode();

    _controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;

      if (!_isFocused) {
        _wasValidated = true;
        _hasBeenUnfocused = true;
        _errorMessage = widget.validator?.call(_controller.text);

        // Record whether all rules were satisfied when leaving the field.
        if (widget.validationRules != null &&
            widget.validationRules!.isNotEmpty) {
          _allSatisfiedOnLastUnfocus = widget.validationRules!.every(
            (r) => r.check(_controller.text),
          );
          if (_allSatisfiedOnLastUnfocus) {
            _textWhenAllSatisfied = _controller.text;
          }
        }
      }
    });
  }

  void _handleTextChange() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;

      if (_hasText) {
        _errorMessage = null;
      } else if (_wasValidated) {
        _errorMessage = widget.validator?.call(_controller.text);
      }

      // If the user edits after all rules were previously satisfied,
      // reset the flag so rules can reappear if a rule gets broken.
      if (_allSatisfiedOnLastUnfocus &&
          _controller.text != _textWhenAllSatisfied) {
        _allSatisfiedOnLastUnfocus = false;
      }
    });
  }

  @override
  void didUpdateWidget(covariant MainTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleTextChange);
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_handleTextChange);
    }
    if (widget.currentFocusNode != oldWidget.currentFocusNode) {
      oldWidget.currentFocusNode?.removeListener(_handleFocusChange);
      if (oldWidget.currentFocusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.currentFocusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _focusNode.removeListener(_handleFocusChange);

    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.currentFocusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  /// Determines whether the validation rules list should be visible.
  bool get _shouldShowRules {
    if (widget.validationRules == null || widget.validationRules!.isEmpty) {
      return false;
    }

    final allSatisfied = widget.validationRules!.every(
      (r) => r.check(_controller.text),
    );

    // Always hide when all rules are satisfied and unfocused.
    if (!_isFocused && allSatisfied) return false;

    // If user previously left with all rules satisfied and hasn't changed the
    // text in a way that breaks a rule → keep rules hidden even on re-focus.
    if (_allSatisfiedOnLastUnfocus && allSatisfied) return false;

    // Show rules when focused OR when unfocused with unsatisfied rules.
    return _isFocused || (_hasBeenUnfocused && !allSatisfied);
  }

  /// Returns the color for a single rule item based on current state.
  Color _ruleColor(bool isSatisfied, BuildContext context) {
    if (isSatisfied) {
      return Colors.green;
    }
    // Show red only after the field has been unfocused and we're not currently focused.
    if (_hasBeenUnfocused && !_isFocused) {
      return Colors.red;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppThemeExtension>();
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final media = MediaQuery.of(context);
    final isDesktop = media.size.width > 800;
    // 👇 Padding responsive حسب حجم الشاشة
    final responsivePadding = isDesktop
        ? const EdgeInsets.symmetric(horizontal: 24, vertical: 18)
        : (widget.contentPadding ??
            ext?.defaultPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16));

    // 👇 Font size responsive
    final responsiveFontSize = isDesktop ? 16.0 : 14.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.withLabel) ...[
          MainText(
            widget.labelOut ?? "",
            color: colors?.subTextColor,
            fontWeight: FontWeight.bold,
            fontSize: AppResponsive.getFontSize(
              context,
              mobile: widget.labelFontSize,
              smallMobile: 12,
              smallTablet: 12,
              largeTablet: 14,
              desktop: 15,
            ),
          ),
          if (widget.labelOut != null) const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          autofillHints:
              widget.autofillHints != null ? [widget.autofillHints!] : null,
          style: widget.textStyle ??
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: responsiveFontSize,
                    fontWeight: FontWeight.w500,
                  ),
          cursorColor: scheme.primary,
          cursorWidth: 1.8,
          cursorRadius: Radius.circular(ext?.radiusSmall ?? 2),
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          validator: (value) {
            if (widget.validator != null) {
              _wasValidated = true;
              _errorMessage = widget.validator!(value);
              setState(() {});
            }
            return _errorMessage;
          },
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onFieldSubmitted: widget.onSubmitted ??
              (value) {
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
              },
          textDirection: widget.textDirection,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: colors?.subTextColor.withAlpha(180) ?? MyColors.grey600,
              fontSize: responsiveFontSize,
            ),
            fillColor: widget.readOnly
                ? scheme.surfaceContainerHighest.withAlpha(100)
                : null,
            filled: widget.readOnly ? true : null, // تعبئة خفيفة للـ readOnly
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.validationRules != null &&
                    widget.validationRules!.isNotEmpty
                ? null
                : _errorMessage,
            label: widget.label != null
                ? Text(
                    widget.label!,
                    style: widget.labelStyle ??
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: responsiveFontSize,
                            ),
                  )
                : null,
            prefixIcon: widget.prefixIcon != null
                ? widget.prefixIcons == null
                    ? widget.prefixIcon
                    : Icon(widget.prefixIcons, color: scheme.primary)
                : null,
            suffixIcon: _buildSuffixIcon(context),
            suffix: widget.suffix,
            isDense: widget.isDense,
            contentPadding: responsivePadding,
          ),
        ),
        // Validation rules list — only rendered when validationRules is provided.
        if (widget.validationRules != null &&
            widget.validationRules!.isNotEmpty)
          _buildValidationRules(context, isDesktop),
      ],
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (widget.isPassword) {
      return IconButton(
        onPressed: () => setState(() => _obscureText = !_obscureText),
        icon: Icon(
          _obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
          size: 20,
          color: scheme.onSurfaceVariant,
        ),
        splashRadius: 24,
      );
    }

    if (widget.showClearButton && _hasText && !widget.readOnly) {
      return IconButton(
        onPressed: () {
          _controller.clear();
          widget.onChanged?.call('');
        },
        icon: Icon(
          Icons.close_rounded,
          size: 20,
          color: scheme.onSurfaceVariant,
        ),
        splashRadius: 24,
      );
    }

    return widget.suffixIcon;
  }

  Widget _buildValidationRules(BuildContext context, bool isDesktop) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: _shouldShowRules
          ? Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.validationRules!.map((rule) {
                  final isSatisfied = rule.check(_controller.text);
                  final color = _ruleColor(isSatisfied, context);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isSatisfied
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  key: const ValueKey('check'),
                                  size: isDesktop ? 18 : 16,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.circle_outlined,
                                  key: const ValueKey('circle'),
                                  size: isDesktop ? 18 : 16,
                                  color: color,
                                ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: MainText(
                            rule.label,
                            fontSize: isDesktop ? 13 : 12,
                            color: color,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
