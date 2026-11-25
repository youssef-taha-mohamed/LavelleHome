import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/extension/extension_helper.dart';
import '../../core/resources/svg.dart';
import '../../core/style/app_colors.dart';

class RedoBack extends StatelessWidget {
  const RedoBack({
    super.key,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
  });

  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Transform.rotate(
          angle: context.isArabic ? 135 : 0,
          child: SvgPicture.asset(
            SvgAssets.redo,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              context.isDark ? MyColors.white : MyColors.black,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
