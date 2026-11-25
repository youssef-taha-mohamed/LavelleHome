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

class AppThemeLight {
  static ThemeData build(ColorScheme scheme, Locale locale) {
    final fontFamily = AppTypography.getFontFamily(locale);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      fontFamily: fontFamily,
      textTheme: AppTypography.applyFontFamily(
          AppTypography.baseTextTheme, fontFamily),

      // Components
      appBarTheme: AppBarThemes.light(scheme, fontFamily),
      inputDecorationTheme: InputThemes.light(scheme, fontFamily),
      navigationBarTheme: NavigationThemes.light(scheme, fontFamily),
      cardTheme: CardThemes.light(scheme),
      datePickerTheme: DatePickerThemes.light(scheme),
      timePickerTheme: TimePickerThemes.light(scheme),
      buttonTheme: AppButtonsTheme.legacyButtons(scheme),
      // Extensions
      extensions: [
        AppColorsExtension.light,
        AppThemeExtension(
          radiusSmall: 6,
          radiusMedium: 12,
          radiusLarge: 20,
          defaultPadding: const EdgeInsets.all(16),
          screenPadding: const EdgeInsets.symmetric(horizontal: 20),
          cardBackground: scheme.surface,
          elevatedSurface: scheme.surfaceContainerHighest,
          borderColor: scheme.outline,
          smallShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: .1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
          mediumShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: .2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
          animationDuration: const Duration(milliseconds: 200),
          defaultCurve: Curves.easeInOut,
          primaryGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 1),
              Colors.white.withValues(alpha: 1),
            ],
          ),
          primaryBorderColor: Colors.white.withValues(alpha: 0.5),
          primaryBorderWidth: 1.5,
          coursesGradient: LinearGradient(
            colors: [
              MyColors.primaryColor.withValues(alpha: 0.1),
              MyColors.lightTeal.withValues(alpha: 0.05)
            ],
          ),
          coursesBorderColor: MyColors.primaryColor.withValues(alpha: 0.2),
          progressGradient: LinearGradient(
            colors: [
              MyColors.islamicGold.withValues(alpha: 0.1),
              MyColors.islamicGold.withValues(alpha: 0.05)
            ],
          ),
          progressBorderColor: MyColors.islamicGold.withValues(alpha: 0.2),
          lessonGradient: LinearGradient(
            colors: [
              MyColors.lightTeal.withValues(alpha: 0.1),
              MyColors.lightTeal.withValues(alpha: 0.05)
            ],
          ),
          coursesShadow: [
            BoxShadow(
              color: MyColors.primaryColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          progressShadow: [
            BoxShadow(
              color: MyColors.islamicGold.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          lessonBorderColor: MyColors.lightTeal.withValues(alpha: 0.2),
          lessonShadow: [
            BoxShadow(
              color: MyColors.lightTeal.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ],
    );
  }
}

//final colors = Theme.of(context).extension<AppColorsExtension>()!;
