import 'dart:math' as math;
import '../../../../../shared/widgets/shared_widgets.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Cart Icon
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 2000),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * math.sin(value * 2 * math.pi)),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            MyColors.primaryColor.withValues(alpha: 0.1),
                            MyColors.lightTeal.withValues(alpha: 0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.primaryColor.withValues(alpha: 0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: MyColors.primaryColor.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                },
              ),

              16.ph,

              // Title
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: MainText.bigText(
                      context.l10n.empty_cart,
                      fontSize: 24,
                      color: MyColors.textDark,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),

              16.ph,

              // Subtitle
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1000),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: MainText(
                      context.l10n.empty_cart_description,
                      fontSize: 14,
                      color: MyColors.grey4,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),

              20.ph,

              // Decorative Features
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1200),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildFeatureChip(
                          icon: Icons.menu_book_rounded,
                          label: context.l10n.quran_courses,
                          color: MyColors.islamicGold,
                        ),
                        _buildFeatureChip(
                          icon: Icons.school_rounded,
                          label: context.l10n.academic_courses,
                          color: MyColors.primaryColor,
                        ),
                        _buildFeatureChip(
                          icon: Icons.star_rounded,
                          label: context.l10n.high_quality_education,
                          color: MyColors.lightTeal,
                        ),
                      ],
                    ),
                  );
                },
              ),

              20.ph,

              // Call to Action Button
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1400),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            MyColors.primaryColor,
                            MyColors.lightTeal,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.primaryColor.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                        },
                        icon: const Icon(
                          Icons.explore_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        label: MainText.bigText(
                          context.l10n.browse_courses,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          8.pw,
          MainText(
            label,
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
