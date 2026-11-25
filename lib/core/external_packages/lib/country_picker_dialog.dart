import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/cubits/theme/theme_cubit.dart';
import '../../../shared/widgets/main_text.dart';
import '../../../shared/widgets/main_text_field.dart';
import '../../extension/extension_helper.dart';
import '../../style/app_colors.dart';
import '../../style/theme/extensions/app_theme_extension.dart';
import 'countries.dart';
import 'helpers.dart';

class PickerDialogStyle {
  final Color? backgroundColor;
  final TextStyle? countryCodeStyle;
  final TextStyle? countryNameStyle;
  final Widget? listTileDivider;
  final EdgeInsets? listTilePadding;
  final EdgeInsets? padding;
  final Color? searchFieldCursorColor;
  final InputDecoration? searchFieldInputDecoration;
  final EdgeInsets? searchFieldPadding;
  final double? width;

  PickerDialogStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
    this.width,
  });
}

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String searchText;
  final List<Country> filteredCountries;
  final PickerDialogStyle? style;
  final String languageCode;
  final bool arabCountriesFirst;

  const CountryPickerDialog({
    super.key,
    required this.searchText,
    required this.languageCode,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.style,
    this.arabCountriesFirst = true,
  });

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = sortCountryList(
      widget.filteredCountries,
      languageCode: widget.languageCode,
      arabCountriesFirst: widget.arabCountriesFirst,
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final width = widget.style?.width ?? mediaWidth;
    const defaultHorizontalPadding = 40.0;
    const defaultVerticalPadding = 24.0;
    final theme = Theme.of(context).extension<AppThemeExtension>();
    final isDarkMode =
        context.bloc<ThemeCubit>()?.state.isDark ?? context.isDark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: EdgeInsets.symmetric(
        vertical: defaultVerticalPadding,
        horizontal: mediaWidth > (width + defaultHorizontalPadding * 2)
            ? (mediaWidth - width) / 2
            : defaultHorizontalPadding,
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E24) : Colors.white,
          gradient: theme?.primaryGradient,
          border: theme?.primaryBorder ??
              Border.all(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08),
              ),
          boxShadow: theme?.mediumShadow ?? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    spacing: 12,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MyColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.flag,
                          color: MyColors.primaryColor,
                          size: 24,
                        ),
                      ),
                      Expanded(
                        child: MainText(
                          context.l10n.select_your_country,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyColors.primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: MyColors.primaryColor),
                      ),
                    ],
                  ),
                  Divider(
                    color: MyColors.primaryColor.withValues(alpha: 0.2),
                    thickness: 1,
                  ),
                ],
              ),
            ),

            // Search Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: MainTextField(
                controller: _searchController,
                hint: widget.searchText,
                prefixIcons: Icons.search,
                onChanged: (value) {
                  setState(() {
                    _filteredCountries = sortCountryList(
                      widget.countryList.stringSearch(value),
                      languageCode: widget.languageCode,
                      arabCountriesFirst: widget.arabCountriesFirst,
                    );
                  });
                },
              ),
            ),

            const SizedBox(height: 8),

            // Countries List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _filteredCountries.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (ctx, index) {
                  final country = _filteredCountries[index];
                  final isSelected = country.code == _selectedCountry.code;

                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MyColors.primaryColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? MyColors.primaryColor.withValues(alpha: 0.3)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://flagcdn.com/80x60/${country.code.toLowerCase()}.png',
                              width: 40,
                              height: 30,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.withValues(alpha: 0.1),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 40,
                                height: 30,
                                color: Colors.grey.withValues(alpha: 0.2),
                                alignment: Alignment.center,
                                child: Text(
                                  country.flag,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: MainText(
                                country.localizedName(widget.languageCode),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                color: isSelected
                                    ? MyColors.primaryColor
                                    : isDarkMode
                                        ? MyColors.white
                                        : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? MyColors.primaryColor.withValues(alpha: 0.15)
                                    : (isDarkMode
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : Colors.black.withValues(alpha: 0.05)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                country.code,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? MyColors.primaryColor
                                      : (isDarkMode
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: MainText(
                                '+${country.dialCode}',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: isSelected
                                    ? MyColors.primaryColor
                                    : isDarkMode
                                        ? MyColors.white
                                        : Colors.black87,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.check_circle,
                                color: MyColors.primaryColor,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                        onTap: () {
                          _selectedCountry = country;
                          widget.onCountryChanged(_selectedCountry);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CountryPickerBottomSheet extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String searchText;
  final List<Country> filteredCountries;
  final PickerDialogStyle? style;
  final String languageCode;
  final bool arabCountriesFirst;

  const CountryPickerBottomSheet({
    super.key,
    required this.searchText,
    required this.languageCode,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.style,
    this.arabCountriesFirst = true,
  });

  @override
  State<CountryPickerBottomSheet> createState() =>
      _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = sortCountryList(
      widget.filteredCountries,
      languageCode: widget.languageCode,
      arabCountriesFirst: widget.arabCountriesFirst,
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        context.bloc<ThemeCubit>()?.state.isDark ?? context.isDark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.82,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E24) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Drag handle pill
            Center(
              child: Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.flag_rounded,
                      color: MyColors.primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText(
                          context.l10n.select_your_country,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                        Text(
                          '${_filteredCountries.length} ${widget.languageCode.startsWith('ar') ? 'دولة متاحة' : 'countries available'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
              height: 1,
            ),
            const SizedBox(height: 12),

            // Search Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MainTextField(
                controller: _searchController,
                hint: widget.searchText,
                prefixIcons: Icons.search_rounded,
                onChanged: (value) {
                  setState(() {
                    _filteredCountries = sortCountryList(
                      widget.countryList.stringSearch(value),
                      languageCode: widget.languageCode,
                      arabCountriesFirst: widget.arabCountriesFirst,
                    );
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            // Countries List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                itemCount: _filteredCountries.length,
                separatorBuilder: (context, index) => const SizedBox(height: 6),
                itemBuilder: (ctx, index) {
                  final country = _filteredCountries[index];
                  final isSelected = country.code == _selectedCountry.code;

                  final isArab = arabCountryCodes.contains(country.code);
                  final prevIsArab = index > 0 &&
                      arabCountryCodes
                          .contains(_filteredCountries[index - 1].code);
                  final showArabHeader = widget.arabCountriesFirst &&
                      _searchController.text.isEmpty &&
                      index == 0 &&
                      isArab;
                  final showOtherHeader = widget.arabCountriesFirst &&
                      _searchController.text.isEmpty &&
                      !isArab &&
                      (index == 0 || prevIsArab);

                  final card = Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MyColors.primaryColor.withValues(alpha: 0.12)
                          : (isDarkMode
                              ? Colors.white.withValues(alpha: 0.02)
                              : Colors.black.withValues(alpha: 0.01)),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? MyColors.primaryColor.withValues(alpha: 0.4)
                            : Colors.transparent,
                        width: 1.2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 2,
                        ),
                        leading: Container(
                          width: 38,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.25),
                              width: 0.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://flagcdn.com/80x60/${country.code.toLowerCase()}.png',
                              width: 38,
                              height: 28,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.withValues(alpha: 0.1),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 38,
                                height: 28,
                                color: Colors.grey.withValues(alpha: 0.15),
                                alignment: Alignment.center,
                                child: Text(
                                  country.flag,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: MainText(
                                country.localizedName(widget.languageCode),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: 14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                color: isSelected
                                    ? MyColors.primaryColor
                                    : (isDarkMode
                                        ? Colors.white
                                        : Colors.black87),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? MyColors.primaryColor.withValues(alpha: 0.18)
                                    : (isDarkMode
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : Colors.black.withValues(alpha: 0.05)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                country.code,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? MyColors.primaryColor
                                      : (isDarkMode
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: MainText(
                                '+${country.dialCode}',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: isSelected
                                    ? MyColors.primaryColor
                                    : (isDarkMode
                                        ? Colors.white
                                        : Colors.black87),
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.check_circle_rounded,
                                color: MyColors.primaryColor,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                        onTap: () {
                          _selectedCountry = country;
                          widget.onCountryChanged(_selectedCountry);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );

                  if (showArabHeader || showOtherHeader) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: showOtherHeader ? 14 : 4,
                            bottom: 8,
                            left: 4,
                            right: 4,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                showArabHeader ? Icons.public : Icons.language,
                                size: 16,
                                color: showArabHeader
                                    ? MyColors.primaryColor
                                    : (isDarkMode
                                        ? Colors.white60
                                        : Colors.black45),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                showArabHeader
                                    ? (widget.languageCode == 'ar'
                                        ? 'دول الوطن العربي'
                                        : 'Arab Countries')
                                    : (widget.languageCode == 'ar'
                                        ? 'باقي دول العالم'
                                        : 'Other Countries'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: showArabHeader
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: showArabHeader
                                      ? MyColors.primaryColor
                                      : (isDarkMode
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Divider(
                                  color: showArabHeader
                                      ? MyColors.primaryColor
                                          .withValues(alpha: 0.25)
                                      : (isDarkMode
                                          ? Colors.white.withValues(alpha: 0.12)
                                          : Colors.black.withValues(alpha: 0.08)),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        card,
                      ],
                    );
                  }

                  return card;
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
