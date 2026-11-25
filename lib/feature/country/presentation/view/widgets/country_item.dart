import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../domain/entities/country.dart';

class CountryItem extends StatelessWidget {
  const CountryItem({
    super.key,
    required this.country,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
    this.isTablet = false,
  });

  final Countries country;
  final bool isSelected;
  final bool isDarkMode;
  final void Function()? onTap;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final primaryColor = MyColors.primaryColor;
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(horizontal: 8),
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: isSelected
            ? BoxDecoration(
                color: primaryColor.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryColor, width: 1),
              )
            : BoxDecoration(
                gradient: theme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
                border: theme.primaryBorder,
                boxShadow: theme.mediumShadow,
              ),
        child: Row(
          children: [
            SizedBox(
              width: isTablet ? 64 : 44,
              height: isTablet ? 48 : 32,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://flagcdn.com/80x60/${country.isoCode.toLowerCase()}.png',
                  placeholder: (context, url) => Container(
                    color: MyColors.grey4.withValues(alpha: 0.1),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.flag_rounded,
                    size: 20,
                    color: MyColors.grey4,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: MainText(
                country.name,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                color: isDarkMode
                    ? (isSelected ? Colors.white : Colors.grey.shade300)
                    : (isSelected ? primaryColor.shade800 : colors.textColor),
              ),
            ),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
