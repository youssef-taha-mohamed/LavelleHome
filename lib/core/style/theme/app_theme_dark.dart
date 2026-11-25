import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'components/appbar_theme.dart';
import 'components/buttons_theme.dart';
import 'components/card_theme.dart';
import 'components/date_picker_theme.dart';
import 'components/input_theme.dart';
import 'components/navigation_theme.dart';
import 'components/time_picker_theme.dart';
import 'extensions/app_colors_extension.dart';
import 'extensions/app_theme_extension.dart';
import 'typography/typography.dart';

class AppThemeDark {
  static ThemeData build(ColorScheme scheme, Locale locale) {
    final fontFamily = AppTypography.getFontFamily(locale);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: fontFamily,
      textTheme: AppTypography.applyFontFamily(
        AppTypography.baseTextTheme,
        fontFamily,
      ),
      appBarTheme: AppBarThemes.dark(scheme, fontFamily),
      inputDecorationTheme: InputThemes.dark(scheme, fontFamily),
      navigationBarTheme: NavigationThemes.dark(scheme, fontFamily),
      cardTheme: CardThemes.dark(scheme),
      datePickerTheme: DatePickerThemes.dark(scheme),
      timePickerTheme: TimePickerThemes.dark(scheme),
      buttonTheme: AppButtonsTheme.legacyButtons(scheme),
      scaffoldBackgroundColor: MyColors.darkThemeBg,
      canvasColor: MyColors.darkItemBG5,
      cardColor: MyColors.black.withValues(alpha: 0.7),
      extensions: [
        AppColorsExtension.dark,
        AppThemeExtension(
          radiusSmall: 6,
          radiusMedium: 12,
          radiusLarge: 20,
          defaultPadding: const EdgeInsets.all(16),
          screenPadding: const EdgeInsets.symmetric(horizontal: 20),
          cardBackground: const Color(0xFF0B0B0B),
          elevatedSurface: const Color(0xFF141414),
          borderColor: Colors.white.withValues(alpha: 0.08),
          smallShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .65),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          mediumShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .75),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          animationDuration: const Duration(milliseconds: 200),
          defaultCurve: Curves.easeInOut,
          primaryGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF000000), Color(0xFF111111)],
          ),
          primaryBorderColor: Colors.white.withValues(alpha: 0.08),
          primaryBorderWidth: 1.5,
          coursesGradient: LinearGradient(
            colors: [
              MyColors.primaryColor.withValues(alpha: 0.15),
              MyColors.primaryColor.withValues(alpha: 0.05),
            ],
          ),
          coursesBorderColor: MyColors.primaryColor.withValues(alpha: 0.3),
          coursesShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          progressGradient: LinearGradient(
            colors: [
              MyColors.islamicGold.withValues(alpha: 0.15),
              MyColors.islamicGold.withValues(alpha: 0.05),
            ],
          ),
          progressBorderColor: MyColors.islamicGold.withValues(alpha: 0.3),
          progressShadow: [
            BoxShadow(
              color: MyColors.islamicGold.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: -1,
            ),
          ],
          lessonGradient: LinearGradient(
            colors: [
              MyColors.lightTeal.withValues(alpha: 0.15),
              MyColors.lightTeal.withValues(alpha: 0.05),
            ],
          ),
          lessonBorderColor: MyColors.lightTeal.withValues(alpha: 0.3),
          lessonShadow: [
            BoxShadow(
              color: MyColors.lightTeal.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: -1,
            ),
          ],
        ),
      ],
      dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF1B2735)),
    );
  }
}
