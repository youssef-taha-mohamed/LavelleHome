import 'package:flutter/material.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../cubits/notification_cubit/notifications_cubit.dart';

class NotificationHeader extends StatelessWidget {
  final NotificationsCubit notificationsCubit;
  final VoidCallback onDeleteAll;
  final VoidCallback onMarkAllAsRead;
  const NotificationHeader({
    super.key,
    required this.notificationsCubit,
    required this.onDeleteAll,
    required this.onMarkAllAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainText(
              context.l10n.notifications_title,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: MyColors.primaryColor,
            ),
            MainText(
              context.l10n.notifications_subtitle,
              fontSize: 16,
              color: Colors.grey,
            ),
          ],
        ),
        Row(
          spacing: 12,
          children: [
            _buildHeaderButton(
              context,
              icon: Icons.done_all_rounded,
              label: context.l10n.mark_all_as_read,
              onPressed: onMarkAllAsRead,
              color: MyColors.primaryColor,
            ),
            _buildHeaderButton(
              context,
              icon: Icons.delete_sweep_outlined,
              label: context.l10n.delete_all,
              onPressed: onDeleteAll,
              color: MyColors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: color.withValues(alpha: 0.05),
      ),
      icon: Icon(icon, size: 20, color: color),
      label: MainText(
        label,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
