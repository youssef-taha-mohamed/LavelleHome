import 'package:flutter/material.dart';
import '../../core/extension/extension_helper.dart';
import '../../core/style/app_colors.dart';
import '../../l10n/l10n.dart';
import 'custom_network_image.dart';
import 'main_text.dart';

class CustomWebBack extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? tagText;
  final VoidCallback? onTap;
  final VoidCallback? onBack;
  final bool showBackButton;

  const CustomWebBack({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.tagText,
    this.onTap,
    this.onBack,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      decoration: BoxDecoration(
        color: context.isDark ? MyColors.darkItemBG2 : Colors.white,
        // border: Border(
        //   bottom: BorderSide(
        //     color: context.isDark ? Colors.white10 : MyColors.neutral200,
        //   ),
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Back Button ──
          if (imageUrl != null || tagText != null || onTap != null)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  EnhancedNetworkImageWidget(
                    width: 48,
                    height: 48,
                    imageUrl: imageUrl,
                    shape: BoxShape.circle,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          const SizedBox(width: 16),

          // ── Main Title / Breadcrumb ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainText(title, fontSize: 24, fontWeight: FontWeight.w900),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                MainText(subtitle!, fontSize: 14, color: Colors.grey),
              ],
            ],
          ),
          const Spacer(),
          if (showBackButton)
            InkWell(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.isDark
                        ? Colors.white10
                        : MyColors.neutral300,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    spacing: 8,
                    children: [
                      MainText(
                        context.l10n.back_button,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.isDark
                            ? Colors.white70
                            : MyColors.neutral700,
                      ),
                      Icon(
                        context.isArabic
                            ? Icons.arrow_forward_ios
                            : Icons.arrow_forward_ios,
                        size: 14,
                        color: context.isDark
                            ? Colors.white70
                            : MyColors.neutral700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // ── Right Side Content (Profile / Actions) ──
        ],
      ),
    );
  }
}
