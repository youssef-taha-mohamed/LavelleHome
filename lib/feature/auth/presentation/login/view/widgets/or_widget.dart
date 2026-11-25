import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../../../../../l10n/l10n.dart';
import '../../../../../../shared/widgets/main_text.dart';
import '../../../../../country/presentation/view/countries_screen.dart';
import '../../../register/view/register.dart';
import 'google_button_factory.dart';

/// القسم السفلي من شاشة الدخول:
/// 1) الدخول بالسوشيال  2) الدخول كضيف  3) إنشاء حساب جديد (في الآخر)
class OrWidget extends StatelessWidget {
  final VoidCallback googleTap;
  final VoidCallback appleTap;
  final double? orFontSize;
  final double? actionFontSize;
  final bool isGoogleLoading;
  final bool isAppleLoading;

  const OrWidget({
    super.key,
    required this.googleTap,
    required this.appleTap,
    this.orFontSize,
    this.actionFontSize,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? MyColors.skyBlue : MyColors.primaryColor;
    final busy = isGoogleLoading || isAppleLoading;

    return Column(
      children: [
        const SizedBox(height: 26),

        // ───── فاصل "أو المتابعة عبر" ─────
        Row(
          children: [
            Expanded(child: _fadeLine(colors.subTextColor, toEnd: false)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: MainText(
                context.l10n.or_continue_with,
                color: colors.subTextColor,
                fontSize: orFontSize ?? 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(child: _fadeLine(colors.subTextColor, toEnd: true)),
          ],
        ),
        const SizedBox(height: 18),

        // ───── السوشيال لوجن ─────
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: kIsWeb
                  ? buildWebGoogleButton()
                  : buildSocialButton(
                      context.l10n.google,
                      Icons.g_mobiledata,
                      colors.textColor,
                      busy ? null : googleTap,
                      isLoading: isGoogleLoading,
                    ),
            ),
            if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
              Expanded(
                child: buildSocialButton(
                  context.l10n.apple,
                  Icons.apple,
                  colors.textColor,
                  busy ? null : appleTap,
                  isLoading: isAppleLoading,
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // ───── الدخول كضيف ─────
        _buildGuestButton(context, isDark),

        const SizedBox(height: 16),
        Divider(
          height: 1,
          thickness: 1,
          color: colors.subTextColor.withValues(alpha: 0.18),
        ),
        const SizedBox(height: 16),

        // ───── التسجيل العادي (في الآخر) ─────
        _buildRegisterPrompt(context, colors, accent),
      ],
    );
  }

  // خط يتلاشى تدريجياً نحو النص
  Widget _fadeLine(Color color, {required bool toEnd}) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: toEnd
              ? AlignmentDirectional.centerStart
              : AlignmentDirectional.centerEnd,
          end: toEnd
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          colors: [color.withValues(alpha: 0.5), color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }

  Widget _buildGuestButton(BuildContext context, bool isDark) {
    // ذهبي الهوية للحدود، وبني ذهبي أغمق للنص في الوضع الفاتح لوضوح أفضل
    final textColor = isDark ? MyColors.goldAccent : MyColors.warning700;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.pushNamed(context, CountriesGuestView.routeName);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: MyColors.goldAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: MyColors.goldAccent.withValues(alpha: 0.65),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(Icons.explore_outlined, size: 20, color: textColor),
            MainText(
              context.l10n.continue_as_guest,
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: (actionFontSize != null) ? actionFontSize! + 2 : 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterPrompt(
    BuildContext context,
    AppColorsExtension colors,
    Color accent,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pushNamed(context, RegisterView.routeName);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: MyColors.primaryColor.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.2)),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          runSpacing: 2,
          children: [
            MainText(
              context.l10n.do_not_have_account,
              color: colors.textColor.withValues(alpha: 0.7),
              fontSize: actionFontSize ?? 12.5,
            ),
            MainText(
              context.l10n.create_new_account,
              color: accent,
              fontWeight: FontWeight.w800,
              fontSize: actionFontSize ?? 13,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSocialButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback? onTap, {
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(icon, color: color, size: 26),
            const SizedBox(width: 8),
            MainText(
              title,
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
