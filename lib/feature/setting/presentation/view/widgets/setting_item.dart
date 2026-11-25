import 'package:flutter/material.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/utils/app_responsive.dart';
import '../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../shared/widgets/main_text.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    this.icon,
    this.subtitle,
    this.trailingWidget,
    this.onTap,
    this.iconBackgroundColor,
  });

  final String title;
  final IconData? icon;
  final String? subtitle;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(8),
       // border: theme.primaryBorder,
        boxShadow: theme.mediumShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.getFontSize(context,
                  mobile: 16, smallTablet: 20, largeTablet: 24),
              vertical: AppResponsive.getFontSize(context,
                  mobile: 16, smallTablet: 20, largeTablet: 24),
            ),
            child: Row(
              children: [
                // Icon with colored background
                if (icon != null)
                  Container(
                    width: AppResponsive.getFontSize(context,
                        mobile: 46, smallTablet: 60, largeTablet: 70),
                    height: AppResponsive.getFontSize(context,
                        mobile: 46, smallTablet: 60, largeTablet: 70),
                    decoration: BoxDecoration(
                      color: (iconBackgroundColor ?? MyColors.primaryColor)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: AppResponsive.getIconSize(context, base: 18),
                        color: iconBackgroundColor ?? MyColors.primaryColor,
                      ),
                    ),
                  ),

                if (icon != null) SizedBox(width: 16),

                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainText(
                        title,
                        fontSize: AppResponsive.getFontSize(context,
                            mobile: 16, smallTablet: 22, largeTablet: 26),
                        fontWeight: FontWeight.w600,
                        color:
                            context.isDark ? MyColors.white : MyColors.black900,
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4),
                        MainText(
                          subtitle!,
                          fontSize: AppResponsive.getFontSize(context,
                              mobile: 12, smallTablet: 18, largeTablet: 22),
                          color: MyColors.neutral500,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ],
                  ),
                ),

                // Trailing
                if (trailingWidget != null)
                  trailingWidget!
                else if (onTap != null)
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.isDark
                          ? MyColors.darkItemBG3
                          : MyColors.neutral100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: AppResponsive.getIconSize(context, base: 10),
                      color: MyColors.neutral600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
