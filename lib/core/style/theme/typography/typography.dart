import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  /// Font families based on your selection
  static const String arabicFont = "Alexandria";
  static const String englishFont = "Rubik";

  /// Returns the correct font family by locale
  static String getFontFamily(Locale locale) {
    return locale.languageCode.toLowerCase() == "ar" ? arabicFont : englishFont;
  }

  /// Base TextTheme for Material 3 (sizes + weights)
  /// Font family will be injected later in ThemeManager
  static TextTheme baseTextTheme = const TextTheme(
    // Display
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),

    // Headlines
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),

    // Titles
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),

    // Body
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),

    // Labels
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
  );

  /// Apply the font family dynamically
  static TextTheme applyFontFamily(TextTheme base, String fontFamily) {
    return base.apply(
      fontFamily: fontFamily,
      decorationColor: Colors.transparent,
    );
  }
}
