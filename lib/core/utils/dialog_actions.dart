// lib/core/widgets/custom_dialog/dialog_actions.dart
import 'package:flutter/material.dart';

class DialogAction {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;
  final Color? color;

  const DialogAction({
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
    this.icon,
    this.color,
  });
}

class DialogActionsBuilder {
  static List<DialogAction> confirmDelete({
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'حذف',
    String cancelText = 'إلغاء',
  }) {
    return [
      DialogAction(
        text: cancelText,
        onPressed: onCancel ?? () {},
        isPrimary: false,
        icon: Icons.close_rounded,
      ),
      DialogAction(
        text: confirmText,
        onPressed: onConfirm,
        isPrimary: true,
        icon: Icons.delete_rounded,
        color: Colors.red,
      ),
    ];
  }

  static List<DialogAction> confirmAction({
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    IconData? confirmIcon,
  }) {
    return [
      DialogAction(
        text: cancelText,
        onPressed: onCancel ?? () {},
        isPrimary: false,
        icon: Icons.close_rounded,
      ),
      DialogAction(
        text: confirmText,
        onPressed: onConfirm,
        isPrimary: true,
        icon: confirmIcon ?? Icons.check_rounded,
      ),
    ];
  }

  static List<DialogAction> threeOptions({
    required VoidCallback onOption1,
    required VoidCallback onOption2,
    required VoidCallback onCancel,
    String option1Text = 'خيار 1',
    String option2Text = 'خيار 2',
    String cancelText = 'إلغاء',
  }) {
    return [
      DialogAction(
        text: cancelText,
        onPressed: onCancel,
        isPrimary: false,
        icon: Icons.close_rounded,
      ),
      DialogAction(
        text: option1Text,
        onPressed: onOption1,
        isPrimary: false,
      ),
      DialogAction(
        text: option2Text,
        onPressed: onOption2,
        isPrimary: true,
      ),
    ];
  }
}
