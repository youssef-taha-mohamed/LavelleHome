import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../cubits/notification_cubit/notifications_cubit.dart';
import '../desktop/notifications_web.dart';
import '../mobile/notifications_mobile.dart';
import '../tablet/notification_tablet.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
    this.childId,
  });

  final String? childId;
  static const String routeName = '/notifications';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late NotificationsCubit notificationsCubit;

  @override
  void initState() {
    super.initState();
    notificationsCubit = NotificationsCubit(
      repo: DependencyInjector.notificationRepo,
    );
    notificationsCubit.getNotifications();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: notificationsCubit,
      child: Scaffold(
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  return ModalProgressHUD(
                    inAsyncCall:
                        state.statusReadAll == NotificationStatus.loading ||
                            state.statusClear == NotificationStatus.loading ||
                            state.statusDelete == NotificationStatus.loading,
                    progressIndicator: const CircularProgressIndicator(
                      color: MyColors.primaryColor,
                    ),
                    child: Builder(
                      builder: (context) {
                        final category = AppResponsive.getCategory(context);
                        final isDesktop = category == DeviceCategory.desktop;
                        final isTablet =
                            category == DeviceCategory.smallTablet ||
                                category == DeviceCategory.largeTablet;

                        if (isDesktop) {
                          return NotificationsWeb(
                            state: state,
                            notificationsCubit: notificationsCubit,
                            childId: widget.childId,
                          );
                        }

                        if (isTablet) {
                          return TabletNotificationsLayout(
                            state: state,
                            notificationsCubit: notificationsCubit,
                            childId: widget.childId,
                          );
                        }

                        return PhoneNotificationsLayout(
                          state: state,
                          notificationsCubit: notificationsCubit,
                          childId: widget.childId,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
