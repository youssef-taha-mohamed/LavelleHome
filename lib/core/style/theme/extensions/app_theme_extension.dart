import 'dart:ui';
import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final double radiusSmall;
  final double radiusMedium;
  final double radiusLarge;
  final EdgeInsets defaultPadding;
  final EdgeInsets screenPadding;
  final Color cardBackground;
  final Color elevatedSurface;
  final Color borderColor;
  final List<BoxShadow> smallShadow;
  final List<BoxShadow> mediumShadow;
  final LinearGradient primaryGradient;
  final Color primaryBorderColor;
  final double primaryBorderWidth;
  final Duration animationDuration;
  final Curve defaultCurve;
  final LinearGradient coursesGradient;
  final Color coursesBorderColor;
  final LinearGradient progressGradient;
  final Color progressBorderColor;
  final LinearGradient lessonGradient;
  final Color lessonBorderColor;
  final List<BoxShadow> coursesShadow;
  final List<BoxShadow> progressShadow;
  final List<BoxShadow> lessonShadow;

  const AppThemeExtension({
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusLarge,
    required this.defaultPadding,
    required this.screenPadding,
    required this.cardBackground,
    required this.elevatedSurface,
    required this.borderColor,
    required this.smallShadow,
    required this.mediumShadow,
    required this.animationDuration,
    required this.defaultCurve,
    required this.primaryGradient,
    required this.primaryBorderColor,
    required this.primaryBorderWidth,
    required this.coursesGradient,
    required this.coursesBorderColor,
    required this.progressGradient,
    required this.progressBorderColor,
    required this.lessonGradient,
    required this.lessonBorderColor,
    required this.coursesShadow,
    required this.progressShadow,
    required this.lessonShadow,
  });

  @override
  AppThemeExtension copyWith({
    double? radiusSmall,
    double? radiusMedium,
    double? radiusLarge,
    EdgeInsets? defaultPadding,
    EdgeInsets? screenPadding,
    Color? cardBackground,
    Color? elevatedSurface,
    Color? borderColor,
    List<BoxShadow>? smallShadow,
    List<BoxShadow>? mediumShadow,
    Duration? animationDuration,
    Curve? defaultCurve,
    LinearGradient? primaryGradient,
    Color? primaryBorderColor,
    double? primaryBorderWidth,
    LinearGradient? coursesGradient,
    Color? coursesBorderColor,
    LinearGradient? progressGradient,
    Color? progressBorderColor,
    LinearGradient? lessonGradient,
    Color? lessonBorderColor,
    List<BoxShadow>? coursesShadow,
    List<BoxShadow>? progressShadow,
    List<BoxShadow>? lessonShadow,
  }) {
    return AppThemeExtension(
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radiusMedium: radiusMedium ?? this.radiusMedium,
      radiusLarge: radiusLarge ?? this.radiusLarge,
      defaultPadding: defaultPadding ?? this.defaultPadding,
      screenPadding: screenPadding ?? this.screenPadding,
      cardBackground: cardBackground ?? this.cardBackground,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      borderColor: borderColor ?? this.borderColor,
      smallShadow: smallShadow ?? this.smallShadow,
      mediumShadow: mediumShadow ?? this.mediumShadow,
      animationDuration: animationDuration ?? this.animationDuration,
      defaultCurve: defaultCurve ?? this.defaultCurve,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      primaryBorderColor: primaryBorderColor ?? this.primaryBorderColor,
      primaryBorderWidth: primaryBorderWidth ?? this.primaryBorderWidth,
      coursesGradient: coursesGradient ?? this.coursesGradient,
      coursesBorderColor: coursesBorderColor ?? this.coursesBorderColor,
      progressGradient: progressGradient ?? this.progressGradient,
      progressBorderColor: progressBorderColor ?? this.progressBorderColor,
      lessonGradient: lessonGradient ?? this.lessonGradient,
      lessonBorderColor: lessonBorderColor ?? this.lessonBorderColor,
      coursesShadow: coursesShadow ?? this.coursesShadow,
      progressShadow: progressShadow ?? this.progressShadow,
      lessonShadow: lessonShadow ?? this.lessonShadow,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;

    return AppThemeExtension(
      radiusSmall: lerpDouble(radiusSmall, other.radiusSmall, t)!,
      radiusMedium: lerpDouble(radiusMedium, other.radiusMedium, t)!,
      radiusLarge: lerpDouble(radiusLarge, other.radiusLarge, t)!,
      defaultPadding: EdgeInsets.lerp(defaultPadding, other.defaultPadding, t)!,
      screenPadding: EdgeInsets.lerp(screenPadding, other.screenPadding, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      smallShadow: _lerpShadows(smallShadow, other.smallShadow, t),
      mediumShadow: _lerpShadows(mediumShadow, other.mediumShadow, t),
      animationDuration: Duration(
          milliseconds: lerpDouble(animationDuration.inMilliseconds.toDouble(),
                  other.animationDuration.inMilliseconds.toDouble(), t)!
              .round()),
      defaultCurve: other.defaultCurve,
      primaryGradient:
          LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      primaryBorderColor:
          Color.lerp(primaryBorderColor, other.primaryBorderColor, t)!,
      primaryBorderWidth:
          lerpDouble(primaryBorderWidth, other.primaryBorderWidth, t)!,
      coursesGradient:
          LinearGradient.lerp(coursesGradient, other.coursesGradient, t)!,
      coursesBorderColor:
          Color.lerp(coursesBorderColor, other.coursesBorderColor, t)!,
      progressGradient:
          LinearGradient.lerp(progressGradient, other.progressGradient, t)!,
      progressBorderColor:
          Color.lerp(progressBorderColor, other.progressBorderColor, t)!,
      lessonGradient:
          LinearGradient.lerp(lessonGradient, other.lessonGradient, t)!,
      lessonBorderColor:
          Color.lerp(lessonBorderColor, other.lessonBorderColor, t)!,
      coursesShadow:
          AppThemeExtension._lerpShadows(coursesShadow, other.coursesShadow, t),
      progressShadow: AppThemeExtension._lerpShadows(
          progressShadow, other.progressShadow, t),
      lessonShadow:
          AppThemeExtension._lerpShadows(lessonShadow, other.lessonShadow, t),
    );
  }

  Border get primaryBorder => Border.all(
        color: primaryBorderColor,
        width: primaryBorderWidth,
      );

  Border get coursesBorder => Border.all(color: coursesBorderColor, width: 1.5);

  Border get progressBorder =>
      Border.all(color: progressBorderColor, width: 1.5);

  Border get lessonBorder => Border.all(color: lessonBorderColor, width: 1.5);

  static List<BoxShadow> _lerpShadows(
      List<BoxShadow> a, List<BoxShadow> b, double t) {
    if (a.length != b.length) return b;
    return List.generate(a.length, (i) {
      return BoxShadow(
        color: Color.lerp(a[i].color, b[i].color, t)!,
        blurRadius: lerpDouble(a[i].blurRadius, b[i].blurRadius, t)!,
        offset: Offset.lerp(a[i].offset, b[i].offset, t)!,
        spreadRadius: lerpDouble(a[i].spreadRadius, b[i].spreadRadius, t)!,
      );
    });
  }
}
