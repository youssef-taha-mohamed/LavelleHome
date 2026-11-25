import 'package:flutter/material.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/notification.dart';
import '../../domain/entities/parameter/parameter.dart';
import '../../domain/enum/type.dart';
import '../cubits/notification_cubit/notifications_cubit.dart';
import '../view/widgets/confirm_delete_dialog.dart';
import '../view/widgets/empty_notifications.dart';
import 'widgets/notification_details.dart';
import 'widgets/notification_filter_chip.dart';
import 'widgets/notification_header.dart';
import 'widgets/notification_list_item.dart';

class NotificationsWeb extends StatefulWidget {
  final NotificationsState state;
  final NotificationsCubit notificationsCubit;
  final String? childId;

  const NotificationsWeb({
    super.key,
    required this.state,
    required this.notificationsCubit,
    this.childId,
  });

  @override
  State<NotificationsWeb> createState() => _NotificationsWebState();
}

class _NotificationsWebState extends State<NotificationsWeb> {
  final ScrollController _scrollController = ScrollController();
  NotificationModel? _selectedNotification;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NotificationsWeb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.selectedType != widget.state.selectedType) {
      setState(() {
        _selectedNotification = null;
      });
    } else if (_selectedNotification != null) {
      final updated = widget.state.notifications?.notifications
          .where(
            (n) => n.notificationId == _selectedNotification!.notificationId,
          )
          .firstOrNull;
      if (updated != null && updated != _selectedNotification) {
        setState(() {
          _selectedNotification = updated;
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!widget.state.hasReachedMax &&
          widget.state.status != NotificationStatus.loadingMore) {
        widget.notificationsCubit.loadMoreNotifications(
          childId: widget.childId,
        );
      }
    }
  }

  void _onSelect(NotificationModel notification) {
    setState(() {
      _selectedNotification = notification;
    });

    if (!notification.isRead) {
      widget.notificationsCubit.readNotification(
        parameter: NotificationParameter(
          notificationId: notification.notificationId,
          childId: widget.childId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 32,
        children: [
          NotificationHeader(
            notificationsCubit: widget.notificationsCubit,
            onDeleteAll: () {
              showDialog(
                context: context,
                builder: (context) => DeleteConfirmationNotification(
                  title: context.l10n.delete_all,
                  description: context.l10n.confirm_delete_all_notifications,
                  onConfirm: () => widget.notificationsCubit.clear(
                    parameter: NotificationParameter(childId: widget.childId),
                  ),
                ),
              );
            },
            onMarkAllAsRead: () {
              widget.notificationsCubit.readAll(
                parameter: NotificationParameter(childId: widget.childId),
              );
            },
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 400,
                  child: Column(
                    spacing: 24,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterChips(context),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            if (widget.state.status ==
                                NotificationStatus.loading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: MyColors.primaryColor,
                                ),
                              );
                            }
                            final notifications =
                                widget.state.notifications?.notifications ?? [];
                            if (notifications.isEmpty) {
                              return const EmptyNotifications();
                            }
                            return _buildNotificationsList(
                              context,
                              notifications,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // --- Side B: Detail Pane ---
                Expanded(
                  child: NotificationWebDetailPane(
                    notification: _selectedNotification,
                    onDelete: _selectedNotification == null
                        ? null
                        : () {
                            widget.notificationsCubit.delete(
                              parameter: NotificationParameter(
                                notificationId:
                                    _selectedNotification!.notificationId,
                                childId: widget.childId,
                              ),
                            );
                            setState(() => _selectedNotification = null);
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: [
        NotificationFilterChip(
          label: context.l10n.all_notifications(
            widget.state.notifications?.totalCount ?? 0,
          ),
          type: NotificationType.all,
          isSelected: widget.state.selectedType == NotificationType.all,
          onTap: () {
            if (widget.state.selectedType != NotificationType.all) {
              setState(() {
                _selectedNotification = null;
              });
              widget.notificationsCubit.changeFilter(
                NotificationType.all,
                childId: widget.childId,
              );
            }
          },
        ),
        NotificationFilterChip(
          type: NotificationType.unRead,
          isUnread: true,
          isSelected: widget.state.selectedType == NotificationType.unRead,
          onTap: () {
            if (widget.state.selectedType != NotificationType.unRead) {
              setState(() {
                _selectedNotification = null;
              });
              widget.notificationsCubit.changeFilter(
                NotificationType.unRead,
                childId: widget.childId,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsList(BuildContext context, List notifications) {
    return RefreshIndicator(
      onRefresh: () =>
          widget.notificationsCubit.getNotifications(refresh: true),
      color: MyColors.primaryColor,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 40),
        itemCount: widget.state.status == NotificationStatus.loadingMore
            ? notifications.length + 1
            : notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= notifications.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: CircularProgressIndicator(color: MyColors.primaryColor),
              ),
            );
          }
          final item = notifications[index];
          return NotificationWebCard(
            notification: item,
            isSelected:
                _selectedNotification?.notificationId == item.notificationId,
            onTap: () => _onSelect(item),
            onDelete: () {
              widget.notificationsCubit.delete(
                parameter: NotificationParameter(
                  notificationId: item.notificationId,
                ),
              );
              if (_selectedNotification?.notificationId ==
                  item.notificationId) {
                setState(() => _selectedNotification = null);
              }
            },
          );
        },
      ),
    );
  }
}
