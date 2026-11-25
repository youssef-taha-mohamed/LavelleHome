import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'seed_scheme.dart';

class DynamicColorBuilderWrapper {
  static Future<(ColorScheme light, ColorScheme dark)>
  getDynamicSchemes(BuildContext context) async {

    // Try to get dynamic colors
    final dynamicScheme = await DynamicColorPlugin.getCorePalette();

    if (dynamicScheme != null) {
      return (
      dynamicScheme.toColorScheme(brightness: Brightness.light),
      dynamicScheme.toColorScheme(brightness: Brightness.dark),
      );
    }

    // Fallback to seed color-based schemes
    return (
    SeedColorScheme.lightScheme,
    SeedColorScheme.darkScheme,
    );
  }
}
