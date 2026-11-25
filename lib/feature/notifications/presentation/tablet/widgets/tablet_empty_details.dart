import 'package:flutter/material.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_text.dart';

class TabletEmptyDetail extends StatelessWidget {
  const TabletEmptyDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryGradient.colors.first.withValues(alpha: 0.04),
            Colors.transparent,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: MyColors.primaryColor.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: 140,
                color: MyColors.primaryColor.withValues(alpha: 0.4),
              ),
            ),
            24.ph,
            MainText(
              context.l10n.no_notifications_tablet,
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: MyColors.grey4,
            ),
            8.ph,
            MainText(
              context.l10n.no_notifications_message_tablet,
              fontSize: 22,
              color: MyColors.grey4.withValues(alpha: 0.8),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
