import 'package:flutter/material.dart';
import '../../../../../../core/extension/extension_helper.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../../core/utils/app_responsive.dart';
import '../../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../../shared/widgets/main_text.dart';
import '../../../../domain/enum/payment_enum.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.isSelected,
    required this.method,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final PaymentEnum method;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? color
                      : MyColors.grey4.withValues(alpha: 0.3),
                  width: isSelected ? 2.5 : 1.5,
                ),
                gradient: theme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
                boxShadow: theme.mediumShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: isSelected ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: AppResponsive.getIconSize(context, base: 26),
                      ),
                    ),
                    8.pw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MainText.bigText(
                            method.name,
                            fontSize: AppResponsive.getFontSize(context,
                                mobile: 16, smallTablet: 18, largeTablet: 20),
                            color: context.isDark
                                ? MyColors.white
                                : MyColors.textDark,
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: AppResponsive.getFontSize(context,
                          mobile: 24, smallTablet: 26, largeTablet: 28),
                      height: AppResponsive.getFontSize(context,
                          mobile: 24, smallTablet: 26, largeTablet: 28),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? color : MyColors.grey4,
                          width: 2,
                        ),
                        color: isSelected ? color : Colors.transparent,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              color: MyColors.white,
                              size: AppResponsive.getIconSize(context, base: 14),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
