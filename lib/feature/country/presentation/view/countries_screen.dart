import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../core/utils/app_responsive.dart';
import '../cubit/country_cubit.dart';
import 'countries_mobile.dart';
import 'countries_tablet.dart';

class CountriesGuestView extends StatelessWidget {
  const CountriesGuestView({super.key});

  static const routeName = '/countries';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CountryCubit(
        repository: DependencyInjector.countryRepo,
      )..fetchCountries(),
      child: const CountriesViewContent(),
    );
  }
}

class CountriesViewContent extends StatefulWidget {
  const CountriesViewContent({super.key});

  @override
  State<CountriesViewContent> createState() => _CountriesViewContentState();
}

class _CountriesViewContentState extends State<CountriesViewContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = AppResponsive.getCategory(context);
    final bool isTablet = category == DeviceCategory.smallTablet ||
        category == DeviceCategory.largeTablet;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: isTablet ? const CountriesTabletView() : const CountriesMobileView(),
      ),
    );
  }
}
