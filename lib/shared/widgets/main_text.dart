import 'package:flutter/material.dart';

class MainText extends StatelessWidget {
  const MainText(
      this.text, {
        super.key,
        this.color,
        this.fontSize,
        this.fontWeight,
        this.fontFamily,
        this.textAlign,
        this.textDirection,
        this.maxLines,
        this.overflow,
        this.decoration,
        this.fontStyle,
        this.shadows,
        this.letterSpacing,
        this.height,
        this.fontFeatures
      });

  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;
  final List<Shadow>? shadows;
  final double? letterSpacing;
  final double? height;
  final List<FontFeature>? fontFeatures;

  /// Custom constructors (unchanged)

  const MainText.heading(
      this.text, {
        super.key,
        this.color,
        this.fontSize = 14,
        this.fontWeight = FontWeight.w700,
        this.fontFamily,
        this.textAlign,
        this.textDirection,
        this.maxLines,
        this.overflow,
        this.decoration,
        this.fontStyle,
        this.shadows,
        this.letterSpacing,
        this.height,
        this.fontFeatures
      });

  const MainText.subHeading(
      this.text, {
        super.key,
        this.color,
        this.fontSize = 12,
        this.fontWeight = FontWeight.w400,
        this.fontFamily,
        this.textAlign,
        this.textDirection,
        this.maxLines,
        this.overflow,
        this.decoration,
        this.fontStyle,
        this.shadows,
        this.letterSpacing,
        this.height,
        this.fontFeatures
      });

  const MainText.txtButton(
      this.text, {
        super.key,
        this.color,
        this.fontSize = 11,
        this.fontWeight = FontWeight.w700,
        this.fontFamily,
        this.textAlign,
        this.textDirection,
        this.maxLines,
        this.overflow,
        this.decoration,
        this.fontStyle,
        this.shadows,
        this.letterSpacing,
        this.height,
        this.fontFeatures
      });

  const MainText.bigText(
      this.text, {
        super.key,
        this.color,
        this.fontSize = 18,
        this.fontWeight = FontWeight.bold,
        this.fontFamily,
        this.textAlign,
        this.textDirection,
        this.maxLines,
        this.overflow,
        this.decoration,
        this.fontStyle,
        this.shadows,
        this.letterSpacing,
        this.height,
        this.fontFeatures
      });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;

    return Text(
      text,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      style: defaultStyle.copyWith(
        color: color ?? defaultStyle.color,
        fontSize: fontSize ?? defaultStyle.fontSize,
        fontWeight: fontWeight ?? defaultStyle.fontWeight,
        fontFamily: fontFamily ?? defaultStyle.fontFamily,
        fontStyle: fontStyle ?? defaultStyle.fontStyle,
        shadows: shadows ?? defaultStyle.shadows,
        letterSpacing: letterSpacing ?? defaultStyle.letterSpacing,
        height: height ?? defaultStyle.height,
        decoration: decoration,
        fontFeatures: fontFeatures
      ),
    );
  }
}
