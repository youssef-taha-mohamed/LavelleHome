import 'package:flutter/material.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../core/utils/format_data.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../domain/entities/notification.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onConfirmDelete,
  });

  final NotificationModel notification;
  final VoidCallback onTap;
  final Future<bool> Function() onConfirmDelete;

  @override
  Widget build(BuildContext context) {
    final typeColor = notification.targetType.color;
    final isRead = notification.isRead;
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return GestureDetector(
      onTap: onTap,
      child: Dismissible(
        key: Key(notification.notificationId.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: MyColors.customRed,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.delete_rounded,
            color: MyColors.white,
            size: 28,
          ),
        ),
        confirmDismiss: (direction) async {
          return await onConfirmDelete();
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: theme.primaryGradient,
            borderRadius: BorderRadius.circular(8),
            border: theme.primaryBorder,
            boxShadow: theme.mediumShadow,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: typeColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    notification.targetType.icon,
                    color: typeColor,
                    size: 24,
                  ),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MainText(
                              notification.title,
                              fontSize: 14,
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: typeColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: typeColor.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      6.ph,
                      MainText(
                        notification.body,
                        fontSize: 14,
                        color: MyColors.grey4,
                        maxLines: 2,
                      ),
                      8.ph,
                      Row(
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: MyColors.grey4,
                          ),
                          MainText(
                            DateFormatter.formatTimeAgo(
                                notification.createdAt, context),
                            fontSize: 12,
                            color: MyColors.grey4,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
