import 'package:flutter/material.dart';
import '../../../../../../core/extension/extension_helper.dart';

import '../../../../../../core/style/app_colors.dart';
import '../../../../../../l10n/l10n.dart';
import '../../../../../../shared/widgets/main_text.dart';
import '../../../../domain/entities/summary.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.summary,
  });

  final OrderSummary? summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MyColors.darkGreen,
            MyColors.deepGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: MyColors.darkGreen.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles in background
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.goldAccent.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem(
                      icon: Icons.inventory_2_rounded,
                      label: context.l10n.number_of_items,
                      value: '${summary?.items.length}',
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: MyColors.white.withValues(alpha: 0.3),
                    ),
                    _buildSummaryItem(
                      icon: Icons.groups_rounded,
                      label: context.l10n.number_of_sessions,
                      value: '${summary?.numberOfSession}',
                    ),
                  ],
                ),
                Divider(
                  color: MyColors.white.withValues(alpha: 0.3),
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 12,
                  children: [
                    MainText(
                      context.l10n.total_price,
                      fontSize: 16,
                      color: MyColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    MainText.bigText(
                      '${summary?.totalPrice} ',
                      fontSize: 32,
                      color: MyColors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          12.ph,
          MainText(
            label,
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          ),
          6.ph,
          MainText.bigText(
            value,
            fontSize: 24,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
