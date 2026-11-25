// lib/core/widgets/custom_dialog/custom_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/style/app_colors.dart';
import '../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../shared/widgets/main_text.dart';
import 'dialog_actions.dart';
import 'dialog_animation.dart';

enum DialogType { success, error, warning, info, question, custom }

class CustomDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    DialogType type = DialogType.info,
    Widget? customIcon,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    VoidCallback? onClose,
    bool showCloseButton = true,
    bool barrierDismissible = true,
    List<DialogAction>? customActions,
    Duration animationDuration = const Duration(milliseconds: 400),
    double? maxWidth,
    double? maxHeight,
    Widget? contentWidget,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: animationDuration,
      pageBuilder: (_, _, _) => _CustomDialogContent(
        title: title,
        message: message,
        type: type,
        customIcon: customIcon,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm ?? () => Navigator.pop(context, true),
        onCancel: onCancel ?? () => Navigator.pop(context, false),
        onClose: onClose ?? () => Navigator.pop(context),
        showCloseButton: showCloseButton,
        customActions: customActions,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        contentWidget: contentWidget,
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return DialogAnimation.fadeScale(animation, child);
      },
    );
  }

  // ==================== Helper Methods ====================

  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    DialogType type = DialogType.question,
    VoidCallback? onConfirm,
  }) {
    return show<bool>(
      context: context,
      title: title,
      message: message,
      type: type,
      confirmText: confirmText ?? 'تأكيد',
      cancelText: cancelText ?? 'إلغاء',
      onConfirm: onConfirm,
    );
  }

  static Future<void> alert({
    required BuildContext context,
    required String title,
    required String message,
    DialogType type = DialogType.info,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      type: type,
      confirmText: confirmText ?? 'حسنًا',
      showCloseButton: false,
      onConfirm: onConfirm,
    );
  }

  static Future<bool?> loading({
    required BuildContext context,
    required String message,
  }) {
    return show<bool>(
      context: context,
      title: 'جاري المعالجة',
      message: message,
      type: DialogType.info,
      confirmText: '',
      showCloseButton: false,
      barrierDismissible: false,
    );
  }
}

// ==================== Internal Widget ====================
class _CustomDialogContent extends StatelessWidget {
  final String title;
  final String message;
  final DialogType type;
  final Widget? customIcon;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onClose;
  final bool showCloseButton;
  final List<DialogAction>? customActions;
  final double? maxWidth;
  final double? maxHeight;
  final Widget? contentWidget;

  const _CustomDialogContent({
    required this.title,
    required this.message,
    required this.type,
    this.customIcon,
    this.confirmText,
    this.cancelText,
    required this.onConfirm,
    required this.onCancel,
    required this.onClose,
    this.showCloseButton = true,
    this.customActions,
    this.maxWidth,
    this.maxHeight,
    this.contentWidget,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width:
              maxWidth ??
              (screenSize.width > 600 ? 450.w : screenSize.width * 0.9),
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? screenSize.height * 0.8,
          ),
          decoration: BoxDecoration(
            gradient: isDark ? null : _getDialogGradient(),
            color: isDark ? const Color(0xFF1E293B) : null,
            borderRadius: BorderRadius.circular(32.r),
            border: isDark
                ? Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
              BoxShadow(
                color: MyColors.primaryColor.withValues(alpha: 0.1),
                blurRadius: 60,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32.r),
            child: Stack(
              children: [
                // Background Glow Effect
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getIconColor(context).withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getIconColor(context).withValues(alpha: 0.05),
                    ),
                  ),
                ),

                // Close Button
                if (showCloseButton)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: _buildCloseButton(context, colors),
                  ),

                // Main Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: showCloseButton ? 8 : 0),

                      // Icon Section
                      // _buildIconSection(context),
                      SizedBox(height: 24),
                      // Scrollable Area
                      Flexible(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title Section
                              MainText(
                                title,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: colors.textColor,
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 12),

                              // Message Section
                              if (contentWidget != null)
                                contentWidget!
                              else
                                MainText(
                                  message,
                                  fontSize: 14,
                                  color: colors.subTextColor,
                                  textAlign: TextAlign.center,
                                  height: 1.5,
                                ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32),

                      // Actions Section
                      if (customActions != null)
                        _buildCustomActions(context)
                      else
                        _buildDefaultActions(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context, AppColorsExtension colors) {
    return InkWell(
      onTap: onClose,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: colors.cardBackground.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.close_rounded, size: 18, color: colors.subTextColor),
      ),
    );
  }

  Widget _buildDefaultActions(BuildContext context) {
    final isConfirmOnly = confirmText != null && cancelText == null;

    if (isConfirmOnly) {
      return Row(
        children: [
          Expanded(
            child: _buildActionButton(
              context,
              text: confirmText!,
              onPressed: onConfirm,
              isPrimary: true,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            text: cancelText ?? 'إلغاء',
            onPressed: onCancel,
            isPrimary: false,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            context,
            text: confirmText ?? 'تأكيد',
            onPressed: onConfirm,
            isPrimary: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomActions(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: customActions!.map((action) {
        return Expanded(
          child: _buildActionButton(
            context,
            text: action.text,
            onPressed: action.onPressed,
            isPrimary: action.isPrimary,
            icon: action.icon,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
    IconData? icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isPrimary
                ? LinearGradient(
                    colors: [
                      MyColors.primaryColor,
                      MyColors.primaryColor.withValues(alpha: 0.8),
                    ],
                  )
                : null,
            color: isPrimary
                ? null
                : (isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(16.r),
            border: !isPrimary
                ? Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.2),
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.w, color: isPrimary ? Colors.white : null),
                SizedBox(width: 8),
              ],
              MainText(
                text,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isPrimary
                    ? Colors.white
                    : isDark
                    ? Colors.white70
                    : Colors.grey.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getIconColor(BuildContext context) {
    switch (type) {
      case DialogType.success:
        return Colors.green;
      case DialogType.error:
        return Colors.red;
      case DialogType.warning:
        return Colors.orange;
      case DialogType.info:
        return MyColors.primaryColor;
      case DialogType.question:
        return MyColors.islamicGold;
      case DialogType.custom:
        return MyColors.primaryColor;
    }
  }

  LinearGradient _getDialogGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.white, Colors.grey.shade50],
    );
  }
}
