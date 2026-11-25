import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/styles_link.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../cubit/country_cubit.dart';

class CountriesTabletView extends StatelessWidget {
  const CountriesTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).extension<AppThemeExtension>()!;

    return Scaffold(
      body: BlocBuilder<CountryCubit, CountryState>(
        builder: (context, state) {
          final cubit = context.read<CountryCubit>();

          return Row(
            children: [
              // ── Left Side: Header + Search + Selected Info ──
              _TabletSidebar(
                  cubit: cubit,
                  state: state,
                  theme: theme,
                  isDarkMode: isDarkMode),

              // ── Right Side: Grid of Countries ──
              Expanded(
                child: SafeArea(
                  child: _TabletCountriesGrid(
                    state: state,
                    cubit: cubit,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabletSidebar extends StatelessWidget {
  const _TabletSidebar({
    required this.cubit,
    required this.state,
    required this.theme,
    required this.isDarkMode,
  });

  final CountryCubit cubit;
  final CountryState state;
  final AppThemeExtension theme;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppResponsive.getFontSize(context,
          mobile: 280, smallTablet: 270, largeTablet: 380),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryColor.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Padding(
              padding: EdgeInsets.all(AppResponsive.getPadding(context)),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(AppResponsive.getFontSize(context,
                      mobile: 10, smallTablet: 15, largeTablet: 15)),
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                        AppResponsive.getFontSize(context,
                            mobile: 10, smallTablet: 15, largeTablet: 15)),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: AppResponsive.getIconSize(context, base: 18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Globe Icon & Title
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.getPadding(context)),
              child: Row(
                children: [
                  _AnimatedGlobeIconTablet(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText.bigText(
                          context.l10n.select_your_country,
                          fontSize: AppResponsive.getFontSize(context,
                              mobile: 22, smallTablet: 18, largeTablet: 28),
                          fontWeight: AppResponsive.getFontWeight(
                              context, FontWeight.bold),
                        ),
                        // MainText(
                        //   '${cubit.countries.length} ${context.l10n.available_country}',
                        //   fontSize: AppResponsive.getFontSize(context,
                        //       mobile: 16, smallTablet: 16, largeTablet: 22),
                        //   color: MyColors.grey4,
                        //   fontWeight: FontWeight.w500,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Search Field
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.getPadding(context)),
              child: MainTextField(
                controller: cubit.searchController,
                onChanged: cubit.searchCountries,
                hint: context.l10n.search,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: MyColors.primaryColor,
                  size: AppResponsive.getIconSize(context, base: 28),
                ),
              ),
            ),

            const Spacer(),

            // Selected Country Card
            if (state.selectedCountry != null)
              Padding(
                padding: EdgeInsets.all(AppResponsive.getPadding(context)),
                child: _TabletSelectedCard(country: state.selectedCountry!),
              ),

            // Continue Button
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.getPadding(context),
                0,
                AppResponsive.getPadding(context),
                24,
              ),
              child: _TabletContinueButton(state: state),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedGlobeIconTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * math.pi,
          child: Container(
            width: AppResponsive.getFontSize(context,
                mobile: 56, smallTablet: 56, largeTablet: 80),
            height: AppResponsive.getFontSize(context,
                mobile: 56, smallTablet: 56, largeTablet: 80),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MyColors.primaryColor, MyColors.lightTeal],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: MyColors.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.public_rounded,
              color: Colors.white,
              size: AppResponsive.getIconSize(context, base: 36),
            ),
          ),
        );
      },
    );
  }
}

class _TabletSelectedCard extends StatelessWidget {
  const _TabletSelectedCard({required this.country});
  final dynamic country;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(AppResponsive.getPadding(context)),
      decoration: BoxDecoration(
        color: MyColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: MyColors.primaryColor.withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        children: [
          _FlagWidgetTablet(isoCode: country.isoCode),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MainText(
                //   context.l10n.selected_country,
                //   fontSize: AppResponsive.getFontSize(context,
                //       mobile: 14, smallTablet: 16),
                //   color: MyColors.grey4,
                // ),
                MainText(
                  country.name,
                  fontSize: AppResponsive.getFontSize(context,
                      mobile: 18, smallTablet: 18, largeTablet: 22),
                ),
              ],
            ),
          ),
          // const Icon(Icons.check_circle_rounded,
          //     color: MyColors.primaryColor, size: 28),
        ],
      ),
    );
  }
}

class _TabletContinueButton extends StatelessWidget {
  const _TabletContinueButton({required this.state});
  final CountryState state;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = state.selectedCountry != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? const LinearGradient(
                colors: [MyColors.primaryColor, MyColors.lightTeal])
            : LinearGradient(colors: [
                MyColors.grey4.withValues(alpha: 0.3),
                MyColors.grey4.withValues(alpha: 0.2)
              ]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                    color: MyColors.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6))
              ]
            : [],
      ),
      child: MainButton(
        height: AppResponsive.getFontSize(context,
            mobile: 54, smallTablet: 60, largeTablet: 68),
        onPressed: isEnabled
            ? () {
                HapticFeedback.mediumImpact();
                // Navigator.pushNamed(
                //   context,
                //   SubjectsScreen.routeName,
                //   arguments: SubjectsScreenArguments(
                //       countryId: state.selectedCountry!.id.toInt()),
                // );
              }
            : () {},
        title: context.l10n.continue_step,
        titleColor: isEnabled ? Colors.white : MyColors.grey4,
        backgroundColor: Colors.transparent,
        fontSize: AppResponsive.getFontSize(context,
            mobile: 18, smallTablet: 20, largeTablet: 22),
        fontWeight: AppResponsive.getFontWeight(context, FontWeight.bold),
      ),
    );
  }
}

class _TabletCountriesGrid extends StatelessWidget {
  const _TabletCountriesGrid({
    required this.state,
    required this.cubit,
    required this.isDarkMode,
  });

  final CountryState state;
  final CountryCubit cubit;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final countries = cubit.countries;

    return GridView.builder(
      padding: EdgeInsets.all(AppResponsive.getPadding(context)),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        final isSelected = state.selectedCountry?.id == country.id;

        return _TabletCountryGridItem(
          country: country,
          isSelected: isSelected,
          isDarkMode: isDarkMode,
          onTap: () => cubit.selectCountry(country),
        );
      },
    );
  }
}

class _TabletCountryGridItem extends StatelessWidget {
  const _TabletCountryGridItem({
    required this.country,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  final dynamic country;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.getPadding(context), vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? MyColors.primaryColor.withValues(alpha: 0.1)
              : (isDarkMode ? MyColors.darkItemBG2 : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? MyColors.primaryColor
                : (isDarkMode ? Colors.white10 : Colors.black12),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: MyColors.primaryColor.withValues(alpha: 0.2),
                      blurRadius: 12)
                ]
              : [],
        ),
        child: Row(
          spacing: 8,
          children: [
            _FlagWidgetTablet(isoCode: country.isoCode),
            Flexible(
              child: MainText(
                country.name,
                fontSize: AppResponsive.getFontSize(context,
                    mobile: 18, smallTablet: 18, largeTablet: 22),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? MyColors.primaryColor : null,
              ),
            ),
            // if (isSelected)
            //   const Icon(Icons.check_circle_rounded,
            //       color: MyColors.primaryColor, size: 28),
          ],
        ),
      ),
    );
  }
}

class _FlagWidgetTablet extends StatelessWidget {
  final String isoCode;
  const _FlagWidgetTablet({required this.isoCode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppResponsive.getFontSize(context, mobile: 56, smallTablet: 64),
      height: AppResponsive.getFontSize(context, mobile: 40, smallTablet: 48),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CachedNetworkImage(
          imageUrl: 'https://flagcdn.com/w160/${isoCode.toLowerCase()}.png',
          fit: BoxFit.cover,
          placeholder: (_, _) => Container(color: Colors.grey[300]),
          errorWidget: (_, _, _) => const Icon(Icons.flag, size: 32),
        ),
      ),
    );
  }
}
