import 'package:flutter/material.dart';
import '../../../../../../core/extension/extension_helper.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../../l10n/l10n.dart';
import '../../../../../../shared/widgets/main_text.dart';

class LoadingCart extends StatelessWidget {
  const LoadingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.isDark ? MyColors.darkItemBG5 :MyColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
                strokeWidth: 3,
              ),
            ),
            MainText(
              context.l10n.loading_cart,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.isDark ? MyColors.white :MyColors.textDark,
            ),
          ],
        ),
      ),
    );
  }
}
