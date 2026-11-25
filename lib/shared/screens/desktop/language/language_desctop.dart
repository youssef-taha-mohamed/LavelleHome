import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../l10n/l10n.dart';
import '../../../cubits/language/language_cubit.dart';
import '../../../widgets/custom_web_back.dart';
import '../../../widgets/main_text.dart';
import 'widgets/language_item.dart';

class LanguageDesktop extends StatelessWidget {
  final LanguageState state;
  final Function(int) onUpdateLanguage;

  const LanguageDesktop({
    super.key,
    required this.state,
    required this.onUpdateLanguage,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingLanguage) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isDark = context.isDark;
    final theme = Theme.of(context).extension<AppThemeExtension>();

    // Current selected language name
    final currentLanguage = state.languages
            .where((lang) => lang.code == state.languageCode)
            .firstOrNull ??
        (state.languages.isNotEmpty ? state.languages.first : null);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: state.isLoadingUpdate,
        child: Column(
          children: [
            CustomWebBack(
              title: context.l10n.app_language,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 36,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 880),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Hero / Overview Banner ──
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: theme?.primaryGradient ??
                                LinearGradient(
                                  colors: isDark
                                      ? [
                                          const Color(0xFF1E293B),
                                          const Color(0xFF0F172A),
                                        ]
                                      : [
                                          MyColors.primaryColor
                                              .withValues(alpha: 0.08),
                                          MyColors.primaryColor
                                              .withValues(alpha: 0.02),
                                        ],
                                ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.12)
                                  : MyColors.primaryColor
                                      .withValues(alpha: 0.2),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: isDark ? 0.2 : 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: MyColors.primaryColor
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: MyColors.primaryColor
                                        .withValues(alpha: 0.25),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.translate_rounded,
                                  color: MyColors.primaryColor,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MainText(
                                      context.l10n.choose_preferred_language,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: isDark
                                          ? MyColors.white
                                          : MyColors.black900,
                                    ),
                                  ],
                                ),
                              ),
                              if (currentLanguage != null) ...[
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.primaryColor
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: MyColors.primaryColor
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        size: 16,
                                        color: MyColors.primaryColor,
                                      ),
                                      const SizedBox(width: 6),
                                      MainText(
                                        currentLanguage.name,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: MyColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Section Title & Count Badge ──
                        Row(
                          children: [
                            const Icon(
                              Icons.language_rounded,
                              size: 20,
                              color: MyColors.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            MainText(
                              context.l10n.available_languages,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : MyColors.black900,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white12
                                    : MyColors.neutral200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: MainText(
                                '${state.languages.length}',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white70
                                    : MyColors.neutral700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ── Language Cards Grid ──
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 82,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: state.languages.length,
                          itemBuilder: (context, index) {
                            return LanguageCardDesktop(
                              language: state.languages[index],
                              isSelected: state.languages[index].code ==
                                  state.languageCode,
                              onTap: () => onUpdateLanguage(index),
                            );
                          },
                        ),

                        const SizedBox(height: 36),

                        // ── Features & Information Section ──
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? MyColors.darkItemBG3 : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : MyColors.neutral200,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: isDark ? 0.12 : 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildFeatureItem(
                                  context,
                                  icon: Icons.bolt_rounded,
                                  title: context.isArabic
                                      ? 'تطبيق فوري'
                                      : 'Instant Apply',
                                  subtitle: context.isArabic
                                      ? 'تحديث الواجهة والنصوص لحظياً'
                                      : 'Real-time UI & text updates',
                                  isDark: isDark,
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: isDark
                                    ? Colors.white12
                                    : MyColors.neutral200,
                              ),
                              Expanded(
                                child: _buildFeatureItem(
                                  context,
                                  icon: Icons.sync_rounded,
                                  title: context.isArabic
                                      ? 'مزامنة شاملة'
                                      : 'Full Sync',
                                  subtitle: context.isArabic
                                      ? 'حفظ تفضيلاتك عبر جميع الأجهزة'
                                      : 'Saved across all your devices',
                                  isDark: isDark,
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: isDark
                                    ? Colors.white12
                                    : MyColors.neutral200,
                              ),
                              Expanded(
                                child: _buildFeatureItem(
                                  context,
                                  icon:
                                      Icons.format_textdirection_r_to_l_rounded,
                                  title: context.isArabic
                                      ? 'مواءمة الاتجاه'
                                      : 'Direction Alignment',
                                  subtitle: context.isArabic
                                      ? 'دعم تلقائي كامل لـ RTL و LTR'
                                      : 'Full automatic RTL & LTR',
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ),
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
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MyColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: MyColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                MainText(
                  title,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : MyColors.black900,
                ),
                const SizedBox(height: 2),
                MainText(
                  subtitle,
                  fontSize: 11,
                  color: MyColors.grey,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
