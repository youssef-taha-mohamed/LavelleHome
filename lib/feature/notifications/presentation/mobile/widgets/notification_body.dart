import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/entities/parameter/notification_details_arg.dart';
import '../../../domain/entities/parameter/parameter.dart';
import '../../../domain/enum/type.dart';
import '../../cubits/notification_cubit/notifications_cubit.dart';
import '../notification_details.dart';
import '../../view/widgets/confirm_delete_dialog.dart';
import '../../view/widgets/empty_notifications.dart';
import 'notification_card.dart';

class NotificationsMobileBody extends StatelessWidget {
  const NotificationsMobileBody({
    super.key,
    required this.state,
    required this.notificationsCubit,
    required this.childId,
    this.selectedNotification,
    this.onNotificationSelected,
  });

  final NotificationsState state;
  final NotificationsCubit notificationsCubit;
  final String? childId;
  final NotificationModel? selectedNotification;
  final ValueChanged<NotificationModel>? onNotificationSelected;

  @override
  Widget build(BuildContext context) {
    if (state.status == NotificationStatus.loading &&
        state.notifications == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: CircularProgressIndicator(color: MyColors.primaryColor),
        ),
      );
    }
    if (state.notifications == null &&
        state.status != NotificationStatus.loading) {
      return const EmptyNotifications();
    }

    final notifications = state.notifications?.notifications ?? [];

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: MyColors.grey4.withValues(alpha: 0.5),
            ),
            MainText(
              state.selectedType == NotificationType.unRead
                  ? context.l10n.no_unread_notifications
                  : context.l10n.no_notifications,
              fontSize: 16,
              color: MyColors.grey4,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => notificationsCubit.getNotifications(refresh: true),
      color: MyColors.primaryColor,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if (!state.hasReachedMax &&
                state.status != NotificationStatus.loadingMore) {
              notificationsCubit.loadMoreNotifications();
            }
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: state.status == NotificationStatus.loadingMore
              ? notifications.length + 1
              : notifications.length,
          itemBuilder: (context, index) {
            if (index >= notifications.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: MyColors.primaryColor,
                    ),
                  ),
                ),
              );
            }

            final item = notifications[index];

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 400 + ((index % 10) * 100)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: NotificationCard(
                      notification: item,
                      onTap: () async {
                        final result = await Navigator.of(context).pushNamed(
                          NotificationDetailsScreen.routeName,
                          arguments: NotificationDetailsScreenArguments(
                            notification: item,
                            childId: childId,
                          ),
                        );
                        if (result == true) {
                          notificationsCubit.getNotifications(refresh: true);
                        }
                      },
                      onConfirmDelete: () async {
                        HapticFeedback.lightImpact();
                        final bool? isConfirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => DeleteConfirmationNotification(
                            description:
                                context.l10n.confirm_delete_notification,
                            onConfirm: () {
                              notificationsCubit.delete(
                                parameter: NotificationParameter(
                                  notificationId: item.notificationId,
                                ),
                              );
                            },
                          ),
                        );
                        return isConfirmed ?? false;
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
