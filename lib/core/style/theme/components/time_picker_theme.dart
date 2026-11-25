import 'package:flutter/material.dart';

class TimePickerThemes {
  TimePickerThemes._();

  static TimePickerThemeData light(ColorScheme scheme) {
    return TimePickerThemeData(
      backgroundColor: scheme.surface,
      hourMinuteColor: WidgetStateColor.resolveWith(
        (states) {
          return states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.surfaceContainerHighest;
        },
      ),
      hourMinuteTextColor: scheme.onSurface,
      dialBackgroundColor: scheme.surfaceContainerHighest,
      dialHandColor: scheme.primary,
    );
  }

  static TimePickerThemeData dark(ColorScheme scheme) {
    return TimePickerThemeData(
      backgroundColor: scheme.surface,
      hourMinuteColor: WidgetStateColor.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? scheme.primary
            : scheme.surfaceContainerHighest;
      }),
      hourMinuteTextColor: scheme.onSurface,
      dialBackgroundColor: scheme.surfaceContainerHighest,
      dialHandColor: scheme.primary,
    );
  }
}
