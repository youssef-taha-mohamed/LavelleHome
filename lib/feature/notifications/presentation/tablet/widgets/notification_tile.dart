import 'package:flutter/material.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/utils/format_data.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../domain/entities/notification.dart';

class TabletNotificationTile extends StatelessWidget {
  const TabletNotificationTile({
    super.key,
    required this.notification,
    required this.isSelected,
    required this.onTap,
    required this.onConfirmDelete,
  });

  final NotificationModel notification;
  final bool isSelected;
  final VoidCallback onTap;
  final Future<bool> Function() onConfirmDelete;

  @override
  Widget build(BuildContext context) {
    final typeColor = notification.targetType.color;

    return Dismissible(
      key: Key('tablet-${notification.notificationId}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: MyColors.customRed,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 22),
      ),
      confirmDismiss: (_) => onConfirmDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? MyColors.primaryColor.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(
                    color: MyColors.primaryColor.withValues(alpha: 0.3),
                    width: 1.5,
                  )
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon badge
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: typeColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Icon(notification.targetType.icon, color: typeColor, size: 18),
              ),
              10.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: MainText(
                            notification.cleanTitle,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            maxLines: 1,
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: typeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    4.ph,
                    MainText(
                      notification.body,
                      fontSize: 16,
                      color: MyColors.grey4,
                      maxLines: 2,
                    ),
                    6.ph,
                    Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 16, color: MyColors.grey4),
                        MainText(
                          DateFormatter.formatTimeAgo(
                              notification.createdAt, context),
                          fontSize: 14,
                          color: MyColors.grey4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: MyColors.primaryColor,
                    size: 32,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
