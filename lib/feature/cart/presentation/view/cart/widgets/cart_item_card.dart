import 'package:flutter/material.dart';
import '../../../../../../core/extension/extension_helper.dart';
import '../../../../../../core/authentication/provider.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../../l10n/l10n.dart';
import '../../../../../../shared/widgets/main_text.dart';
import '../../../../domain/entities/cart_item.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(8),
        border: theme.primaryBorder,
        boxShadow: theme.mediumShadow,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MyColors.primaryColor.withValues(alpha: 0.2),
                        MyColors.primaryColor.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    color: MyColors.primaryColor,
                    size: 28,
                  ),
                ),
                14.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainText.bigText(
                        item.subjectName,
                        fontSize: 17,
                        color:
                            context.isDark ? MyColors.white : MyColors.textDark,
                      ),
                      4.ph,
                      MainText(
                        item.packageName,
                        fontSize: 13,
                        color: MyColors.grey4,
                        fontWeight: FontWeight.w500,
                      ),
                      8.ph,
                      Row(
                        spacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: MyColors.grey4.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: MyColors.grey4,
                                ),
                                MainText(
                                  '${item.duration} ${context.l10n.minute}',
                                  fontSize: 12,
                                  color: MyColors.grey4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  MyColors.islamicGold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.groups_rounded,
                                  size: 14,
                                  color: MyColors.islamicGold,
                                ),
                                MainText(
                                  '${item.sessionCount} ${context.l10n.a_class}',
                                  fontSize: 12,
                                  color: MyColors.islamicGold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (AuthenticationProvider
                        .instance.currentUser?.details.isAdult ??
                    false)
                  GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MyColors.customRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: MyColors.customRed,
                        size: 22,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 24,
              color: MyColors.primaryColor.withValues(alpha: 0.2),
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 12),
            child: Row(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (item.isPriceChanged)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: MyColors.islamicGold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      spacing: 4,
                      children: [
                        MainText(
                          context.l10n.price_updated,
                          fontSize: 12,
                          color: MyColors.islamicGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: MyColors.primaryColor.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    spacing: 6,
                    children: [
                      const Icon(
                        Icons.payments_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      MainText.bigText(
                        item.totalPrice.toStringAsFixed(0),
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      MainText(
                        item.currency,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
