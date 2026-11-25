import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarThemes {
  AppBarThemes._();

  static AppBarTheme light(ColorScheme scheme, String fontFamily) {
    return AppBarTheme(
      backgroundColor: scheme.surface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: scheme.onSurface),
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  static AppBarTheme dark(ColorScheme scheme, String fontFamily) {
    return AppBarTheme(
      backgroundColor: scheme.surface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: scheme.onSurface),
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
}
