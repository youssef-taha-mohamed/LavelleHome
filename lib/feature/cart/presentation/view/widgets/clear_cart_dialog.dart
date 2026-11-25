import 'package:flutter/material.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../provider/provider.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.confirmText,
    required this.planIds,
    this.confirmColor,
  });

  final String title;
  final String content;
  final IconData icon;
  final String confirmText;
  final List<num> planIds;
  final Color? confirmColor;

  @override
  Widget build(BuildContext context) {
    final color = confirmColor ?? MyColors.customRed;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Row(
        spacing: 12,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          Expanded(
            child: MainText(
              title,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: MainText(
        content,
        fontSize: 16,
        color: MyColors.grey4,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: MainText(
            context.l10n.cancel,
            color: MyColors.grey4,
            fontWeight: FontWeight.w600,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            CartProvider.instance.delete(planIds: planIds);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: MainText(
            confirmText,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
