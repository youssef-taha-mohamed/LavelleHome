import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/resources/images.dart';
import '../../../../core/style/app_colors.dart';
import '../../../widgets/main_text.dart';
import '../switch_mode/developer_desktop_screen.dart';

/// Desktop & Web specific Splash Screen for Tiba Academy.
///
/// Features:
/// - True fullscreen responsive web adaptation with zero overflow or overlap.
/// - Rich Islamic Academic identity: Celestial Navy, Islamic Gold, and Emerald accents.
/// - Interactive Islamic sacred geometry particle and constellation background.
/// - Glassmorphic hero console with adaptive scaling across any monitor resolution.
/// - Real-time animated progress telemetry with smooth fallbacks.
/// - Integrated web telemetry bar and direct developer mode shortcut.
class SplashDesktopView extends StatefulWidget {
  final double? progressValue;
  final String loadingMessage;

  const SplashDesktopView({
    super.key,
    this.progressValue,
    this.loadingMessage = 'جاري التحميل...',
  });

  @override
  State<SplashDesktopView> createState() => _SplashDesktopViewState();
}

class _SplashDesktopViewState extends State<SplashDesktopView>
    with TickerProviderStateMixin {
  late final AnimationController _ambientController;
  late final AnimationController _glowController;
  late final AnimationController _shimmerController;
  late final AnimationController _internalProgressController;

  late final Animation<double> _glowAnimation;
  late final Animation<double> _floatAnimation;
  late final Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Ambient breathing & floating controller
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _ambientController, curve: Curves.easeInOutSine),
    );

    // 2. Radial glow expansion controller
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // 3. Shimmer highlight sweep for the progress bar
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    // 4. Internal smooth autonomous progress simulation (used if progressValue is null/0)
    _internalProgressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _glowController.dispose();
    _shimmerController.dispose();
    _internalProgressController.dispose();
    super.dispose();
  }

  void _openDeveloperScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DeveloperDesktopScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isArabic = context.isArabic;

    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      body: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── 1. Celestial Dark Islamic Gradient ──
            _buildBaseGradient(),

            // ── 2. Glowing Ambient Lighting Orbs (Gold & Emerald & Indigo) ──
            _buildAmbientLights(size),

            // ── 3. Islamic Sacred Geometry & Constellation Grid ──
            AnimatedBuilder(
              animation: _ambientController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _IslamicGeometryPainter(
                    animationValue: _ambientController.value,
                    goldColor: MyColors.islamicGold,
                    tealColor: MyColors.primaryColor,
                  ),
                );
              },
            ),

            // ── 4. Main Responsive Web Layout ──
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isShortHeight = constraints.maxHeight < 720;
                  final isCompactWidth = constraints.maxWidth < 900;

                  return Column(
                    children: [
                      // Top Web Navigation Bar
                      _buildTopWebBar(
                        context,
                        isCompact: isCompactWidth,
                      ),

                      // Central Hero Console
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: isCompactWidth ? 20 : 36,
                              vertical: isShortHeight ? 12 : 24,
                            ),
                            child: _buildCenterConsole(
                              context,
                              constraints: constraints,
                              isShortHeight: isShortHeight,
                              isCompactWidth: isCompactWidth,
                            ),
                          ),
                        ),
                      ),

                      // Web Bottom Footer
                      _buildWebFooter(
                        context,
                        isCompact: isCompactWidth,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Base Deep Celestial Navy Background
  Widget _buildBaseGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.0, -0.25),
          radius: 1.35,
          colors: [
            Color(0xFF131F38), // Rich illuminated midnight indigo
            Color(0xFF0C1424), // Deep academic royal navy
            Color(0xFF060912), // Pitch obsidian base
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
    );
  }

  /// Ambient Glowing Lights in the background
  Widget _buildAmbientLights(Size size) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        final glow = _glowAnimation.value;
        return Stack(
          children: [
            // Top-Right Islamic Gold Glow Aura
            Positioned(
              top: -size.height * 0.12,
              right: -size.width * 0.08,
              child: Container(
                width: size.width * 0.42,
                height: size.width * 0.42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.islamicGold.withValues(alpha: 0.10 * glow),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 140, sigmaY: 140),
                  child: const SizedBox.expand(),
                ),
              ),
            ),

            // Bottom-Left Royal Teal Glow Aura
            Positioned(
              bottom: -size.height * 0.14,
              left: -size.width * 0.08,
              child: Container(
                width: size.width * 0.45,
                height: size.width * 0.45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.primaryColor.withValues(alpha: 0.18 * glow),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 150, sigmaY: 150),
                  child: const SizedBox.expand(),
                ),
              ),
            ),

            // Center Halo behind the console
            Center(
              child: Container(
                width: 780,
                height: 480,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(300),
                  color: MyColors.darkPrimaryLight.withValues(
                    alpha: 0.12 * glow,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 160, sigmaY: 160),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Top Web Navigation Bar
  Widget _buildTopWebBar(
    BuildContext context, {
    required bool isCompact,
  }) {
    final isArabic = context.isArabic;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 44,
        vertical: 18,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Brand Identity Mini Pill ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: MyColors.islamicGold,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.islamicGold.withValues(alpha: 0.7),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                MainText(
                  isArabic
                      ? 'أكاديمية طيبة • المنظومة السحابية'
                      : 'Tiba Academy • Cloud System',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: MyColors.white.withValues(alpha: 0.9),
                ),
              ],
            ),
          ),

          // ── Right/Left Telemetry & Developer Quick Action ──
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              // Cloud Status Pill (Hidden on very compact screens)
              if (!isCompact)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 7,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: MyColors.appGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: MyColors.appGreen.withValues(alpha: 0.7),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      MainText(
                        isArabic ? 'الخادم: متصل ومستقر' : 'Server: Online',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: MyColors.white.withValues(alpha: 0.85),
                      ),
                    ],
                  ),
                ),

              // Security 256-Bit SSL Pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: MyColors.islamicGold,
                    ),
                    MainText(
                      isArabic ? 'تشفير 256-Bit SSL' : '256-Bit SSL',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: MyColors.white.withValues(alpha: 0.85),
                    ),
                  ],
                ),
              ),

              // Quick Developer Trigger Button
              Tooltip(
                message: isArabic ? 'إعدادات المطور' : 'Developer Settings',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _openDeveloperScreen,
                    borderRadius: BorderRadius.circular(24),
                    hoverColor: MyColors.islamicGold.withValues(alpha: 0.15),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: const Icon(
                        Icons.settings_suggest_rounded,
                        size: 16,
                        color: MyColors.islamicGold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Main Central Hero Glassmorphic Console
  Widget _buildCenterConsole(
    BuildContext context, {
    required BoxConstraints constraints,
    required bool isShortHeight,
    required bool isCompactWidth,
  }) {
    final double cardMaxWidth = constraints.maxWidth > 950 ? 760 : 660;

    return AnimatedBuilder(
      animation: _ambientController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            constraints: BoxConstraints(maxWidth: cardMaxWidth),
            padding: EdgeInsets.symmetric(
              horizontal: isCompactWidth ? 28 : 48,
              vertical: isShortHeight ? 26 : 40,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1A2C).withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.14),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 60,
                  offset: const Offset(0, 24),
                  spreadRadius: 6,
                ),
                BoxShadow(
                  color: MyColors.primaryColor.withValues(alpha: 0.20),
                  blurRadius: 36,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: MyColors.islamicGold.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative Gold Corner Flairs
                _buildCornerFlairs(),

                // Main Content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Portal Badge
                    _buildPortalBadge(context),

                    SizedBox(height: isShortHeight ? 18 : 28),

                    // Official Illuminated Logo with Halo
                    _buildHeroLogo(),

                    SizedBox(height: isShortHeight ? 16 : 22),

                    // App Platform Typography
                    _buildBrandTypography(context),

                    const SizedBox(height: 10),

                    // Quranic Tagline / Mission Motto
                    MainText(
                      context.isArabic
                          ? 'المنصة الرائدة في تعليم القرآن الكريم واللغة العربية والعلوم الشرعية'
                          : 'Premier Platform for Quran, Arabic & Islamic Studies',
                      fontSize: isShortHeight ? 13 : 14,
                      color: MyColors.white.withValues(alpha: 0.78),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),

                    SizedBox(height: isShortHeight ? 24 : 34),

                    // Real-time Loading & Shimmer Progress Bar
                    _buildLoadingTelemetry(context),

                    SizedBox(height: isShortHeight ? 22 : 30),

                    // Luxurious Islamic Geometric Divider
                    _buildOrnateDivider(),

                    SizedBox(height: isShortHeight ? 18 : 24),

                    // 4 Feature Pillars Grid (Responsive & Collision-Free)
                    _buildFeatureHighlights(context, isCompact: isCompactWidth),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Delicate gold corner flourishes for an authentic Islamic aesthetic
  Widget _buildCornerFlairs() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _CornerAccentsPainter(
            accentColor: MyColors.islamicGold.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }

  /// Portal Badge at top of console
  Widget _buildPortalBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.islamicGold.withValues(alpha: 0.22),
            MyColors.primaryColor.withValues(alpha: 0.22),
          ],
        ),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: MyColors.islamicGold.withValues(alpha: 0.45),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          const Icon(
            Icons.school_rounded,
            size: 15,
            color: MyColors.islamicGold,
          ),
          MainText(
            context.isArabic
                ? 'بوابة الطالب الأكاديمية • الإصدار السحابي'
                : 'Student Cloud Portal • Web Edition',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: MyColors.islamicGold,
          ),
        ],
      ),
    );
  }

  /// Official Logo with Breathing Halo and Developer Access
  Widget _buildHeroLogo() {
    return GestureDetector(
      onDoubleTap: _openDeveloperScreen,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Soft Golden Pulse Aura
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  MyColors.islamicGold.withValues(alpha: 0.30),
                  MyColors.primaryColor.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Rotating Subtle Golden Frame
          AnimatedBuilder(
            animation: _ambientController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _ambientController.value * 2 * math.pi,
                child: Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MyColors.islamicGold.withValues(alpha: 0.25),
                      width: 1.5,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
              );
            },
          ),

          // Central Disc with Official Logo
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  MyColors.darkPrimaryLight,
                  MyColors.primaryColor,
                  Color(0xFF1E1B4B),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: MyColors.primaryColor.withValues(alpha: 0.55),
                  blurRadius: 26,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: MyColors.islamicGold.withValues(alpha: 0.25),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  ImagesAssets.logo,
                  width: 68,
                  height: 68,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.auto_stories_rounded,
                      size: 44,
                      color: MyColors.islamicGold,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Academy Brand Title Typography
  Widget _buildBrandTypography(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            MainText(
              context.isArabic ? 'أكاديمية طـيـبـة' : 'TIBA ACADEMY',
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: MyColors.white,
              letterSpacing: context.isArabic ? 0.5 : 2.5,
            ),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: MyColors.islamicGold,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: MyColors.islamicGold.withValues(alpha: 0.8),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        MainText(
          context.isArabic
              ? 'TIBA SMART LEARNING PLATFORM'
              : 'المنصة الذكية لتعليم القرآن الكريم',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: MyColors.islamicGold.withValues(alpha: 0.9),
          letterSpacing: 2.0,
        ),
      ],
    );
  }

  /// Real-Time Telemetry Progress Bar with Smooth Shimmer
  Widget _buildLoadingTelemetry(BuildContext context) {
    // If progressValue is passed and valid (> 0), use it; otherwise use simulated smooth progress
    final double rawProgress = (widget.progressValue != null && widget.progressValue! > 0)
        ? widget.progressValue!
        : _internalProgressController.value;

    final double clampedProgress = rawProgress.clamp(0.08, 1.0);
    final int percentage = (clampedProgress * 100).toInt();

    return Column(
      children: [
        // Message & Live Counter Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Status with pulsing spinner
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        MyColors.islamicGold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: MainText(
                      widget.loadingMessage,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: MyColors.white.withValues(alpha: 0.92),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Percentage Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: MyColors.islamicGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: MyColors.islamicGold.withValues(alpha: 0.35),
                ),
              ),
              child: MainText(
                '$percentage%',
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: MyColors.islamicGold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Sleek Animated Progress Bar
        Stack(
          children: [
            // Background Track
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),

            // Animated Gradient Fill Bar with Shimmer Highlight
            LayoutBuilder(
              builder: (context, barConstraints) {
                final barWidth = barConstraints.maxWidth * clampedProgress;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  height: 8,
                  width: barWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        MyColors.islamicGold,
                        MyColors.primaryColor,
                        MyColors.appGreen,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.primaryColor.withValues(alpha: 0.7),
                        blurRadius: 12,
                        offset: const Offset(0, 1),
                      ),
                      BoxShadow(
                        color: MyColors.islamicGold.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _shimmerAnimation,
                    builder: (context, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Positioned(
                              left: barWidth * _shimmerAnimation.value,
                              top: 0,
                              bottom: 0,
                              width: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withValues(alpha: 0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Ornate Islamic Divider with Center Diamond Accent
  Widget _buildOrnateDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.22),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: MyColors.islamicGold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 4 Pillars of Tiba Academy (Responsive Grid / Row with ZERO collision)
  Widget _buildFeatureHighlights(
    BuildContext context, {
    required bool isCompact,
  }) {
    final isArabic = context.isArabic;

    final List<Map<String, dynamic>> features = [
      {
        'icon': Icons.menu_book_rounded,
        'title': isArabic ? 'حلقات قرآنية مباشرة' : 'Live Quran Halaqat',
      },
      {
        'icon': Icons.verified_user_rounded,
        'title': isArabic ? 'معلمون مجازون بالسند' : 'Certified Scholars',
      },
      {
        'icon': Icons.auto_stories_rounded,
        'title': isArabic ? 'مناهج تعليمية معتمدة' : 'Accredited Curricula',
      },
      {
        'icon': Icons.insights_rounded,
        'title': isArabic ? 'متابعة وتقييم دوري' : 'Smart Evaluation',
      },
    ];

    // If compact width, layout as 2x2 grid for optimal spacing and zero overflow
    if (isCompact) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFeaturePill(
                  icon: features[0]['icon'] as IconData,
                  title: features[0]['title'] as String,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildFeaturePill(
                  icon: features[1]['icon'] as IconData,
                  title: features[1]['title'] as String,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildFeaturePill(
                  icon: features[2]['icon'] as IconData,
                  title: features[2]['title'] as String,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildFeaturePill(
                  icon: features[3]['icon'] as IconData,
                  title: features[3]['title'] as String,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // On standard/wide desktop: 4 items in a single balanced row
    return Row(
      children: features.map((feature) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildFeaturePill(
              icon: feature['icon'] as IconData,
              title: feature['title'] as String,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeaturePill({
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7,
        children: [
          Icon(
            icon,
            size: 16,
            color: MyColors.islamicGold,
          ),
          Flexible(
            child: MainText(
              title,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: MyColors.white.withValues(alpha: 0.88),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  /// Web Bottom Footer
  Widget _buildWebFooter(
    BuildContext context, {
    required bool isCompact,
  }) {
    final isArabic = context.isArabic;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 44,
        vertical: 18,
      ),
      child: isCompact
          ? Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                MainText(
                  isArabic
                      ? '© جميع الحقوق محفوظة لأكاديمية طيبة'
                      : '© All Rights Reserved • Tiba Academy',
                  fontSize: 11,
                  color: MyColors.white.withValues(alpha: 0.45),
                  textAlign: TextAlign.center,
                ),
                MainText(
                  'TIBA WEB PLATFORM • v2.4.0',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: MyColors.white.withValues(alpha: 0.45),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(
                  isArabic
                      ? '© جميع الحقوق محفوظة لمنظومة أكاديمية طيبة للتعليم والتدريب'
                      : '© All Rights Reserved • Tiba Academy for Education',
                  fontSize: 12,
                  color: MyColors.white.withValues(alpha: 0.45),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: MyColors.appGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    MainText(
                      'TIBA WEB EDITION • v2.4.0 • NILE UNITED',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: MyColors.white.withValues(alpha: 0.45),
                      letterSpacing: 0.8,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

/// Custom painter for authentic Islamic 8-Point Stars, sacred geometry lines, and particles
class _IslamicGeometryPainter extends CustomPainter {
  final double animationValue;
  final Color goldColor;
  final Color tealColor;

  const _IslamicGeometryPainter({
    required this.animationValue,
    required this.goldColor,
    required this.tealColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()
      ..color = goldColor.withValues(alpha: 0.065)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..style = PaintingStyle.fill;

    const double step = 80.0;
    final int cols = (size.width / step).ceil() + 1;
    final int rows = (size.height / step).ceil() + 1;

    // Draw delicate grid dots
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        final double x = i * step;
        final double y = j * step;
        canvas.drawCircle(Offset(x, y), 1.2, dotPaint);

        // Periodically draw an Islamic 8-pointed star at grid intersections
        if ((i + j) % 4 == 0) {
          final double pulseOffset = math.sin(animationValue * 2 * math.pi + i) * 1.5;
          _draw8PointStar(canvas, Offset(x, y), 14.0 + pulseOffset, goldPaint);
        }
      }
    }
  }

  /// Draws a classic 8-pointed Islamic Star (Rub El Hizb geometry)
  void _draw8PointStar(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final path = Path();
    const int points = 8;
    const double stepAngle = math.pi / points;
    final double innerRadius = radius * 0.55;

    for (int i = 0; i < points * 2; i++) {
      final double r = (i % 2 == 0) ? radius : innerRadius;
      final double angle = i * stepAngle - (math.pi / 2);
      final double x = center.dx + r * math.cos(angle);
      final double y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _IslamicGeometryPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

/// Ornate Corner Accents for Glass Console (Islamic L-Brackets)
class _CornerAccentsPainter extends CustomPainter {
  final Color accentColor;

  const _CornerAccentsPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    const double length = 20.0;
    const double inset = 12.0;

    // Top-Left
    canvas.drawLine(
      const Offset(inset, inset),
      const Offset(inset + length, inset),
      paint,
    );
    canvas.drawLine(
      const Offset(inset, inset),
      const Offset(inset, inset + length),
      paint,
    );

    // Top-Right
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(size.width - inset - length, inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(size.width - inset, inset + length),
      paint,
    );

    // Bottom-Left
    canvas.drawLine(
      Offset(inset, size.height - inset),
      Offset(inset + length, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height - inset),
      Offset(inset, size.height - inset - length),
      paint,
    );

    // Bottom-Right
    canvas.drawLine(
      Offset(size.width - inset, size.height - inset),
      Offset(size.width - inset - length, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, size.height - inset),
      Offset(size.width - inset, size.height - inset - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerAccentsPainter oldDelegate) =>
      oldDelegate.accentColor != accentColor;
}
