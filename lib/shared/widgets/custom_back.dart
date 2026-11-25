import 'package:flutter/material.dart';

import '../../core/style/app_colors.dart';

class MyBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final double elevation;
  final IconData? iconData;
  final Color? color;
  final EdgeInsets margin;
  final Border? border;

  const MyBackButton({
    super.key,
    this.onPressed,
    this.size = 40.0,
    this.elevation = 4.0,
    this.iconData,
    this.color,
    this.margin = const EdgeInsets.all(8.0),
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {
        //HapticFeedback.selectionClick();
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyColors.primaryColor,
              MyColors.primaryColor.withValues(alpha: 0.85),
            ],
          ),
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.white.withValues(alpha: 0.25),
          //     Colors.white.withValues(alpha: 0.15),
          //   ],
          // ),
          borderRadius: BorderRadius.circular(14),
          // border: border ??Border.all(
          //   color: Colors.white.withValues(alpha: 0.3),
          //   width: 1,
          // ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.1),
          //     blurRadius: 8,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
