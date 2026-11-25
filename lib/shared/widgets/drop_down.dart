import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/extension/extension_helper.dart';
import '../../core/style/app_colors.dart';
import '../../l10n/l10n.dart';
import 'main_text.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> genderItems;
  final T? selectedValue;
  final String? hint;
  final String? label;
  final void Function(T?)? onChanged;
  final double? borderRadius;
  final String Function(T) getLabel;
  final Color? textColor;
  final Color? hintTextColor;
  final bool isTablet;

  const CustomDropdown({
    required this.genderItems,
    required this.selectedValue,
    required this.getLabel,
    super.key,
    this.textColor,
    this.hint,
    this.label,
    this.hintTextColor,
    this.onChanged,
    this.borderRadius,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DropdownButtonFormField2<T>(
      isExpanded: true,
      value: selectedValue,
      selectedItemBuilder: (context) {
        return genderItems
            .map(
              (item) => Container(
                alignment: context.isArabic
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainText(
                      context.l10n.gender,
                      fontSize: isTablet ? 20 : 14,
                      fontWeight: FontWeight.w500,
                      color: textColor ?? scheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    MainText(
                      getLabel(item),
                      fontSize: isTablet ? 20 : 14,
                      fontWeight: FontWeight.w500,
                      color: textColor ?? scheme.onSurface,
                    ),
                  ],
                ),
              ),
            )
            .toList();
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        isDense: true,
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: isTablet ? 24 : 14,
              fontWeight: FontWeight.w400,
              color: scheme.onSurfaceVariant,
            ),
      ),
      hint: Container(
        alignment:
            context.isArabic ? Alignment.centerRight : Alignment.centerLeft,
        child: MainText(
          '$hint',
          fontSize: isTablet ? 20 : 12,
          color: hintTextColor ?? Theme.of(context).hintColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      items: genderItems
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MainText(
                  getLabel(item),
                  fontSize: isTablet ? 24 : 15,
                  fontWeight: FontWeight.w500,
                  color: context.isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          )
          .toList(),
      validator: (value) {
        if (value == null) {
          return '${context.l10n.please_select} $hint.';
        }
        return null;
      },
      onChanged: onChanged,
      onSaved: (value) {
        if (onChanged != null) onChanged!(value);
      },
      buttonStyleData: ButtonStyleData(
        height: isTablet ? 72 : 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      iconStyleData: IconStyleData(
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: FaIcon(FontAwesomeIcons.caretDown,
              size: 20, color: scheme.primary),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: isTablet ? 350 : 250,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: context.isDark ? MyColors.darkItemBG5 : MyColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: MyColors.grey300),
        ),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: WidgetStateProperty.all(4),
          thumbVisibility: WidgetStateProperty.all(true),
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: EdgeInsets.zero,
        height: isTablet ? 72 : 48,
      ),
    );
  }
}
