import 'package:flutter/material.dart';
import '../../core/extension/extension_helper.dart';
import '../../core/style/app_colors.dart';
import '../../l10n/l10n.dart';
import 'main_button.dart';
import 'main_text.dart';

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({
    super.key,
  });

  static Future<bool?> show(
    BuildContext context,
  ) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LogoutBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: context.isDark ? MyColors.darkItemBG2 : MyColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          16.ph,
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: MyColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          24.ph,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MyColors.appRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: MyColors.white,
              size: 32,
            ),
          ),
          16.ph,
          MainText(
            context.l10n.logout,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          8.ph,
          MainText(
            context.l10n.are_you_sure_you_want_to_logout,
            fontSize: 16,
            color: Colors.grey[600],
          ),
          24.ph,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 16,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: MainText(
                      context.l10n.cancel,
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: MainButton(
                    onPressed: () async {
                      Navigator.pop(context, true);
                    },
                    backgroundColor: MyColors.appRed,
                    title: context.l10n.logout,
                  ),
                ),
              ],
            ),
          ),
          16.ph,
        ],
      ),
    );
  }
}
