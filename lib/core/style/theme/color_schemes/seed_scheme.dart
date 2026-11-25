import 'package:flutter/material.dart';
import '../../app_colors.dart';

class SeedColorScheme {
  SeedColorScheme._();

  /// Light ColorScheme using Material 3 seed system
  static ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: MyColors.primaryColor,
    brightness: Brightness.light,
  );

  /// Dark ColorScheme using Material 3 seed system
  static ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: MyColors.primaryColor,
    brightness: Brightness.dark,
  );
}
