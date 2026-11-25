import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_color/dynamic_color.dart';
import '../../../shared/cubits/language/language_cubit.dart';
import '../../../shared/cubits/theme/theme_cubit.dart';
import 'app_theme_light.dart';
import 'app_theme_dark.dart';
import 'color_schemes/seed_scheme.dart';

class ThemeManager extends StatelessWidget {
  final Widget child;
  const ThemeManager({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        // IMPORTANT: don't try to override Localizations here.
        // ThemeManager only computes themes & locale and exposes them via ThemeScope.
        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, langState) {
            final locale = Locale(langState.languageCode);

            return BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                final isDark = themeState.isDark;

                final ColorScheme lightScheme =
                    lightDynamic ?? SeedColorScheme.lightScheme;
                final ColorScheme darkScheme =
                    darkDynamic ?? SeedColorScheme.darkScheme;

                final ThemeData lightTheme =
                AppThemeLight.build(lightScheme, locale);
                final ThemeData darkTheme =
                AppThemeDark.build(darkScheme, locale);

                return ThemeScope(
                  locale: locale,
                  themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                  lightTheme: lightTheme,
                  darkTheme: darkTheme,
                  child: child,
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Public InheritedWidget so other files can access it.
class ThemeScope extends InheritedWidget {
  final Locale locale;
  final ThemeMode themeMode;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const ThemeScope({super.key,
    required super.child,
    required this.locale,
    required this.themeMode,
    required this.lightTheme,
    required this.darkTheme,
  });

  static ThemeScope of(BuildContext context) {
    final instance =
    context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    if (instance == null) {
      throw FlutterError(
          'ThemeScope.of() called with a context that does not contain a ThemeScope.\n'
              'Make sure you wrap your widget tree with ThemeManager (ThemeScope).');
    }
    return instance;
  }

  @override
  bool updateShouldNotify(covariant ThemeScope oldWidget) {
    return locale != oldWidget.locale ||
        themeMode != oldWidget.themeMode ||
        lightTheme != oldWidget.lightTheme ||
        darkTheme != oldWidget.darkTheme;
  }
}
