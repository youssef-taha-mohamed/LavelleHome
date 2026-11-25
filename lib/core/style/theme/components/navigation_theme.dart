import 'package:flutter/material.dart';

class NavigationThemes {
  NavigationThemes._();

  static NavigationBarThemeData light(ColorScheme scheme, String fontFamily) {
    return NavigationBarThemeData(
      indicatorColor: scheme.primary.withValues(alpha: .2),
      backgroundColor: scheme.surface,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }

  static NavigationBarThemeData dark(ColorScheme scheme, String fontFamily) {
    return NavigationBarThemeData(
      indicatorColor: scheme.primary.withValues(alpha: .2),
      backgroundColor: scheme.surface,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
