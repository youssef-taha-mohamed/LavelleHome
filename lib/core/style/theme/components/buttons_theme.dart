import 'package:flutter/material.dart';

class AppButtonsTheme {
  static ButtonThemeData legacyButtons(ColorScheme scheme) {
    return ButtonThemeData(
      buttonColor: scheme.primary,
      disabledColor: scheme.onSurface.withValues(alpha: 0.12),
      focusColor: scheme.primary.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// Material 3 – FilledButton
  static FilledButtonThemeData filled(ColorScheme scheme) {
    return FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(scheme.primary),
        foregroundColor: WidgetStateProperty.all(scheme.onPrimary),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// Material 3 – OutlinedButton
  static OutlinedButtonThemeData outlined(ColorScheme scheme) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStateProperty.all(
          BorderSide(color: scheme.primary, width: 1.4),
        ),
        foregroundColor: WidgetStateProperty.all(scheme.primary),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// Material 3 – TextButton
  static TextButtonThemeData text(ColorScheme scheme) {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(scheme.primary),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }

  /// ElevatedButton (لو لسه بتستخدمه)
  static ElevatedButtonThemeData elevated(ColorScheme scheme) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(scheme.primary),
        foregroundColor: WidgetStateProperty.all(scheme.onPrimary),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: WidgetStateProperty.all(0),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
