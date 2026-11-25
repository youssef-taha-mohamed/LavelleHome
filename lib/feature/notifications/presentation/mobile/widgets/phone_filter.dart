import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../domain/enum/type.dart';
import '../../cubits/notification_cubit/notifications_cubit.dart';
import '../../provider/provider_count.dart';

class PhoneFilterTabs extends StatelessWidget {
  const PhoneFilterTabs({
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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(8),
        border: theme.primaryBorder,
        boxShadow: theme.mediumShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterTab(
              context: context,
              label: MainText(
                context.l10n
                    .all_notifications(state.notifications?.totalCount ?? 0),
                fontSize: 14,
                fontWeight: state.selectedType == NotificationType.all
                    ? FontWeight.bold
                    : FontWeight.w600,
                color: state.selectedType == NotificationType.all
                    ? Colors.white
                    : MyColors.grey4,
              ),
              isSelected: state.selectedType == NotificationType.all,
              onTap: () =>
                  notificationsCubit.changeFilter(NotificationType.all),
            ),
          ),
          Expanded(
            child: _buildFilterTab(
              context: context,
              label: StreamBuilder<int>(
                stream: NotificationsProvider.instance.notificationsCount,
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  final data = count > 99 ? '+99' : count.toString();
                  return MainText(
                    context.l10n.unread_notifications(count == 0 ? 0 : data),
                    fontSize: 14,
                    fontWeight: state.selectedType == NotificationType.unRead
                        ? FontWeight.bold
                        : FontWeight.w600,
                    color: state.selectedType == NotificationType.unRead
                        ? Colors.white
                        : MyColors.grey4,
                  );
                },
              ),
              isSelected: state.selectedType == NotificationType.unRead,
              onTap: () =>
                  notificationsCubit.changeFilter(NotificationType.unRead),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required BuildContext context,
    required Widget label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [MyColors.primaryColor, MyColors.lightTeal])
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: label),
      ),
    );
  }
}
