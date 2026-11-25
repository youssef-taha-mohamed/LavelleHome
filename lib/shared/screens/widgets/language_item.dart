import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extension/extension_helper.dart';
import '../../../core/style/app_colors.dart';
import '../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/main_text.dart';

class LanguageItem extends StatelessWidget {
  const LanguageItem({
    super.key,
    required this.languageCode,
    required this.isSelected,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
    this.isTablet = false,
  });

  final String languageCode;
  final bool isSelected;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        margin: EdgeInsets.only(bottom: 24),
        padding: EdgeInsets.zero,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: theme.primaryGradient,
          borderRadius: BorderRadius.circular(8),
          border: theme.primaryBorder,
          boxShadow: theme.mediumShadow,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Selected Badge
            if (isSelected)
              Positioned(
                top: -12,
                left: context.isArabic ? 12 : null,
                right: context.isArabic ? null : 12,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    spacing: 4,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: MyColors.white,
                        size: 14.sp,
                      ),
                      MainText(
                        context.l10n.selected,
                        fontSize: isTablet ? 18 : 10.sp,
                        color: MyColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Flag using flagcdn.com (Rectangular style)
                  SizedBox(
                    width: 48,
                    height: 32,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://flagcdn.com/80x60/${(languageCode == "ar" ? "eg" : "gb")}.png',
                        placeholder: (context, url) => Container(
                          color: MyColors.grey4.withValues(alpha: 0.1),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.flag_rounded,
                          size: 24,
                          color: MyColors.grey4,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  // Language Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        MainText(
                          title,
                          fontSize: isTablet ? 28 : 20,
                          fontWeight: FontWeight.w700,
                          color: context.isDark
                              ? MyColors.white
                              : MyColors.black900,
                        ),
                        MainText(
                          subtitle,
                          fontSize: isTablet ? 18 : 13,
                          color: MyColors.neutral500,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),

                  // Radio Button
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? gradientColors[0]
                            : MyColors.neutral300,
                        width: 2,
                      ),
                      gradient: isSelected
                          ? LinearGradient(
                              colors: gradientColors,
                            )
                          : null,
                    ),
                    child: isSelected
                        ? Center(
                            child: Icon(
                              Icons.check,
                              color: MyColors.white,
                              size: 16,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
