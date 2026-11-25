import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../core/di/dependency_injector.dart';
import '../../../../../../core/extension/extension_helper.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../../l10n/l10n.dart';
import '../../../../../../shared/widgets/main_text.dart';
import '../../../../../../shared/widgets/main_text_field.dart';
import '../../../../../country/domain/entities/country.dart';
import '../../../../../country/presentation/cubit/country_cubit.dart';
import '../../../../../country/presentation/view/widgets/country_item.dart';

class CountryFieldWidget extends StatefulWidget {
  final Function(Countries country)? onCountrySelected;
  final Countries? selectedCountry;
  final bool readOnly;
  final bool isTablet;

  const CountryFieldWidget({
    super.key,
    this.onCountrySelected,
    this.selectedCountry,
    this.readOnly = false,
    this.isTablet = false,
  });

  @override
  State<CountryFieldWidget> createState() => _CountryFieldWidgetState();
}

class _CountryFieldWidgetState extends State<CountryFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isFilled = widget.selectedCountry != null;

    return GestureDetector(
      onTap: widget.readOnly
          ? null
          : () {
              _showCountrySelectionDialog(context);
            },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: context.l10n.select_your_country,
          labelStyle: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: widget.isTablet ? 24 : 14,
          ),
          hintStyle: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: widget.isTablet ? 24 : 14,
          ),
          filled: true,
          fillColor:
              widget.readOnly ? Colors.grey.withValues(alpha: 0.1) : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: MyColors.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: MyColors.grey),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: widget.isTablet ? 24 : 14,
          ),
          suffixIcon: Icon(
            widget.readOnly
                ? Icons.remove_red_eye_outlined
                : FontAwesomeIcons.caretDown.data,
            color: isFilled ? MyColors.primaryColor : Colors.grey[600],
            size: widget.isTablet ? 24 : 18,
          ),
        ),
        isEmpty: !isFilled,
        child: isFilled
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: widget.isTablet ? 64 : 36,
                    height: widget.isTablet ? 48 : 24,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://flagcdn.com/80x60/${widget.selectedCountry!.isoCode.toLowerCase()}.png',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(
                          Icons.flag_rounded,
                          color: MyColors.grey4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        MainText(
                          widget.selectedCountry?.name ?? "",
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w500,
                          fontSize: widget.isTablet ? 24 : 14,
                        ),
                        MainText(
                          widget.selectedCountry?.code ?? "",
                          color: scheme.onSurfaceVariant,
                          fontSize: widget.isTablet ? 20 : 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox(height: widget.isTablet ? 36 : 24),
      ),
    );
  }

  void _showCountrySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext dialogContext) {
        return Align(
          alignment: widget.isTablet
              ? (context.isArabic
                  ? Alignment.centerLeft
                  : Alignment.centerRight)
              : Alignment.center,
          child: Padding(
            padding:
                widget.isTablet ? const EdgeInsets.all(40) : EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.isTablet ? 650 : double.infinity,
                maxHeight: MediaQuery.of(context).size.height *
                    (widget.isTablet ? 0.8 : 0.75),
              ),
              child: BlocProvider(
                create: (context) =>
                    CountryCubit(repository: DependencyInjector.countryRepo)
                      ..fetchCountries(),
                child: BlocConsumer<CountryCubit, CountryState>(
                  listener: (context, state) {
                    if (state.isSelectedCountry) {
                      if (state.selectedCountry != null) {
                        widget.onCountrySelected?.call(state.selectedCountry!);
                        Navigator.of(dialogContext).pop();
                      }
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<CountryCubit>();
                    final theme =
                        Theme.of(context).extension<AppThemeExtension>()!;

                    return Dialog(
                      insetPadding: widget.isTablet
                          ? EdgeInsets.zero
                          : const EdgeInsets.all(24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: theme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                          border: theme.primaryBorder,
                          boxShadow: theme.mediumShadow,
                        ),
                        child: Column(
                          children: [
                            // Header
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: MyColors.primaryColor
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.public_rounded,
                                    color: MyColors.primaryColor,
                                    size: widget.isTablet ? 48 : 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: MainText.bigText(
                                    context.l10n.select_country,
                                    color: MyColors.primaryColor,
                                    fontSize: widget.isTablet ? 32 : 18,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: MyColors.primaryColor,
                                    size: widget.isTablet ? 48 : 24,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(
                              color:
                                  MyColors.primaryColor.withValues(alpha: 0.1),
                              thickness: 1.5,
                            ),
                            const SizedBox(height: 16),
                            // Search Field
                            MainTextField(
                              isTablet: widget.isTablet,
                              label: context.l10n.search,
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: MyColors.primaryColor,
                                size: widget.isTablet ? 48 : 24,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: widget.isTablet ? 24 : 16,
                              ),
                              onChanged: (value) {
                                cubit.searchCountries(value);
                              },
                              controller: cubit.searchController,
                            ),
                            const SizedBox(height: 24),
                            // Countries List / Grid
                            Expanded(
                              child: state.isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: MyColors.primaryColor,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : cubit.countries.isEmpty
                                      ? Center(
                                          child: MainText(
                                              context.l10n.no_results_found))
                                      : ListView.separated(
                                          padding: EdgeInsets.zero,
                                          separatorBuilder: (context, index) =>
                                              12.ph,
                                          itemCount: cubit.countries.length,
                                          itemBuilder: (context, index) {
                                            final country =
                                                cubit.countries[index];
                                            return CountryItem(
                                              isTablet: widget.isTablet,
                                              country: country,
                                              isSelected:
                                                  widget.selectedCountry?.id ==
                                                      country.id,
                                              isDarkMode: context.isDark,
                                              onTap: () =>
                                                  cubit.selectCountry(country),
                                            );
                                          },
                                        ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
