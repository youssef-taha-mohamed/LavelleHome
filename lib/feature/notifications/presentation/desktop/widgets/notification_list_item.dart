import 'package:flutter/material.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/utils/format_data.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../domain/entities/notification.dart';

class NotificationWebCard extends StatefulWidget {
  final NotificationModel notification;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationWebCard({
    super.key,
    required this.notification,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<NotificationWebCard> createState() => _NotificationWebCardState();
}

class _NotificationWebCardState extends State<NotificationWebCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isUnread = widget.notification.isRead == false;
    final isSelected = widget.isSelected;

    // Background color: avoids pure white in dark mode at all costs.
    final Color backgroundColor;
    if (isSelected) {
      backgroundColor =
          isDark
              ? MyColors.primaryColor.withValues(
                alpha: _isHovered ? 0.22 : 0.16,
              )
              : MyColors.primaryColor.withValues(
                alpha: _isHovered ? 0.12 : 0.08,
              );
    } else if (isUnread) {
      backgroundColor =
          isDark
              ? (_isHovered ? MyColors.darkItemBG3 : MyColors.darkItemBG4)
              : Colors.white;
    } else {
      backgroundColor =
          isDark
              ? (_isHovered
                  ? MyColors.darkItemBG4.withValues(alpha: 0.7)
                  : MyColors.darkItemBG4.withValues(alpha: 0.35))
              : (_isHovered
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.6));
    }

    // Border color & styling
    final Border border;
    if (isSelected) {
      border = Border.all(color: MyColors.primaryColor, width: 1.5);
    } else if (isUnread) {
      border = Border.all(
        color:
            isDark
                ? MyColors.primaryColor.withValues(
                  alpha: _isHovered ? 0.45 : 0.25,
                )
                : MyColors.primaryColor.withValues(
                  alpha: _isHovered ? 0.35 : 0.18,
                ),
        width: 1,
      );
    } else {
      border = Border.all(
        color:
            isDark
                ? Colors.white.withValues(alpha: _isHovered ? 0.12 : 0.06)
                : (_isHovered
                    ? Colors.grey.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.15)),
        width: 1,
      );
    }

    // Shadow
    final List<BoxShadow> boxShadow;
    if (isSelected) {
      boxShadow = [
        BoxShadow(
          color:
              isDark
                  ? Colors.black.withValues(alpha: 0.35)
                  : MyColors.primaryColor.withValues(alpha: 0.12),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];
    } else if (isUnread) {
      boxShadow = [
        BoxShadow(
          color:
              isDark
                  ? Colors.black.withValues(alpha: _isHovered ? 0.3 : 0.18)
                  : Colors.black.withValues(alpha: _isHovered ? 0.06 : 0.03),
          blurRadius: _isHovered ? 12 : 8,
          offset: const Offset(0, 2),
        ),
      ];
    } else if (_isHovered) {
      boxShadow = [
        BoxShadow(
          color:
              isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    } else {
      boxShadow = [];
    }

    // Text colors - carefully matched for high readability and zero washed-out tones
    final Color timeColor;
    if (isSelected) {
      timeColor =
          isDark ? MyColors.primaryColor.shade200 : MyColors.primaryColor;
    } else {
      timeColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    }

    final Color titleColor;
    if (isSelected) {
      titleColor = isDark ? Colors.white : MyColors.primaryColor.shade900;
    } else if (isUnread) {
      titleColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    } else {
      titleColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    }

    final Color bodyColor;
    if (isSelected) {
      bodyColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155);
    } else if (isUnread) {
      bodyColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
    } else {
      bodyColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: border,
            boxShadow: boxShadow,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Unread dot + Time + Delete button & Selection Arrow
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsetsDirectional.only(end: 8),
                            decoration: BoxDecoration(
                              color: MyColors.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: MyColors.primaryColor.withValues(
                                    alpha: 0.6,
                                  ),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        MainText(
                          DateFormatter.formatTimeAgo(
                            widget.notification.createdAt,
                            context,
                          ),
                          fontSize: 11.5,
                          color: timeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Quick Delete Icon Button
                        InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: widget.onDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.close_rounded,
                              size: 15,
                              color:
                                  isDark
                                      ? const Color(0xFF94A3B8)
                                      : Colors.grey[500],
                            ),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 4),
                          Icon(
                            context.isArabic
                                ? Icons.arrow_back_ios_new_rounded
                                : Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: MyColors.primaryColor,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Title
                MainText(
                  widget.notification.title,
                  fontSize: 14.5,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                  color: titleColor,
                ),
                const SizedBox(height: 5),
                // Body
                MainText(
                  widget.notification.body,
                  fontSize: 13,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  color: bodyColor,
                  height: 1.35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
