import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../../../feature/auth/presentation/register/view/register.dart';
import '../../../../l10n/l10n.dart';
import '../../../show_case/management/showcase_helper.dart';
import '../../../show_case/view/custom_show_case.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/main_text.dart';
import '../../tablet/account_type/select_type_tablet.dart';

class AccountTypeSelectionScreen extends StatefulWidget {
  const AccountTypeSelectionScreen({super.key});

  static const String routeName = '/account-type-selection';

  @override
  State<AccountTypeSelectionScreen> createState() =>
      _AccountTypeSelectionScreenState();
}

class _AccountTypeSelectionScreenState extends State<AccountTypeSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _cardScaleAnimation;
  final GlobalKey _studentKey = GlobalKey();
  final GlobalKey _parentKey = GlobalKey();
  late final ShowcaseController _showcaseController;
  Timer? _showcaseTimer;

  @override
  void initState() {
    super.initState();

    _showcaseController = ShowcaseController(
      showcaseGroupId: 'account_type_tour',
      showcaseKeys: [_studentKey, _parentKey],
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _cardScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _cardAnimationController.forward();
    });

    _startShowcase();
  }

  void _startShowcase() {
    // WidgetsBinding might still trigger even if we navigate away quickly.
    // Using a Timer we can cancel in dispose, and checking if route is still current.
    _showcaseTimer = Timer(const Duration(milliseconds: 1500), () async {
      if (!mounted) return;

      // Additional safety check: only start if this screen is still the top route
      final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
      if (!isCurrent) {
        debugPrint('Showcase skipped: Screen is no longer current');
        return;
      }

      try {
        await _showcaseController.start(context);
      } catch (e) {
        debugPrint('Error starting showcase: $e');
      }
    });
  }

  @override
  void dispose() {
    _showcaseTimer?.cancel();
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _navigateToStudentRegister() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(
      context,
      RegisterView.routeName,
      arguments: true,
    );
  }

  void _navigateToParentRegister() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(
      context,
      RegisterView.routeName,
      arguments: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isTablet = constraints.maxWidth >= 600;

          if (isTablet) {
            return AccountTypeSelectionTabletView(
              fadeAnimation: _fadeAnimation,
              slideAnimation: _slideAnimation,
              cardScaleAnimation: _cardScaleAnimation,
              studentKey: _studentKey,
              parentKey: _parentKey,
              onStudentTap: _navigateToStudentRegister,
              onParentTap: _navigateToParentRegister,
              showcaseController: _showcaseController,
              onBack: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
            );
          }

          return Stack(
            children: [
              // Top Background Header with Indigo Gradient
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        MyColors.primaryColor,
                        MyColors.darkPrimaryDark,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.getPadding(context),
                    vertical: 8,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          70.ph,
                          // Logo inside a circular badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              height: 80,
                              width: 80,
                              child: const Center(child: AppLogo()),
                            ),
                          ),
                          24.ph,
                          MainText(
                            context.l10n.welcome_to_k,
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                          8.ph,
                          MainText(
                            context.l10n.choose_your_account_type,
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                            textAlign: TextAlign.center,
                          ),
                          48.ph,
                          // Floating Form Card
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 450),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 32,
                            ),
                            decoration: BoxDecoration(
                              color: context.isDark
                                  ? MyColors.darkItemBG5
                                  : MyColors.cardBg,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: context.isDark
                                      ? Colors.black.withValues(alpha: 0.3)
                                      : MyColors.primaryColor.withValues(
                                          alpha: 0.15,
                                        ),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: ScaleTransition(
                              scale: _cardScaleAnimation,
                              child: _buildAccountCards(context, colors),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (defaultTargetPlatform == TargetPlatform.iOS)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAccountCards(BuildContext context, AppColorsExtension colors) {
    return Column(
      spacing: 16,
      children: [
        CustomShowcase(
          showcaseId: 'student_card',
          showcaseGroupId: 'account_type_tour',
          keyValue: _studentKey,
          title: context.l10n.sh_student_title,
          description: context.l10n.sh_student_desc,
          totalShowcases: 2,
          currentIndex: 0,
          customGradientColors: [
            MyColors.primaryColor,
            MyColors.primaryColor.shade700,
          ],
          child: _buildAccountCard(
            context: context,
            title: context.l10n.student_account,
            subtitle: context.l10n.for_students,
            description: context.l10n.enjoy,
            icon: Icons.school_rounded,
            iconColor: MyColors.primaryColor,
            cardColor: context.isDark
                ? MyColors.black.withValues(alpha: 0.2)
                : MyColors.primaryColor.withValues(alpha: 0.03),
            borderColor: MyColors.primaryColor.withValues(alpha: 0.2),
            onTap: _navigateToStudentRegister,
          ),
        ),
        CustomShowcase(
          showcaseId: 'parent_card',
          showcaseGroupId: 'account_type_tour',
          keyValue: _parentKey,
          title: context.l10n.sh_parent_title,
          description: context.l10n.sh_parent_desc,
          totalShowcases: 2,
          currentIndex: 1,
          customGradientColors: [
            MyColors.islamicGold,
            const Color(0xFFD4AF37),
          ],
          onComplete: _showcaseController.complete,
          child: _buildAccountCard(
            context: context,
            title: context.l10n.for_parent,
            subtitle: context.l10n.to_monitor_children,
            description: context.l10n.track_children,
            icon: Icons.supervisor_account_rounded,
            iconColor: MyColors.islamicGold,
            cardColor: context.isDark
                ? MyColors.black.withValues(alpha: 0.2)
                : MyColors.islamicGold.withValues(alpha: 0.03),
            borderColor: MyColors.islamicGold.withValues(alpha: 0.3),
            onTap: _navigateToParentRegister,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color cardColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: iconColor,
                ),
              ),
              16.pw,
              Expanded(
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainText.bigText(
                      title,
                      color: colors.textColor,
                      fontSize: 16,
                    ),
                    MainText(
                      subtitle,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                    MainText(
                      description,
                      fontSize: 11,
                      color: colors.subTextColor,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              8.pw,
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: iconColor.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
