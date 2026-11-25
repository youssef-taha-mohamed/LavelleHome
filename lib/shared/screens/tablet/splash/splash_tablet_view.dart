import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/style/app_colors.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/custom_background.dart';
import '../../../widgets/jumping_dots_progress_indicator.dart';

class SplashTabletView extends StatelessWidget {
  const SplashTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Premium Background with Islamic patterns
          EnhancedIslamicBackground(
            primaryColor: MyColors.darkGreen,
            secondaryColor: MyColors.islamicGold,
            opacity: 0.15,
          ),

          // 2. Animated Floating Decorative Elements
          _buildFloatingElements(),

          // 3. Central Glassmorphism Hero Section
          Center(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Section
                  const Hero(
                    tag: 'app_logo_tablet',
                    child: AppLogo(),
                  ),
                  const SizedBox(height: 40),

                  // Lottie Loading Animation
                  SizedBox(
                    height: 120,
                    child: Lottie.asset(
                      'assets/animation/Book loading.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(40),
              //   child: BackdropFilter(
              //     filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 10,
              //         vertical: 80,
              //       ),
              //       decoration: BoxDecoration(
              //         color: Colors.white.withValues(alpha: 0.1),
              //         borderRadius: BorderRadius.circular(40),
              //         border: Border.all(
              //           color: Colors.white.withValues(alpha: 0.2),
              //           width: 1.5,
              //         ),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black.withValues(alpha: 0.1),
              //             blurRadius: 30,
              //             spreadRadius: 5,
              //           ),
              //         ],
              //       ),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           // Logo Section
              //           const Hero(
              //             tag: 'app_logo_tablet',
              //             child: AppLogo(),
              //           ),
              //           const SizedBox(height: 40),

              //           // Lottie Loading Animation
              //           SizedBox(
              //             height: 120,
              //             child: Lottie.asset(
              //               'assets/animation/Book loading.json',
              //               fit: BoxFit.contain,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ),

          // 4. Elegant Progress Indicator at Bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const JumpingDotsProgressIndicator(
                  color: MyColors.islamicGold,
                  dotSpacing: 4,
                  milliseconds: 150,
                  numberOfDots: 4,
                ),
                const SizedBox(height: 16),
                Text(
                  'أهلاً بكم في كنوز',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: MyColors.islamicGold.withValues(alpha: 0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Stack(
      children: List.generate(6, (index) {
        final random = index * 0.15;
        return _FloatingElement(
          delay: Duration(milliseconds: (index * 500).toInt()),
          offset: Offset(
            (index % 2 == 0 ? 50 : 800) + (random * 100),
            (index < 3 ? 100 : 600) + (random * 200),
          ),
        );
      }),
    );
  }
}

class _FloatingElement extends StatefulWidget {
  final Offset offset;
  final Duration delay;

  const _FloatingElement({
    required this.offset,
    required this.delay,
  });

  @override
  State<_FloatingElement> createState() => _FloatingElementState();
}

class _FloatingElementState extends State<_FloatingElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });

    _animation = Tween<Offset>(
      begin: widget.offset,
      end: widget.offset.translate(0, 30),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _animation.value.dx,
          top: _animation.value.dy,
          child: Opacity(
            opacity: 0.1,
            child: Icon(
              Icons.star_border_outlined, // Placeholder for geometric icon
              size: 40,
              color: MyColors.islamicGold,
            ),
          ),
        );
      },
    );
  }
}
