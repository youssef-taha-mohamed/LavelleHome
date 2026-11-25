import '../../../../core/authentication/provider.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../core/utils/format_data.dart';
import '../../../../core/utils/utilities.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../user/domain/entities/user.dart';
import '../../domain/entities/parameter/notification_details_arg.dart';
import '../../domain/entities/parameter/parameter.dart';
import '../../domain/enum/target_type.dart';
import '../cubits/read_notification/read_notification_cubit.dart';

class NotificationDetailsScreen extends StatefulWidget {
  const NotificationDetailsScreen({super.key, required this.parameter});

  final NotificationDetailsScreenArguments parameter;

  static const String routeName = '/notification_details';

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  late ReadNotificationCubit notificationsCubit;

  @override
  void initState() {
    notificationsCubit = ReadNotificationCubit(
      repo: DependencyInjector.notificationRepo,
    );
    _readNotification();
    super.initState();
  }

  Future<void> _readNotification() async {
    if (!widget.parameter.notification.isRead) {
      await notificationsCubit.readNotification(
        parameter: NotificationParameter(
          notificationId: widget.parameter.notification.notificationId,
          childId:
              widget.parameter.childId ??
              AuthenticationProvider.instance.currentUser?.details.id,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final targetType = widget.parameter.notification.targetType;
    final Color primary = targetType.color;
    final IconData targetIcon = targetType.icon;

    final Color cardBg = isDark ? const Color(0xFF1F2937) : MyColors.white;
    final Color borderColor = isDark
        ? const Color(0xFF374151)
        : const Color(0xFFF3F4F6);

    final List<String> lines = widget.parameter.notification.body.split('\n');
    final String mainMessage = lines.isNotEmpty ? lines.first : '';
    final List<String> details = lines.length > 1 ? lines.sublist(1) : [];

    return BlocProvider.value(
      value: notificationsCubit,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.pop(context, true);
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                if (!widget.parameter.isTablet)
                  StreamBuilder<User?>(
                    stream: AuthenticationProvider.instance.userChanges(),
                    builder: (context, snapshot) {
                      final user = snapshot.data;
                      return CustomStudentHeader(
                        title: context.l10n.notification_details,
                        subTitle: getGreeting(context),
                        onLeadingTap: () {
                          Navigator.pop(context, true);
                        },
                        image: user?.details.image ?? '',
                        showLeading: true,
                      );
                    },
                  ),
                Expanded(
                  child: BlocConsumer<ReadNotificationCubit, ReadNotificationState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state.status == ReadNotificationStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primary.withValues(
                                            alpha: isDark ? 0.1 : 0.2,
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: primary.withValues(
                                                  alpha: 0.2,
                                                ),
                                                blurRadius: 24,
                                                spreadRadius: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDark
                                              ? primary.withValues(alpha: 0.3)
                                              : primary.withValues(alpha: 0.1),
                                          border: Border.all(
                                            color: primary.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                        ),
                                        child: Icon(
                                          targetIcon,
                                          size: 48,
                                          color: primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24),
                                  MainText(
                                    MediaQuery.of(context).size.width >= 600
                                        ? widget
                                              .parameter
                                              .notification
                                              .cleanTitle
                                        : widget.parameter.notification.title,
                                    textAlign: TextAlign.center,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                    height: 1.2,
                                  ),
                                  SizedBox(height: 8),
                                  MainText(
                                    DateFormatter.formatTimeAgo(
                                      widget.parameter.notification.createdAt,
                                      context,
                                    ),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: primary.withValues(alpha: 0.5),
                                  ),
                                  SizedBox(height: 32),
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: borderColor),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: MainText(
                                            mainMessage,
                                            fontSize: 16,
                                            height: 1.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (details.isNotEmpty)
                                          Container(
                                            width: double.infinity,
                                            color: isDark
                                                ? primary.withValues(alpha: 0.1)
                                                : primary.withValues(
                                                    alpha: 0.05,
                                                  ),
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              spacing: 12,
                                              children: details.map((line) {
                                                return Row(
                                                  spacing: 12,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            top: 6,
                                                          ),
                                                      width: 6,
                                                      height:
                                                          widget
                                                              .parameter
                                                              .isTablet
                                                          ? 12
                                                          : 6,
                                                      decoration: BoxDecoration(
                                                        color: primary
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: MainText(
                                                        line,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.4,
                                                        color: isDark
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF111827,
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                AuthenticationProvider.instance.currentUser?.details.role ==
                        UserRole.parent
                    ? SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: MainButton(
                          fontSize: 14,
                          height: 48,
                          width: widget.parameter.isTablet ? 350 : 264,
                          onPressed: () async {
                            final item = widget.parameter.notification;

                            if (!item.isRead) {
                              notificationsCubit.readNotification(
                                parameter: NotificationParameter(
                                  notificationId: item.notificationId,
                                  childId:
                                      widget.parameter.childId ??
                                      AuthenticationProvider
                                          .instance
                                          .currentUser
                                          ?.details
                                          .id,
                                ),
                              );
                            }
                            final id = item.target;
                            if (id == null) {
                              return;
                            }
                            switch (item.targetType) {
                              case TargetType.system:
                              // await Navigator.of(context).pushNamed(
                              //   BlogDetails.routeName,
                              //   arguments: BlogDetailsViewArguments(blogId: id),
                              // );
                              case TargetType.feedBack:
                              // await Navigator.of(context).pushNamed(
                              //   DreamDetails.routeName,
                              //   arguments: DreamDetailsArguments(
                              //     dreamId: id,
                              //   ),
                              // );
                              case TargetType.assignment:
                              case TargetType.subscription:
                              case TargetType.contactUs:
                              // await Navigator.of(context).pushNamed(
                              //   ContactUsView.routeName,
                              // );
                              case TargetType.security:
                              // await Navigator.of(context).pushNamed(
                              //   RepliesScreen.routeName,
                              //   arguments: RepliesBlogViewArguments(
                              //     comment: await FetchBlogComment(
                              //       repository: DependencyInjector
                              //           .blogCommentBaseRepository,
                              //     ).call(
                              //       id: id,
                              //     ),
                              //   ),
                              // );
                              case TargetType.family:
                                return;
                              case TargetType.payment:
                                return;
                              case TargetType.course:
                                return;
                            }
                          },
                          title: targetType.getButtonTitle(context),
                          backgroundColor: primary,
                          borderColor: primary,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
