import 'package:flutter/material.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../domain/enum/type.dart';
import '../../provider/provider_count.dart';

class NotificationFilterChip extends StatelessWidget {
  final String label;
  final NotificationType type;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isUnread;

  const NotificationFilterChip({
    super.key,
    this.label = '',
    required this.type,
    required this.isSelected,
    required this.onTap,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final Color backgroundColor;
    final Color textColor;
    final Border border;
    final List<BoxShadow> boxShadow;

    if (isSelected) {
      backgroundColor = MyColors.primaryColor;
      textColor = MyColors.white;
      border = Border.all(color: MyColors.primaryColor);
      boxShadow = [
        BoxShadow(
          color: MyColors.primaryColor.withValues(alpha: isDark ? 0.35 : 0.25),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    } else {
      backgroundColor = isDark ? MyColors.darkItemBG4 : MyColors.white;
      textColor = isDark ? MyColors.grey400 : MyColors.darkPrimary;
      border = Border.all(
        color: isDark
            ? MyColors.white.withValues(alpha: 0.08)
            : MyColors.primaryColor.withValues(alpha: 0.15),
      );
      boxShadow = [
        BoxShadow(
          color: isDark
              ? MyColors.black.withValues(alpha: 0.2)
              : MyColors.primaryColor.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];
    }

    Widget buildLabel() {
      if (isUnread) {
        return StreamBuilder<int>(
          stream: NotificationsProvider.instance.notificationsCount,
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            final data = count > 99 ? '+99' : count.toString();
            return MainText(
              context.l10n.unread_notifications(data),
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            );
          },
        );
      }
      return MainText(
        label,
        color: textColor,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(100),
            border: border,
            boxShadow: boxShadow,
          ),
          child: buildLabel(),
        ),
      ),
    );
  }
}
