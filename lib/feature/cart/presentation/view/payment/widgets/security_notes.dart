import 'package:flutter/material.dart';
import '../../../../../../core/extension/extension_helper.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../../core/utils/app_responsive.dart';
import '../../../../../../l10n/l10n.dart';
import '../../../../../../shared/widgets/main_text.dart';


class SecurityNotes extends StatelessWidget {
  const SecurityNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.isDark ? MyColors.darkItemBG5 : MyColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.security_rounded,
              color: const Color(0xFF10B981),
              size: AppResponsive.getIconSize(context, base: 20),
            ),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                MainText(
                  context.l10n.security_notes,
                  fontSize: AppResponsive.getFontSize(context,
                      mobile: 12, smallTablet: 14, largeTablet: 16),
                  fontWeight: FontWeight.bold,
                  color: context.isDark ? MyColors.white : MyColors.textDark,
                ),
                MainText(
                  context.l10n.security_notes_description,
                  fontSize: AppResponsive.getFontSize(context,
                      mobile: 10, smallTablet: 12, largeTablet: 14),
                  color: context.isDark ? MyColors.grey300 : MyColors.grey4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
