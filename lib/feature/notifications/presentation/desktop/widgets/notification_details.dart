import '../../../../../core/utils/format_data.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/enum/target_type.dart';

class NotificationWebDetailPane extends StatelessWidget {
  final NotificationModel? notification;
  final VoidCallback? onDelete;

  const NotificationWebDetailPane({
    super.key,
    required this.notification,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    if (notification == null) {
      return Container(
        decoration: BoxDecoration(
          color: isDark ? MyColors.darkItemBG4 : MyColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: isDark
                ? MyColors.white.withValues(alpha: 0.05)
                : MyColors.greyBorder.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : MyColors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isDark
                      ? MyColors.primaryColor.withValues(alpha: 0.1)
                      : MyColors.primaryColor.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 44,
                  color: isDark
                      ? MyColors.primaryColor.withValues(alpha: 0.5)
                      : MyColors.primaryColor.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 20),
              MainText(
                context.l10n.select_notification_to_view_details,
                fontSize: 16,
                color: isDark ? MyColors.grey400 : MyColors.grey600,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      );
    }

    final item = notification!;
    final Color typeColor = item.targetType.color;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(item.notificationId),
        decoration: BoxDecoration(
          color: isDark ? MyColors.darkItemBG4 : MyColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          border: Border.all(
            color: isDark
                ? MyColors.white.withValues(alpha: 0.06)
                : MyColors.greyBorder.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : MyColors.black.withValues(alpha: 0.04),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Pane Header & Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header meta row: Time info + Delete action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 15,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 8),
                            MainText(
                              DateFormatter.formatTimeAgo(
                                item.createdAt,
                                context,
                              ),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ],
                        ),
                        if (onDelete != null)
                          Tooltip(
                            message: context.l10n.delete_all,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: onDelete,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.customRed.withValues(
                                    alpha: isDark ? 0.14 : 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: MyColors.customRed.withValues(
                                      alpha: isDark ? 0.25 : 0.15,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  spacing: 6,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.delete_outline_rounded,
                                      color: MyColors.customRed,
                                      size: 16,
                                    ),
                                    MainText(
                                      context.l10n.delete,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.customRed,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Title
                    MainText(
                      item.title,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? MyColors.white : MyColors.black,
                      height: 1.35,
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      height: 1,
                      color: isDark
                          ? MyColors.white.withValues(alpha: 0.08)
                          : MyColors.greyBorder.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 20),
                    // Body message container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? MyColors.darkItemBG2 : MyColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? MyColors.white.withValues(alpha: 0.05)
                              : MyColors.greyBorder.withValues(alpha: 0.35),
                        ),
                      ),
                      child: MainText(
                        item.body,
                        fontSize: 14.5,
                        height: 1.7,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF334155),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pane Footer Action Button
            if (item.target != null && item.target!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: isDark ? MyColors.darkItemBG4 : MyColors.cardBg,
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? MyColors.white.withValues(alpha: 0.06)
                          : MyColors.greyBorder.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                child: MainButton(
                  title: item.targetType.getButtonTitle(context),
                  backgroundColor: typeColor,
                  height: 50,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  borderRadius: 12,
                  onPressed: () => _handleAction(context, item),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, NotificationModel item) async {
    final id = item.target;
    if (id == null || id.isEmpty) return;

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
  }
}
