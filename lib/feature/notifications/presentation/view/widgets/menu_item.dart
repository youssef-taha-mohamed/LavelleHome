import 'package:flutter/material.dart';
import '../../../../../core/authentication/provider.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../domain/entities/parameter/parameter.dart';
import '../../cubits/notification_cubit/notifications_cubit.dart';
import 'confirm_delete_dialog.dart';

class OverflowMenuButton extends StatelessWidget {
  const OverflowMenuButton({
    super.key,
    required this.state,
    required this.notificationsCubit,
  });

  final NotificationsState state;
  final NotificationsCubit notificationsCubit;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MyColors.grey4.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.more_vert_rounded, color: MyColors.grey4, size: 22),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (value) {
        if (value == 'mark_all_read') {
          notificationsCubit.readAll(
            parameter: NotificationParameter(
              childId:
                  AuthenticationProvider.instance.currentUser?.details.id ?? "",
            ),
          );
        } else if (value == 'delete_all') {
          showDialog(
            context: context,
            builder: (ctx) => DeleteConfirmationNotification(
              title: context.l10n.delete_all,
              description: context.l10n.confirm_delete_all_notifications,
              onConfirm: () {
                notificationsCubit.clear(
                  parameter: NotificationParameter(
                    childId: AuthenticationProvider
                            .instance.currentUser?.details.id ??
                        "",
                  ),
                );
              },
            ),
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'mark_all_read',
          child: Row(
            spacing: 12,
            children: [
              Icon(Icons.done_all_rounded,
                  color: MyColors.primaryColor, size: 20),
              MainText(
                context.l10n.mark_all_as_read,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete_all',
          child: Row(
            spacing: 12,
            children: [
              Icon(Icons.delete_outline_rounded,
                  color: MyColors.customRed, size: 20),
              MainText(
                context.l10n.delete_all_notifications,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
