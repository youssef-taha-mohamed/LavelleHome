import 'package:flutter/material.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_text.dart';

class DeleteConfirmationNotification extends StatelessWidget {
  final String description;
  final VoidCallback onConfirm;
  final String title;

  const DeleteConfirmationNotification({
    super.key,
    required this.description,
    required this.onConfirm,
    this.title = 'حذف الإشعار',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MyColors.customRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: MyColors.customRed,
              size: 28,
            ),
          ),
          12.pw,
          Expanded(
            child: MainText(title, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: MainText(description, fontSize: 16, color: MyColors.grey4),
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
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.customRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: MainText(
            context.l10n.delete,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
