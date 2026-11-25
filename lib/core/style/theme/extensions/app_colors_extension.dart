import 'package:flutter/material.dart';

import '../../app_colors.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color darkPrimary;
  final Color darkPrimaryLight;
  final Color darkPrimaryDark;
  final Color background;
  final Color cardBackground;
  final Color containerBackground;

  // Text
  final Color textColor;
  final Color subTextColor;

  // NEW
  final Color settingsTileBackground;

  final Color darkItemBG;
  final Color darkItemBG2;
  final Color darkItemBG3;
  final Color darkItemBG4;
  final Color darkItemBG5;
  final Color darkItemBG6;

  const AppColorsExtension({
    required this.primary,
    required this.darkPrimary,
    required this.darkPrimaryLight,
    required this.darkPrimaryDark,
    required this.background,
    required this.cardBackground,
    required this.containerBackground,
    required this.settingsTileBackground,
    required this.darkItemBG,
    required this.darkItemBG2,
    required this.darkItemBG3,
    required this.darkItemBG4,
    required this.darkItemBG5,
    required this.darkItemBG6,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? darkPrimary,
    Color? darkPrimaryLight,
    Color? darkPrimaryDark,
    Color? background,
    Color? cardBackground,
    Color? containerBackground,
    Color? settingsTileBackground,
    Color? darkItemBG,
    Color? darkItemBG2,
    Color? darkItemBG3,
    Color? darkItemBG4,
    Color? darkItemBG5,
    Color? darkItemBG6,
    Color? textColor,
    Color? subTextColor,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      cardBackground: cardBackground ?? this.cardBackground,
      containerBackground: containerBackground ?? this.containerBackground,
      settingsTileBackground:
          settingsTileBackground ?? this.settingsTileBackground,
      darkItemBG: darkItemBG ?? this.darkItemBG,
      darkItemBG2: darkItemBG2 ?? this.darkItemBG2,
      darkItemBG3: darkItemBG3 ?? this.darkItemBG3,
      darkItemBG4: darkItemBG4 ?? this.darkItemBG4,
      darkItemBG5: darkItemBG5 ?? this.darkItemBG5,
      darkItemBG6: darkItemBG6 ?? this.darkItemBG6,
      textColor: textColor ?? this.textColor,
      subTextColor: subTextColor ?? this.subTextColor,
      primary: primary ?? this.primary,
      darkPrimary: darkPrimary ?? this.darkPrimary,
      darkPrimaryLight: darkPrimaryLight ?? this.darkPrimaryLight,
      darkPrimaryDark: darkPrimaryDark ?? this.darkPrimaryDark,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;

    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      containerBackground:
          Color.lerp(containerBackground, other.containerBackground, t)!,
      settingsTileBackground:
          Color.lerp(settingsTileBackground, other.settingsTileBackground, t)!,
      darkItemBG: Color.lerp(darkItemBG, other.darkItemBG, t)!,
      darkItemBG2: Color.lerp(darkItemBG2, other.darkItemBG2, t)!,
      darkItemBG3: Color.lerp(darkItemBG3, other.darkItemBG3, t)!,
      darkItemBG4: Color.lerp(darkItemBG4, other.darkItemBG4, t)!,
      darkItemBG5: Color.lerp(darkItemBG5, other.darkItemBG5, t)!,
      darkItemBG6: Color.lerp(darkItemBG6, other.darkItemBG6, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      subTextColor: Color.lerp(subTextColor, other.subTextColor, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      darkPrimary: Color.lerp(darkPrimary, other.darkPrimary, t)!,
      darkPrimaryLight: Color.lerp(darkPrimaryLight, other.darkPrimaryLight, t)!,
      darkPrimaryDark: Color.lerp(darkPrimaryDark, other.darkPrimaryDark, t)!,
    );
  }

  // Light Theme
  static const light = AppColorsExtension(
    background: MyColors.lightThemeBg,
    cardBackground: MyColors.white,
    containerBackground: MyColors.white,
    settingsTileBackground: MyColors.white,
    darkItemBG: MyColors.itemBG,
    darkItemBG2: MyColors.grey100,
    darkItemBG3: MyColors.grey50,
    darkItemBG4: MyColors.grey200,
    darkItemBG5: MyColors.grey300,
    darkItemBG6: MyColors.grey400,
    textColor: MyColors.black,
    subTextColor: MyColors.navyColorOpacity,
    primary: MyColors.primaryColor,
    darkPrimary: MyColors.darkPrimary,
    darkPrimaryLight: MyColors.darkPrimaryLight,
    darkPrimaryDark: MyColors.darkPrimaryDark,
  );

  // Dark Theme
  static const dark = AppColorsExtension(
    background: MyColors.darkThemeBg,
    cardBackground: MyColors.darkItemBG2,
    containerBackground: MyColors.darkItemBG3,
    settingsTileBackground: MyColors.darkItemBG5,
    darkItemBG: MyColors.darkItemBG,
    darkItemBG2: MyColors.darkItemBG2,
    darkItemBG3: MyColors.darkItemBG3,
    darkItemBG4: MyColors.darkItemBG4,
    darkItemBG5: MyColors.darkItemBG5,
    darkItemBG6: MyColors.darkItemBG6,
    textColor: MyColors.white,
    subTextColor: MyColors.grey400,
    primary: MyColors.primaryColor,
    darkPrimary: MyColors.darkPrimary,
    darkPrimaryLight: MyColors.darkPrimaryLight,
    darkPrimaryDark: MyColors.darkPrimaryDark,
  );
}
