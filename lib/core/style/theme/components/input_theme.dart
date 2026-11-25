import 'package:flutter/material.dart';
import '../../app_colors.dart';

class InputThemes {
  InputThemes._();

  static const double _radiusMedium = 12;

  static InputDecorationTheme _baseTheme({
    required ColorScheme scheme,
    required String fontFamily,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;

    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? MyColors.darkItemBG3 : MyColors.white,
      labelStyle: TextStyle(
        fontFamily: fontFamily,
        color: scheme.onSurfaceVariant,
        fontSize: 14,
      ),
      hintStyle: TextStyle(
        fontFamily: fontFamily,
        color: scheme.onSurfaceVariant.withAlpha(180),
        fontSize: 13,
      ),
      helperStyle: TextStyle(
        fontSize: 12,
        color: scheme.onSurfaceVariant.withAlpha(200),
      ),
      errorStyle: TextStyle(fontSize: 12, color: scheme.error),
      // 🎯 استخدام قيم ثابتة للـ borderRadius
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMedium),
        borderSide: BorderSide(color: scheme.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMedium),
        borderSide: BorderSide(color: scheme.primary, width: 1.8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMedium),
        borderSide: BorderSide(color: scheme.outline.withAlpha(120), width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMedium),
        borderSide: BorderSide(color: scheme.error, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMedium),
        borderSide: BorderSide(color: scheme.error, width: 1.8),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusMedium),
        borderSide: BorderSide(color: scheme.outline.withAlpha(80), width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  static InputDecorationTheme light(ColorScheme scheme, String fontFamily) {
    return _baseTheme(
      scheme: scheme,
      fontFamily: fontFamily,
      brightness: Brightness.light,
    );
  }

  static InputDecorationTheme dark(ColorScheme scheme, String fontFamily) {
    return _baseTheme(
      scheme: scheme,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
    );
  }
}
