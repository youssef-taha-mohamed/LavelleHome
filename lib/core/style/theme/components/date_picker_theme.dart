import 'package:flutter/material.dart';

class DatePickerThemes {
  DatePickerThemes._();

  static DatePickerThemeData light(ColorScheme scheme) {
    return DatePickerThemeData(
      backgroundColor: scheme.surface,
      headerBackgroundColor: scheme.primary,
      headerForegroundColor: scheme.onPrimary,
      headerHeadlineStyle: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headerHelpStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      dayStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      weekdayStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: scheme.primary,
      ),
      yearStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: scheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: scheme.error, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: scheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dayBackgroundColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return Colors.transparent;
        },
      ),
      dayForegroundColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.onPrimary;
          }
          if (states.contains(WidgetState.disabled)) {
            return scheme.outline.withValues(alpha: .5);
          }
          return scheme.onSurface;
        },
      ),
    );
  }

  static DatePickerThemeData dark(ColorScheme scheme) {
    return DatePickerThemeData(
      backgroundColor: scheme.surface,
      headerBackgroundColor: scheme.primary,
      headerForegroundColor: scheme.onPrimary,
      headerHeadlineStyle: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headerHelpStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      dayStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      weekdayStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: scheme.primary,
      ),
      yearStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: scheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: scheme.error, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: scheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dayBackgroundColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return Colors.transparent;
        },
      ),
      dayForegroundColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.onPrimary;
          }
          if (states.contains(WidgetState.disabled)) {
            return scheme.outline.withValues(alpha: .4);
          }
          return scheme.onSurface;
        },
      ),
    );
  }
}
