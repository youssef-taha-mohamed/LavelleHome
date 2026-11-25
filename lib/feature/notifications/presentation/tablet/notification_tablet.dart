import 'package:flutter/material.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/custom_tablet_appbar.dart';
import '../../domain/entities/notification.dart';
import '../../domain/entities/parameter/parameter.dart';
import '../cubits/notification_cubit/notifications_cubit.dart';
import 'widgets/notification_body.dart';
import 'widgets/tablet_details.dart';
import 'widgets/tablet_empty_details.dart';
import 'widgets/tablet_filter.dart';

class TabletNotificationsLayout extends StatefulWidget {
  const TabletNotificationsLayout({
    super.key,
    required this.state,
    required this.notificationsCubit,
    required this.childId,
  });

  final NotificationsState state;
  final NotificationsCubit notificationsCubit;
  final String? childId;

  @override
  State<TabletNotificationsLayout> createState() =>
      _TabletNotificationsLayoutState();
}

class _TabletNotificationsLayoutState extends State<TabletNotificationsLayout> {
  NotificationModel? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    final state = widget.state;
    final notificationsCubit = widget.notificationsCubit;

    return Column(
      children: [
        CustomTabletStudentHeader(
          title: context.l10n.notifications_title_tablet,
          subTitle: context.l10n.all_notifications(
            state.notifications?.totalCount ?? 0,
          ),
          showNotification: false,
          showLeading: true,
          showBack: true,
        ),
        Expanded(
          child: Row(
            children: [
              // ── SIDEBAR (MASTER) ─────────────────────────────────
              Container(
                width: 450,
                decoration: BoxDecoration(
                  color: theme.primaryGradient.colors.first
                      .withValues(alpha: 0.02),
                  border: Border(
                    right: BorderSide(
                      color: MyColors.primaryColor.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    TabletFilterChips(
                      state: state,
                      notificationsCubit: notificationsCubit,
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: NotificationsTabletBody(
                        state: state,
                        notificationsCubit: notificationsCubit,
                        childId: widget.childId,
                        selectedNotification: _selected,
                        onNotificationSelected: (n) {
                          setState(() => _selected = n);
                          notificationsCubit.readNotification(
                            parameter: NotificationParameter(
                              notificationId: n.notificationId,
                              childId: widget.childId,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // ── DETAIL PANE ──────────────────────────────────────
              Expanded(
                child: _selected != null
                    ? TabletDetailPane(
                        key: ValueKey(_selected!.notificationId),
                        notification: _selected!,
                        childId: widget.childId,
                        onClose: () => setState(() => _selected = null),
                      )
                    : TabletEmptyDetail(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
