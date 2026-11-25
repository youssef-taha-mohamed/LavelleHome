import 'package:flutter/material.dart';
import '../cubits/notification_cubit/notifications_cubit.dart';
import 'widgets/notification_body.dart';
import 'widgets/phone_filter.dart';
import 'widgets/phone_header.dart';

class PhoneNotificationsLayout extends StatelessWidget {
  const PhoneNotificationsLayout({
    super.key,
    required this.state,
    required this.notificationsCubit,
    required this.childId,
  });

  final NotificationsState state;
  final NotificationsCubit notificationsCubit;
  final String? childId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PhoneHeader(state: state, notificationsCubit: notificationsCubit),
        PhoneFilterTabs(state: state, notificationsCubit: notificationsCubit),
        Expanded(
          child: NotificationsMobileBody(
            state: state,
            notificationsCubit: notificationsCubit,
            childId: childId,
          ),
        ),
      ],
    );
  }
}
