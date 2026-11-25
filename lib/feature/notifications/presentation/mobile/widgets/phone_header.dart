import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../cubits/notification_cubit/notifications_cubit.dart';
import '../../view/widgets/menu_item.dart';

class PhoneHeader extends StatelessWidget {
  const PhoneHeader({
    super.key,
    required this.state,
    required this.notificationsCubit,
  });

  final NotificationsState state;
  final NotificationsCubit notificationsCubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        boxShadow: theme.mediumShadow,
      ),
      child: Row(
        children: [
          if (defaultTargetPlatform == TargetPlatform.iOS)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    color: MyColors.primaryColor, size: 20),
              ),
            ),
          16.pw,
          Expanded(
            child: MainText.bigText(
              context.l10n.notifications_title,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (state.notifications?.notifications.isNotEmpty ?? false)
            OverflowMenuButton(
              state: state,
              notificationsCubit: notificationsCubit,
            ),
        ],
      ),
    );
  }
}
