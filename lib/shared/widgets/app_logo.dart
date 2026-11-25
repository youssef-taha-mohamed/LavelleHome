import '../../core/utils/styles_link.dart';
import '../../feature/auth/presentation/login/view/login.dart';
import 'shared_widgets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DeveloperAuthScreen(),
            ),
          );
        },
        child: Container(
          width: 90,
          height: 90,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: MyColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(ImagesAssets.logo, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  lavelle_ui.dart  —  الأساس المشترك لتطبيق العميل (المرحلة 0.1)
//  المسار المقترح: lib/shared/widgets/lavelle_ui.dart
//
//  يحتوي: Tokens (مسافات/زوايا/تدرجات) + ثيم مختصر + مكونات جاهزة:
//  Card, Button, Chip, RatingBadge, IconBadge, SectionHeader,
//  HeroBackground, Reveal, Skeleton, StateView (فراغ/خطأ/لا إنترنت),
//  StatusBody (يبدّل بين الحالات)، showLavelleSheet.
// ═══════════════════════════════════════════════════════════════

// ───────────────────────── Tokens ─────────────────────────

abstract final class LavelleSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

abstract final class LavelleRadius {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
}

abstract final class LavelleGradients {
  /// للأزرار والأيقونات المميزة
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [MyColors.primaryColor, MyColors.primaryContainer],
  );

  /// للهيرو العلوي
  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      MyColors.deepBlue,
      MyColors.primaryColor,
      MyColors.primaryContainer,
    ],
    stops: [0.0, 0.55, 1.0],
  );
}

/// ثيم مختصر يجمع ألوان الواجهة حسب الوضع (فاتح/داكن)
class LavelleTheme {
  final bool isDark;
  final Color accent; // كحلي في الفاتح، سماوي في الداكن
  final Color card;
  final Color border;
  final Color text;
  final Color subText;

  const LavelleTheme._({
    required this.isDark,
    required this.accent,
    required this.card,
    required this.border,
    required this.text,
    required this.subText,
  });

  factory LavelleTheme.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = Theme.of(context).extension<AppColorsExtension>()!;
    return LavelleTheme._(
      isDark: isDark,
      accent: isDark ? MyColors.skyBlue : MyColors.primaryColor,
      card: isDark ? MyColors.darkItemBG5 : MyColors.cardBg,
      border: MyColors.skyBlue.withValues(alpha: isDark ? 0.18 : 0.25),
      text: c.textColor,
      subText: c.subTextColor,
    );
  }

  Color get shadow => isDark
      ? Colors.black.withValues(alpha: 0.35)
      : MyColors.primaryColor.withValues(alpha: 0.12);
}

// ───────────────────────── Card ─────────────────────────

class LavelleCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double radius;
  final Color? color;
  final Color? borderColor;

  const LavelleCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(LavelleSpacing.lg),
    this.onTap,
    this.radius = LavelleRadius.lg,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final r = BorderRadius.circular(radius);

    return Container(
      decoration: BoxDecoration(
        color: color ?? t.card,
        borderRadius: r,
        border: Border.all(color: borderColor ?? t.border),
        boxShadow: [
          BoxShadow(
            color: t.shadow,
            blurRadius: 24,
            spreadRadius: -4,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: r,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

// ───────────────────────── Button ─────────────────────────

enum LavelleButtonVariant { primary, secondary, gold }

class LavelleButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final IconData? icon; // أيقونة في نهاية الزر (مثل السهم)
  final bool isLoading;
  final bool isDimmed; // شكل باهت فقط، الضغط يظل يعمل
  final LavelleButtonVariant variant;
  final double height;
  final bool expand;

  const LavelleButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.isLoading = false,
    this.isDimmed = false,
    this.variant = LavelleButtonVariant.primary,
    this.height = 54,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final radius = BorderRadius.circular(LavelleRadius.md);
    final active = !isDimmed || isLoading;

    late final Color fg;
    BoxDecoration decoration;

    switch (variant) {
      case LavelleButtonVariant.primary:
        fg = Colors.white;
        decoration = BoxDecoration(
          borderRadius: radius,
          gradient: active
              ? LavelleGradients.primary
              : LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    MyColors.primaryColor.withValues(alpha: 0.4),
                    MyColors.primaryContainer.withValues(alpha: 0.4),
                  ],
                ),
          boxShadow: active && !isLoading
              ? [
                  BoxShadow(
                    color: MyColors.primaryColor.withValues(alpha: 0.38),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        );
        break;
      case LavelleButtonVariant.secondary:
        fg = t.accent;
        decoration = BoxDecoration(
          borderRadius: radius,
          color: t.accent.withValues(alpha: 0.06),
          border: Border.all(color: t.accent.withValues(alpha: 0.35)),
        );
        break;
      case LavelleButtonVariant.gold:
        fg = t.isDark ? MyColors.goldAccent : MyColors.warning700;
        decoration = BoxDecoration(
          borderRadius: radius,
          color: MyColors.goldAccent.withValues(alpha: 0.1),
          border: Border.all(
            color: MyColors.goldAccent.withValues(alpha: 0.65),
          ),
        );
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: height,
      width: expand ? double.infinity : null,
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: isLoading ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              widthFactor: expand ? null : 1,
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(fg),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MainText(
                          title,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: fg,
                          letterSpacing: 0.3,
                        ),
                        if (icon != null) ...[
                          const SizedBox(width: 8),
                          Icon(icon, color: fg, size: 19),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Chip / Rating / Icon badge ─────────────────────────

enum LavelleTone { primary, success, warning, danger, neutral }

/// شارة صغيرة ملونة: (مفتوح الآن / مغلق / حالة طلب ...)
class LavelleChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final LavelleTone tone;

  const LavelleChip({
    super.key,
    required this.label,
    this.icon,
    this.tone = LavelleTone.primary,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final Color color;
    switch (tone) {
      case LavelleTone.primary:
        color = t.accent;
        break;
      case LavelleTone.success:
        color = MyColors.success;
        break;
      case LavelleTone.warning:
        color = MyColors.warning600;
        break;
      case LavelleTone.danger:
        color = MyColors.error;
        break;
      case LavelleTone.neutral:
        color = t.subText;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          if (icon != null) Icon(icon, size: 14, color: color),
          MainText(
            label,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ],
      ),
    );
  }
}

class LavelleRatingBadge extends StatelessWidget {
  final double rating;
  final int? count;

  const LavelleRatingBadge({super.key, required this.rating, this.count});

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 3,
      children: [
        const Icon(Icons.star_rounded, size: 17, color: MyColors.goldAccent),
        MainText(
          rating.toStringAsFixed(1),
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: t.text,
        ),
        if (count != null) MainText('($count)', fontSize: 12, color: t.subText),
      ],
    );
  }
}

class LavelleIconBadge extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool filled; // true: تدرج الهوية، false: خلفية خفيفة
  final Color? color;

  const LavelleIconBadge({
    super.key,
    required this.icon,
    this.size = 40,
    this.filled = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    final tint = color ?? t.accent;
    final radius = BorderRadius.circular(size * 0.32);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: filled ? LavelleGradients.primary : null,
        color: filled ? null : tint.withValues(alpha: 0.1),
        boxShadow: filled
            ? [
                BoxShadow(
                  color: MyColors.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ]
            : [],
      ),
      child: Icon(icon, size: size * 0.5, color: filled ? Colors.white : tint),
    );
  }
}

// ───────────────────────── Section header ─────────────────────────

class LavelleSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const LavelleSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: t.accent,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: MainText(
            title,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: t.text,
          ),
        ),
        if (actionLabel != null)
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: MainText(
                actionLabel!,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: t.accent,
              ),
            ),
          ),
      ],
    );
  }
}

// ───────────────────────── Hero background ─────────────────────────

/// الهيرو الكحلي بحافة موجية وفقاعات. ضعه داخل Positioned(top: 0, ...) أو Stack.
class LavelleHeroBackground extends StatelessWidget {
  final double height;
  final bool showBubbles;

  const LavelleHeroBackground({
    super.key,
    required this.height,
    this.showBubbles = true,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: ClipPath(
          clipper: _LavelleWaveClipper(),
          child: DecoratedBox(
            decoration: const BoxDecoration(gradient: LavelleGradients.hero),
            child: showBubbles
                ? Stack(
                    children: [
                      _bubble(top: -50, right: -40, size: 180, alpha: 0.07),
                      _bubble(top: 100, left: -60, size: 150, alpha: 0.06),
                      _bubble(top: 60, left: 80, size: 30, alpha: 0.12),
                      _bubble(top: 170, right: 50, size: 22, alpha: 0.14),
                      _bubble(top: 30, right: 120, size: 14, alpha: 0.18),
                    ],
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _bubble({
    double? top,
    double? left,
    double? right,
    required double size,
    required double alpha,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
          border: Border.all(
            color: MyColors.skyBlue.withValues(alpha: alpha + 0.08),
          ),
        ),
      ),
    );
  }
}

class _LavelleWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 50)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height,
        size.width * 0.55,
        size.height - 28,
      )
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height - 62,
        size.width,
        size.height - 24,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ───────────────────────── Reveal (ظهور تدريجي) ─────────────────────────

class LavelleReveal extends StatelessWidget {
  final Widget child;
  final double begin; // 0..1 تأخير نسبي
  final double dy;

  const LavelleReveal({
    super.key,
    required this.child,
    this.begin = 0.0,
    this.dy = 24,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1100),
      child: child,
      builder: (context, t, child) {
        final v = Interval(begin, 1.0, curve: Curves.easeOutCubic).transform(t);
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * dy),
            child: child,
          ),
        );
      },
    );
  }
}

// ───────────────────────── Skeleton (تحميل) ─────────────────────────

class LavelleSkeleton extends StatefulWidget {
  final double? width;
  final double height;
  final double radius;

  const LavelleSkeleton({
    super.key,
    this.width,
    required this.height,
    this.radius = 10,
  });

  @override
  State<LavelleSkeleton> createState() => _LavelleSkeletonState();
}

class _LavelleSkeletonState extends State<LavelleSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1.0).animate(_c),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: t.subText.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

/// هيكل تحميل لقائمة كروت (صورة + سطرين)
class LavelleSkeletonList extends StatelessWidget {
  final int itemCount;

  const LavelleSkeletonList({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: LavelleSpacing.md,
      children: [
        for (var i = 0; i < itemCount; i++)
          LavelleCard(
            child: Row(
              spacing: LavelleSpacing.md,
              children: [
                const LavelleSkeleton(width: 72, height: 72, radius: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: const [
                      LavelleSkeleton(height: 14, width: 150),
                      LavelleSkeleton(height: 11, width: 100),
                      LavelleSkeleton(height: 11, width: 70),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ───────────────────────── State views ─────────────────────────

/// عرض حالة عامة: أيقونة كبيرة + عنوان + رسالة + زر اختياري
class LavelleStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const LavelleStateView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final t = LavelleTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LavelleSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.accent.withValues(alpha: 0.08),
                border: Border.all(color: t.accent.withValues(alpha: 0.18)),
              ),
              child: Center(
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LavelleGradients.primary,
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
              ),
            ),
            const SizedBox(height: LavelleSpacing.xl),
            MainText(
              title,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: t.text,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: LavelleSpacing.sm),
              MainText(
                message!,
                fontSize: 13.5,
                color: t.subText,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: LavelleSpacing.xl),
              LavelleButton(
                title: actionLabel!,
                onTap: onAction,
                expand: false,
                height: 48,
                variant: LavelleButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// خطأ عام أو لا يوجد اتصال، مع زر إعادة المحاولة
class LavelleErrorView extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool isNoConnection;
  final String? message; // رسالة الخادم إن وُجدت

  const LavelleErrorView({
    super.key,
    this.onRetry,
    this.isNoConnection = false,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LavelleStateView(
      icon: isNoConnection
          ? Icons.wifi_off_rounded
          : Icons.error_outline_rounded,
      title: isNoConnection ? l10n.no_connection_title : l10n.error_title,
      message:
          message ??
          (isNoConnection ? l10n.no_connection_message : l10n.error_message),
      actionLabel: onRetry == null ? null : l10n.retry,
      onAction: onRetry,
    );
  }
}

// ───────────────────────── Status body ─────────────────────────

enum LavelleViewStatus { loading, success, empty, error, noConnection }

/// يبدّل المحتوى حسب الحالة. استخدمه في كل شاشة تجلب بيانات.
class LavelleStatusBody extends StatelessWidget {
  final LavelleViewStatus status;
  final WidgetBuilder builder; // يُستدعى عند success
  final Widget? loading; // الافتراضي: LavelleSkeletonList
  final Widget? empty; // الافتراضي: حالة فراغ عامة
  final VoidCallback? onRetry;
  final String? errorMessage;

  const LavelleStatusBody({
    super.key,
    required this.status,
    required this.builder,
    this.loading,
    this.empty,
    this.onRetry,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final Widget body;
    switch (status) {
      case LavelleViewStatus.loading:
        body = loading ?? const LavelleSkeletonList();
        break;
      case LavelleViewStatus.success:
        body = builder(context);
        break;
      case LavelleViewStatus.empty:
        body =
            empty ??
            LavelleStateView(
              icon: Icons.inbox_outlined,
              title: context.l10n.empty_default_title,
            );
        break;
      case LavelleViewStatus.error:
        body = LavelleErrorView(onRetry: onRetry, message: errorMessage);
        break;
      case LavelleViewStatus.noConnection:
        body = LavelleErrorView(onRetry: onRetry, isNoConnection: true);
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: KeyedSubtree(
        key: ValueKey<LavelleViewStatus>(status),
        child: body,
      ),
    );
  }
}

// ───────────────────────── Bottom sheet ─────────────────────────

Future<T?> showLavelleSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? title,
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final t = LavelleTheme.of(ctx);
      return Container(
        decoration: BoxDecoration(
          color: t.card,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(LavelleRadius.xl),
          ),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: t.subText.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 4),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: MainText(
                    title,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: t.text,
                  ),
                ),
              ),
            Flexible(child: builder(ctx)),
          ],
        ),
      );
    },
  );
}

/// مسار شاشة التسجيل (RegisterView.routeName)
const String _registerRoute = '/register';

/// الضيف = لا يوجد مستخدم مسجل. (تأكد أن هذا يطابق تعريفك للضيف)
bool get isGuestUser => AuthenticationProvider.instance.currentUser == null;

/// استدعِها قبل أي إجراء يحتاج حساباً (إرسال طلب، إلغاء، تقييم...):
///
/// ```dart
/// if (!await ensureAuthenticated(context)) return;
/// // ... أكمل الإجراء
/// ```
/// للمسجّل ترجع true فوراً. للضيف تعرض نافذة دخول وترجع false.
Future<bool> ensureAuthenticated(
  BuildContext context, {
  String? message,
}) async {
  if (!isGuestUser) return true;

  final navigator = Navigator.of(context);

  await showLavelleSheet<void>(
    context,
    title: context.l10n.guest_gate_title,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainText(
            message ?? ctx.l10n.guest_gate_message,
            fontSize: 14,
            color: LavelleTheme.of(ctx).subText,
          ),
          const SizedBox(height: LavelleSpacing.xl),
          LavelleButton(
            title: ctx.l10n.login,
            icon: Icons.arrow_forward_rounded,
            onTap: () {
              Navigator.pop(ctx);
              navigator.pushNamed(LoginView.routeName);
            },
          ),
          const SizedBox(height: LavelleSpacing.md),
          LavelleButton(
            title: ctx.l10n.create_new_account,
            variant: LavelleButtonVariant.secondary,
            onTap: () {
              Navigator.pop(ctx);
              navigator.pushNamed(_registerRoute);
            },
          ),
          const SizedBox(height: LavelleSpacing.sm),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: MainText(
                ctx.l10n.not_now,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: LavelleTheme.of(ctx).subText,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  return false;
}

/// شاشة كاملة للضيف داخل تبويب يحتاج حساباً (مثل طلباتي)
class LavelleGuestGate extends StatelessWidget {
  final IconData icon;
  final String? message;

  const LavelleGuestGate({
    super.key,
    this.icon = Icons.lock_outline_rounded,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return LavelleStateView(
      icon: icon,
      title: context.l10n.guest_gate_title,
      message: message ?? context.l10n.guest_gate_message,
      actionLabel: context.l10n.login,
      onAction: () => Navigator.pushNamed(context, LoginView.routeName),
    );
  }
}
