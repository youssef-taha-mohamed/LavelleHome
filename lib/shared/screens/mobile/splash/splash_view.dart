import 'dart:async';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'dart:developer' as dev;
import '../../../../core/db/kv_db/hive.dart';
import '../../../../core/service/deep_link_service.dart';
import '../../../../core/utils/notification/notification.dart';
import '../../../../core/utils/styles_link.dart';
import '../../../../feature/auth/presentation/login/view/login.dart';
import '../../../../feature/force_update/presentation/force_update_screen.dart';
import '../../../../feature/botttom_nav_bar/nav_bar.dart';
import '../../../view_model/splash_view_model.dart';
import '../../../view_model/state.dart';
import '../../../widgets/shared_widgets.dart';
import '../../desktop/splash/splash_desktop_view.dart';
import '../closed_app/closed_app_screen.dart';
import '../../tablet/splash/splash_tablet_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final _viewModel = const SplashScreenViewModel();

  // Controllers: دخول متتابع + نبض هادئ للهالة + فقاعات صاعدة
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final AnimationController _bubblesController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _contentFade;
  late final Animation<double> _indicatorFade;
  late final Animation<double> _haloPulse;

  // مرحلة التحميل (0..3) بدل نص ثابت، لعرض رسالة مترجمة
  int _stage = 0;
  double _progressValue = 0.15;

  String _loadingMessage(BuildContext context) {
    switch (_stage) {
      case 0:
        return context.l10n.splash_loading;
      case 1:
        return context.l10n.splash_checking_app;
      case 2:
        return context.l10n.splash_preparing;
      default:
        return context.l10n.splash_welcome;
    }
  }

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _entranceController.forward();
    _initializeApp();
  }

  void _initAnimations() {
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
          ),
        );
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.85, curve: Curves.easeIn),
      ),
    );
    _indicatorFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
      ),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(reverse: true);
    _haloPulse = Tween<double>(begin: 0.95, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _bubblesController = AnimationController(
      duration: const Duration(seconds: 14),
      vsync: this,
    )..repeat();
  }

  // ───────────────────────── منطق التهيئة (بدون تغيير) ─────────────────────────

  Future<void> _initializeApp() async {
    try {
      if (mounted) {
        setState(() {
          _progressValue = 0.35;
          _stage = 1;
        });
      }
      await Future.delayed(const Duration(milliseconds: 500));

      final state = await _viewModel.init();
      debugPrint(
        "Hive Initial Notification = ${HiveDatabase.getInitialNotification()}",
      );
      final user = AuthenticationProvider.instance.currentUser?.details;

      if (!mounted) return;

      setState(() {
        _progressValue = 0.70;
        _stage = 2;
      });
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      setState(() {
        _progressValue = 1.0;
        _stage = 3;
      });
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;
      debugPrint('Splash State: $state');
      await _handleNavigation(state, user);
    } on DioException catch (e) {
      dev.log(
        'SplashScreen: Caught DioException. Interceptor should have navigated to login. $e',
      );
      if (mounted) {
        await Navigator.pushNamedAndRemoveUntil(
          context,
          LoginView.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      dev.log('SplashScreen: Caught unexpected error during init: $e');
      if (mounted) {
        await Navigator.pushNamedAndRemoveUntil(
          context,
          LoginView.routeName,
          (route) => false,
        );
      }
    }
  }

  Future<void> _handleNavigation(SplashState state, dynamic user) async {
    switch (state) {
      case SplashState.closedApp:
        await Navigator.pushNamedAndRemoveUntil(
          context,
          ClosedAppScreen.routeName,
          (route) => false,
        );
        break;
      case SplashState.notOpenedAppBefore:
      case SplashState.notLoggedIn:
        await Navigator.pushNamedAndRemoveUntil(
          context,
          LoginView.routeName,
          (route) => false,
        );
        break;

      case SplashState.loggedIn:
        await Navigator.pushNamedAndRemoveUntil(
          context,
          BottomNavBar.routeName,
          (route) => false,
        );
        break;

      case SplashState.complete:
        await Navigator.pushNamedAndRemoveUntil(
          context,
          BottomNavBar.routeName,
          (route) => false,
        );
        break;

      case SplashState.phoneNotVerified:
        await Navigator.pushNamedAndRemoveUntil(
          context,
          LoginView.routeName,
          (route) => false,
        );
        break;

      case SplashState.forceUpdate:
        await Navigator.pushNamedAndRemoveUntil(
          context,
          ForceUpdateScreen.routeName,
          (route) => false,
        );
        break;
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      NotificationUtils.processPendingNotification();
      DeepLinkService.processPendingDeepLink();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _bubblesController.dispose();
    super.dispose();
  }

  // ───────────────────────── الواجهة ─────────────────────────

  @override
  Widget build(BuildContext context) {
    final category = AppResponsive.getCategory(context);
    final isTablet =
        category == DeviceCategory.smallTablet ||
        category == DeviceCategory.largeTablet;

    if (category == DeviceCategory.desktop) {
      return SplashDesktopView(
        progressValue: _progressValue,
        loadingMessage: _loadingMessage(context),
      );
    }

    if (isTablet) {
      return const SplashTabletView();
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية الكحلية المتدرجة
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.25),
                radius: 1.15,
                colors: [
                  MyColors.primaryContainer,
                  MyColors.primaryColor,
                  MyColors.deepBlue,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // موجة شفافة أسفل الشاشة
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 260,
            child: IgnorePointer(
              child: ClipPath(
                clipper: _BottomWaveClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.07),
                        Colors.white.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // فقاعات صاعدة بهدوء
          Positioned.fill(
            child: IgnorePointer(
              child: _FloatingBubbles(animation: _bubblesController),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 4),
                  _buildLogo(),
                  const SizedBox(height: 30),
                  _buildBranding(context),
                  const Spacer(flex: 4),
                  _buildLoadingSection(context),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// الشعار: هالة سماوية تنبض + إطار ذهبي رفيع + دائرة بيضاء
  Widget _buildLogo() {
    return FadeTransition(
      opacity: _logoFade,
      child: ScaleTransition(
        scale: _logoScale,
        child: AnimatedBuilder(
          animation: _haloPulse,
          builder: (context, child) =>
              Transform.scale(scale: _haloPulse.value, child: child),
          child: GestureDetector(
            // اختصار المطوّر (ضغطة مطوّلة)
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeveloperAuthScreen(),
                ),
              );
            },
            child: Container(
              width: 196,
              height: 196,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    MyColors.skyBlue.withValues(alpha: 0.38),
                    MyColors.skyBlue.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                  stops: const [0.5, 0.78, 1.0],
                ),
              ),
              child: Center(
                child: Container(
                  width: 148,
                  height: 148,
                  padding: const EdgeInsets.all(3.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        MyColors.goldAccent.withValues(alpha: 0.95),
                        MyColors.goldAccent.withValues(alpha: 0.3),
                        MyColors.goldAccent.withValues(alpha: 0.75),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.skyBlue.withValues(alpha: 0.3),
                        blurRadius: 32,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        'assets/images/image/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const AppLogo();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// اسم العلامة + الوصف بين خطين سماويين
  Widget _buildBranding(BuildContext context) {
    return SlideTransition(
      position: _contentSlide,
      child: FadeTransition(
        opacity: _contentFade,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MainText(
              'Lavelle',
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: MyColors.skyBlue.withValues(alpha: 0.45),
                  blurRadius: 18,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _accentLine(),
                const SizedBox(width: 10),
                Flexible(
                  child: MainText(
                    context.l10n.laundry_tagline,
                    textAlign: TextAlign.center,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
                ),
                const SizedBox(width: 10),
                _accentLine(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _accentLine() => Container(
    width: 22,
    height: 1.5,
    decoration: BoxDecoration(
      color: MyColors.goldAccent,
      borderRadius: BorderRadius.circular(2),
    ),
  );

  /// شريط تقدّم ناعم + رسالة الحالة
  Widget _buildLoadingSection(BuildContext context) {
    return FadeTransition(
      opacity: _indicatorFade,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 190,
            height: 4,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: _progressValue),
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FractionallySizedBox(
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [MyColors.skyBlue, Colors.white],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.skyBlue.withValues(alpha: 0.6),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.2),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Row(
              key: ValueKey<int>(_stage),
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 38,
                  height: 14,
                  child: JumpingDotsProgressIndicator(
                    color: MyColors.skyBlue,
                    dotSpacing: 2,
                    milliseconds: 120,
                    numberOfDots: 3,
                  ),
                ),
                const SizedBox(width: 6),
                MainText(
                  _loadingMessage(context),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.82),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// Private helpers
// ═════════════════════════════════════════════════════════════

class _BubbleSpec {
  final double x; // موضع أفقي نسبي 0..1
  final double size;
  final int speed; // عدد صحيح ليكون التكرار سلساً
  final double phase;
  final double alpha;

  const _BubbleSpec(this.x, this.size, this.speed, this.phase, this.alpha);
}

/// فقاعات صابون تصعد ببطء (فكرة الغسيل) بدون أي صور
class _FloatingBubbles extends StatelessWidget {
  final Animation<double> animation;

  const _FloatingBubbles({required this.animation});

  static const List<_BubbleSpec> _specs = [
    _BubbleSpec(0.10, 26, 1, 0.00, 0.16),
    _BubbleSpec(0.24, 12, 2, 0.35, 0.20),
    _BubbleSpec(0.38, 36, 1, 0.62, 0.12),
    _BubbleSpec(0.52, 16, 2, 0.10, 0.18),
    _BubbleSpec(0.66, 24, 1, 0.80, 0.15),
    _BubbleSpec(0.78, 10, 2, 0.55, 0.22),
    _BubbleSpec(0.88, 32, 1, 0.28, 0.12),
    _BubbleSpec(0.45, 8, 2, 0.90, 0.20),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return Stack(
              children: [
                for (final b in _specs)
                  Builder(
                    builder: (context) {
                      final p = (animation.value * b.speed + b.phase) % 1.0;
                      final fade = math.sin(p * math.pi);
                      return Positioned(
                        left: b.x * w - b.size / 2,
                        top: h - p * (h + b.size),
                        child: Container(
                          width: b.size,
                          height: b.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(
                              alpha: b.alpha * 0.5 * fade,
                            ),
                            border: Border.all(
                              color: MyColors.skyBlue.withValues(
                                alpha: (b.alpha + 0.1) * fade,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 60)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.55, 36)
      ..quadraticBezierTo(size.width * 0.85, 72, size.width, 28)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
