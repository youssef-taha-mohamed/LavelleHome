import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/custom_back_and_title.dart';
import '../../../../shared/widgets/custom_background.dart';
import '../../../../shared/widgets/main_text_field.dart';
import '../cubit/country_cubit.dart';
import 'widgets/country_item.dart';

class CountriesView extends StatelessWidget {
  const CountriesView({super.key});

  static const routeName = '/countries';

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) =>
          CountryCubit(repository: DependencyInjector.countryRepo)
            ..fetchCountries(),
      child: BlocConsumer<CountryCubit, CountryState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = context.read<CountryCubit>();
          return Scaffold(
            body: Stack(
              children: [
                EnhancedIslamicBackground(
                  primaryColor: MyColors.darkGreen,
                  secondaryColor: Colors.white,
                  opacity: 0.1,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomBackAndTitle(
                          title: context.l10n.select_your_country,
                        ),
                        MainTextField(
                          label: context.l10n.search,
                          suffixIcon: Icon(
                            Icons.search,
                            color: MyColors.primaryColor,
                            size: 20,
                          ),
                          onChanged: (value) {
                            cubit.searchCountries(value);
                          },
                          controller: cubit.searchController,
                        ),
                        Expanded(
                          child: CustomScrollView(slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (state.isLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (state.isError) {
                                    return Center(child: Text(state.errorMessage!));
                                  }
                                  final country = cubit.countries[index];
                                  final isSelected = state.isSelectedCountry &&
                                      cubit.countries[index].flag == country.flag;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: CountryItem(
                                      country: country,
                                      isSelected: isSelected,
                                      isDarkMode: isDarkMode,
                                      onTap: (){
                                        cubit.selectCountry(country);
                                      },
                                    ),
                                  );
                                },
                                childCount: cubit.countries.length,
                              ),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
