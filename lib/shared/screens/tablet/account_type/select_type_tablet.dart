import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/resources/images.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../../../l10n/l10n.dart';
import '../../../show_case/view/custom_show_case.dart';
import '../../../widgets/main_text.dart';

class AccountTypeSelectionTabletView extends StatelessWidget {
  const AccountTypeSelectionTabletView({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.cardScaleAnimation,
    required this.onBack,
    required this.studentKey,
    required this.parentKey,
    required this.onStudentTap,
    required this.onParentTap,
    required this.showcaseController,
  });

  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> cardScaleAnimation;
  final VoidCallback onBack;

  // Need to recreate the cards here to make them horizontal instead of vertical
  final GlobalKey studentKey;
  final GlobalKey parentKey;
  final VoidCallback onStudentTap;
  final VoidCallback onParentTap;
  final dynamic showcaseController;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // 1. Background Layer (Colors)
        Container(color: colors.background),

        // 2. Header Gradient Curved Shape (Top 40% of screen)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: size.height * 0.45,
          child: ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    MyColors.primaryColor,
                    MyColors.darkGreen,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  const _DecorativeCircles(),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: MyColors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        MyColors.white.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    ImagesAssets.logo,
                                    fit: BoxFit.cover,
                                    color: MyColors.grey100,
                                    colorBlendMode: BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              MainText(
                                context.l10n.welcome_to_konoz,
                                color: MyColors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                                letterSpacing: 1.2,
                              ),
                              const SizedBox(height: 8),
                              MainText(
                                context.l10n.choose_your_account_type,
                                color: MyColors.white.withValues(alpha: 0.85),
                                fontSize: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 3. Floating Horizontal Cards Content
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: size.height * 0.15,
                    left: 40,
                    right: 40,
                  ),
                  child: ScaleTransition(
                    scale: cardScaleAnimation,
                    child: _buildHorizontalCards(context, colors),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Back Button
        if (defaultTargetPlatform == TargetPlatform.iOS)
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: GestureDetector(
                  onTap: onBack,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: MyColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: MyColors.white.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: MyColors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHorizontalCards(
      BuildContext context, AppColorsExtension colors) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 880, maxHeight: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Student Card
          Expanded(
            child: CustomShowcase(
              showcaseId: 'student_card',
              showcaseGroupId: 'account_type_tour',
              keyValue: studentKey,
              title: context.l10n.sh_student_title,
              description: context.l10n.sh_student_desc,
              totalShowcases: 2,
              currentIndex: 0,
              customGradientColors: [
                MyColors.primaryColor,
                MyColors.primaryColor.shade700,
              ],
              child: _buildLargeCard(
                context: context,
                title: context.l10n.student_account_text,
                subtitle: context.l10n.for_students,
                description: context.l10n.enjoy,
                icon: Icons.school_rounded,
                iconColor: MyColors.primaryColor,
                cardColor: context.isDark
                    ? MyColors.black.withValues(alpha: 0.2)
                    : MyColors.cardBg,
                borderColor: MyColors.primaryColor.withValues(alpha: 0.2),
                onTap: onStudentTap,
                colors: colors,
              ),
            ),
          ),

          const SizedBox(width: 32),

          // Parent Card
          Expanded(
            child: CustomShowcase(
              showcaseId: 'parent_card',
              showcaseGroupId: 'account_type_tour',
              keyValue: parentKey,
              title: context.l10n.sh_parent_title,
              description: context.l10n.sh_parent_desc,
              totalShowcases: 2,
              currentIndex: 1,
              customGradientColors: const [
                MyColors.islamicGold,
                Color(0xFFD4AF37),
              ],
              onComplete: () => showcaseController.complete(),
              child: _buildLargeCard(
                context: context,
                title: context.l10n.for_parent_text,
                subtitle: context.l10n.to_monitor_children,
                description: context.l10n.track_children,
                icon: Icons.supervisor_account_rounded,
                iconColor: MyColors.islamicGold,
                cardColor: context.isDark
                    ? MyColors.black.withValues(alpha: 0.2)
                    : MyColors.cardBg,
                borderColor: MyColors.islamicGold.withValues(alpha: 0.3),
                onTap: onParentTap,
                colors: colors,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color cardColor,
    required Color borderColor,
    required VoidCallback onTap,
    required AppColorsExtension colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 420, // Fixed large height for tablets
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.08),
              blurRadius: 40,
              offset: const Offset(0, 15),
            ),
            if (!context.isDark)
              BoxShadow(
                color: MyColors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Stack(
          children: [
            // Background subtle icon decor
            Positioned(
              right: context.isArabic ? null : -20,
              left: context.isArabic ? -20 : null,
              bottom: -20,
              child: Icon(
                icon,
                size: 140,
                color: iconColor.withValues(alpha: 0.03),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: iconColor.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 48,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  MainText.bigText(
                    title,
                    color: colors.textColor,
                    fontSize: 32,
                  ),
                  const SizedBox(height: 8),
                  MainText(
                    subtitle,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  MainText(
                    description,
                    fontSize: 18,
                    color: colors.subTextColor,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    height: 1.5,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MainText(
                          context.isArabic ? 'اختر' : 'Select',
                          color: iconColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          context.isArabic
                              ? Icons.arrow_back_rounded
                              : Icons.arrow_forward_rounded,
                          size: 18,
                          color: iconColor,
                        ),
                      ],
                    ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Clippers & Decorators
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80);

    // Create a smooth curve at the bottom
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DecorativeCircles extends StatelessWidget {
  const _DecorativeCircles();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: _circle(260, MyColors.white.withValues(alpha: 0.05)),
          ),
          Positioned(
            top: 100,
            left: -60,
            child: _circle(300, MyColors.islamicGold.withValues(alpha: 0.07)),
          ),
          Positioned(
            bottom: -40,
            right: 150,
            child: _circle(160, MyColors.white.withValues(alpha: 0.04)),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
