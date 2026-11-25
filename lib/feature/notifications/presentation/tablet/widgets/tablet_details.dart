import 'package:flutter/material.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/entities/parameter/notification_details_arg.dart';
import '../../mobile/notification_details.dart';

class TabletDetailPane extends StatelessWidget {
  const TabletDetailPane({
    super.key,
    required this.notification,
    required this.childId,
    required this.onClose,
  });

  final NotificationModel notification;
  final String? childId;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Column(
      children: [
        // Detail top-bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            gradient: theme.primaryGradient,
            border: Border(
              left: BorderSide(
                color: MyColors.primaryColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: MainText.bigText(
                  notification.cleanTitle,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MyColors.grey4.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.close_rounded,
                      color: MyColors.grey4, size: 20),
                ),
              ),
            ],
          ),
        ),
        // Embed the full details screen
        Expanded(
          child: NotificationDetailsScreen(
            parameter: NotificationDetailsScreenArguments(
              notification: notification,
              childId: childId,
              isTablet: true,
            ),
          ),
        ),
      ],
    );
  }
}
