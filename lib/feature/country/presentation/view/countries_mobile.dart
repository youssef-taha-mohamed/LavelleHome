import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/styles_link.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../cubit/country_cubit.dart';

class CountriesMobileView extends StatelessWidget {
  const CountriesMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CountryCubit, CountryState>(
          builder: (context, state) {
            final cubit = context.read<CountryCubit>();
            return Column(
              children: [
                _PhoneHeader(cubit: cubit),
                _SearchBar(cubit: cubit),
                Expanded(
                  child: _PhoneCountriesList(
                    state: state,
                    cubit: cubit,
                    isDarkMode: isDarkMode,
                  ),
                ),
                _BottomButton(state: state, cubit: cubit),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PhoneHeader extends StatelessWidget {
  const _PhoneHeader({required this.cubit});
  final CountryCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: EdgeInsets.all(AppResponsive.getPadding(context)),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        border: theme.primaryBorder,
        boxShadow: theme.mediumShadow,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          _AnimatedGlobeIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText.bigText(
                  context.l10n.select_your_country,
                  fontSize: AppResponsive.getFontSize(context, mobile: 18, smallTablet: 22),
                ),
                MainText(
                  '${cubit.countries.length} ${context.l10n.available_country}',
                  fontSize: AppResponsive.getFontSize(context, mobile: 13, smallTablet: 16),
                  color: MyColors.grey4,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedGlobeIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * math.pi,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MyColors.primaryColor, MyColors.lightTeal],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: MyColors.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.public_rounded, color: Colors.white, size: 28),
          ),
        );
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.cubit});
  final CountryCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.getPadding(context)),
      child: MainTextField(
        controller: cubit.searchController,
        onChanged: cubit.searchCountries,
        hint: context.l10n.search,
        prefixIcon: Icon(
          Icons.search_rounded,
          color: MyColors.primaryColor,
          size: AppResponsive.getIconSize(context, base: 24),
        ),
      ),
    );
  }
}

class _PhoneCountriesList extends StatelessWidget {
  const _PhoneCountriesList({
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

    if (state.isError) {
      return Center(child: Text(state.errorMessage ?? "Error"));
    }

    final countries = cubit.countries;

    if (countries.isEmpty) {
      return Center(child: Text(context.l10n.no_results_found));
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.getPadding(context)),
      itemCount: countries.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final country = countries[index];
        final isSelected = state.selectedCountry?.id == country.id;

        return _CountryItem(
          country: country,
          isSelected: isSelected,
          isDarkMode: isDarkMode,
          onTap: () => cubit.selectCountry(country),
        );
      },
    );
  }
}

class _CountryItem extends StatelessWidget {
  const _CountryItem({
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? MyColors.primaryColor.withValues(alpha: 0.1)
              : (isDarkMode ? MyColors.darkItemBG2 : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? MyColors.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            _FlagWidget(isoCode: country.isoCode),
            const SizedBox(width: 12),
            Expanded(
              child: MainText(
                country.name,
                fontSize: AppResponsive.getFontSize(context, mobile: 16, smallTablet: 18),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: MyColors.primaryColor),
          ],
        ),
      ),
    );
  }
}

class _FlagWidget extends StatelessWidget {
  final String isoCode;
  const _FlagWidget({required this.isoCode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 30,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          imageUrl: 'https://flagcdn.com/w80/${isoCode.toLowerCase()}.png',
          fit: BoxFit.cover,
          placeholder: (_, _) => Container(color: Colors.grey[300]),
          errorWidget: (_, _, _) => const Icon(Icons.flag),
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({required this.state, required this.cubit});
  final CountryState state;
  final CountryCubit cubit;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = state.selectedCountry != null;

    return Padding(
      padding: EdgeInsets.all(AppResponsive.getPadding(context)),
      child: MainButton(
        onPressed: isEnabled
            ? () {
                
              }
            : () {},
        title: context.l10n.continue_step,
        backgroundColor: isEnabled ? MyColors.primaryColor : MyColors.grey4,
      ),
    );
  }
}
