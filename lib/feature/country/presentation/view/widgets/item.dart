import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../domain/entities/country.dart';

class CountryItem2 extends StatelessWidget {
  const CountryItem2({
    super.key,
    required this.country,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  final Countries country;
  final bool isSelected;
  final bool isDarkMode;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? MyColors.primaryColor.withValues(alpha: 0.1)
              : (isDarkMode ? MyColors.darkItemBG2 : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? MyColors.primaryColor
                : (isDarkMode
                    ? Colors.white.withValues(alpha: 0.1)
                    : MyColors.grey4.withValues(alpha: 0.2)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? MyColors.primaryColor.withValues(alpha: 0.2)
                  : (isDarkMode
                      ? Colors.transparent
                      : Colors.black.withValues(alpha: 0.05)),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Flag Container
            SizedBox(
              width: 48,
              height: 32,
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
                    size: 24,
                    color: MyColors.grey4,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Country Name
            Expanded(
              child: MainText(
                country.name,
                fontSize: 17,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? MyColors.primaryColor
                    : (isDarkMode ? Colors.white : MyColors.textDark),
              ),
            ),
            // Check Icon
            AnimatedScale(
              scale: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              child: AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MyColors.primaryColor,
                        MyColors.lightTeal,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
