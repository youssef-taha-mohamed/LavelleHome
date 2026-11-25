import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../domain/enum/type.dart';
import '../../cubits/notification_cubit/notifications_cubit.dart';
import '../../provider/provider_count.dart';
import '../../view/widgets/menu_item.dart';

class TabletFilterChips extends StatelessWidget {
  const TabletFilterChips({
    super.key,
    required this.state,
    required this.notificationsCubit,
  });

  final NotificationsState state;
  final NotificationsCubit notificationsCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          _Chip(
            label: context.l10n
                .all_notifications(state.notifications?.totalCount ?? 0),
            isSelected: state.selectedType == NotificationType.all,
            onTap: () => notificationsCubit.changeFilter(NotificationType.all),
          ),
          8.pw,
          _Chip(
            label: StreamBuilder<int>(
              stream: NotificationsProvider.instance.notificationsCount,
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                final data = count > 99 ? '+99' : count.toString();
                return Text(
                    context.l10n.unread_notifications(count == 0 ? 0 : data));
              },
            ),
            isSelected: state.selectedType == NotificationType.unRead,
            onTap: () =>
                notificationsCubit.changeFilter(NotificationType.unRead),
          ),
          const Spacer(),
          OverflowMenuButton(
            state: state,
            notificationsCubit: notificationsCubit,
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final dynamic label; // String or Widget
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [MyColors.primaryColor, MyColors.lightTeal])
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : MyColors.grey4.withValues(alpha: 0.3),
          ),
        ),
        child: label is String
            ? MainText(
                label as String,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? MyColors.white : MyColors.grey4,
              )
            : DefaultTextStyle(
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? MyColors.white : MyColors.grey4,
                ),
                child: label as Widget,
              ),
      ),
    );
  }
}
