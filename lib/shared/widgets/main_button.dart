import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../core/style/app_colors.dart';

class MainButton extends StatefulWidget {
  const MainButton({
    super.key,
    this.title = '',
    this.titleColor,
    this.textStyle,
    this.backgroundColor,
    this.height,
    this.width,
    this.onPressed,
    this.maxLines,
    this.overflow,
    this.borderColor,
    this.borderWidth,
    this.child,
    this.borderRadius = 12.0,
    this.foregroundColor,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.margin,
    this.isLoading = false,
  });

  final String title;
  final Color? titleColor, backgroundColor;
  final Widget? child;
  final double? height, width;
  final FutureOr<dynamic> Function()? onPressed;
  final TextStyle? textStyle;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsets? margin;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isLoading;

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool _isFutureBusy = false;

  void _setFutureBusy(bool value) {
    if (mounted) {
      setState(() {
        _isFutureBusy = value;
      });
    }
  }

  bool get _isBusy => _isFutureBusy || widget.isLoading;

  Widget _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.foregroundColor ?? MyColors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = widget.backgroundColor ?? MyColors.primaryColor;

    Color? buttonColor;
    if (_isBusy) {
      buttonColor = Color.lerp(primaryColor, Colors.white, 0.3);
    } else if (widget.onPressed == null) {
      buttonColor =
          widget.backgroundColor ??
          (isDark ? Colors.white12 : Colors.grey[400]);
    } else {
      buttonColor = primaryColor;
    }

    final Function()? finalOnPressed = _isBusy ? null : widget.onPressed;

    final Color defaultTextColor = widget.onPressed == null
        ? (isDark ? Colors.white38 : MyColors.grey4)
        : MyColors.white;

    final Widget finalChild = _isBusy
        ? _buildLoadingIndicator()
        : widget.child ??
              AutoSizeText(
                widget.title,
                maxLines: widget.maxLines ?? 1,
                overflow: widget.overflow ?? TextOverflow.ellipsis,
                style:
                    widget.textStyle ??
                    TextStyle(
                      fontSize: widget.fontSize ?? 16,
                      color: widget.titleColor ?? defaultTextColor,
                      fontWeight: widget.fontWeight ?? FontWeight.w500,
                    ),
              );

    return Container(
      margin: widget.margin ?? EdgeInsets.zero,
      width: widget.width ?? double.infinity,
      height: widget.height ?? 52,
      child: ElevatedButton(
        onPressed: () async {
          if (finalOnPressed == null) return;

          FocusScope.of(context).unfocus();

          final futureOr = widget.onPressed!();

          if (futureOr is Future) {
            _setFutureBusy(true);
            await futureOr.whenComplete(() => _setFutureBusy(false));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: widget.foregroundColor ?? MyColors.white,
          minimumSize: Size(widget.width ?? 0, widget.height ?? 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
            side: BorderSide(
              color: widget.borderColor ?? Colors.transparent,
              width: widget.borderWidth ?? 0.0,
            ),
          ),
          padding: widget.padding ?? EdgeInsets.zero,
          disabledBackgroundColor: buttonColor,
          disabledForegroundColor: widget.titleColor ?? defaultTextColor,
        ),
        child: finalChild,
      ),
    );
  }
}
