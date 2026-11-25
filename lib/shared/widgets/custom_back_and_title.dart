import 'package:flutter/material.dart';
import '../../core/extension/extension_helper.dart';
import '../../core/style/app_colors.dart';
import 'custom_back.dart';
import 'main_text.dart';

class CustomBackAndTitle extends StatelessWidget {
  const CustomBackAndTitle({super.key, this.title, this.onPressed});

  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyBackButton(onPressed: onPressed),
        const Spacer(),
        if (title != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: MainText(
              title!,
              color: MyColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          ),
        const Spacer(),
        46.pw,
      ],
    );
  }
}
