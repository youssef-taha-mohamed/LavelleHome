import 'package:flutter/material.dart';

class CardThemes {
  CardThemes._();

  static CardThemeData light(ColorScheme scheme) {
    return CardThemeData(
      color: scheme.surface,
      elevation: 0,
      shadowColor: scheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  static CardThemeData dark(ColorScheme scheme) {
    return CardThemeData(
      color: scheme.surface,
      elevation: 0,
      shadowColor: scheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

