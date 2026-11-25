import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../app_responsive.dart';

/// ✅ ألوان الشيمر - ديناميكية حسب الوضع
class ShimmerColors {
  // ألوان الوضع الفاتح
  static const Color lightBase = Color(0xFFE0E0E0);
  static const Color lightHighlight = Color(0xFFF5F5F5);
  static const Color lightCardBackground = Colors.white;
  static const Color lightShadow = Colors.black;

  // ألوان الوضع الليلي
  static const Color darkBase = Color(0xFF3A3A3A);
  static const Color darkHighlight = Color(0xFF5A5A5A);
  static const Color darkCardBackground = Color(0xFF2C2C2C);
  static const Color darkShadow = Colors.black;

  // الحصول على الألوان حسب السياق
  static Color baseColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBase : lightBase;

  static Color highlightColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkHighlight
      : lightHighlight;

  static Color cardBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkCardBackground
      : lightCardBackground;

  static Color shadowColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkShadow
      : lightShadow;
}

/// ✅ Shimmer Wrapper محسّن مع دعم الوضع الليلي
class _GlossyShimmer extends StatelessWidget {
  final Widget child;

  const _GlossyShimmer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ShimmerColors.baseColor(context),
      highlightColor: ShimmerColors.highlightColor(context),
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

/// ✅ Helper: Rounded Rectangle - دعم الوضع الليلي
Widget _shimmerRect({
  required BuildContext context,
  required double width,
  required double height,
  double radius = 8,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: ShimmerColors.baseColor(context),
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

/// ✅ Helper: Circle - دعم الوضع الليلي
Widget _shimmerCircle({required BuildContext context, required double size}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: ShimmerColors.baseColor(context),
      shape: BoxShape.circle,
    ),
  );
}

class StudentProfileScreenShimmer extends StatelessWidget {
  const StudentProfileScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return const StudentProfileScreenTabletShimmer();
        }
        return const StudentProfileScreenMobileShimmer();
      },
    );
  }
}

class StudentProfileScreenMobileShimmer extends StatelessWidget {
  const StudentProfileScreenMobileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.transparent,
      body: SafeArea(
        child: _GlossyShimmer(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Shimmer
                const _HeaderShimmer(),

                const SizedBox(height: 8),

                // 2. Profile Card Shimmer
                const _ProfileCardShimmer(),

                // 3. Menu List Shimmer
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16,
                    top: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerRect(
                        context: context,
                        width: 60,
                        height: 16,
                      ), // "List" Title
                      const SizedBox(height: 12),

                      // Menu Items with full details
                      const _MenuItemShimmer(),
                      const _MenuItemShimmer(),
                      const _MenuItemShimmer(),
                      const _MenuItemShimmer(),
                      const _MenuItemShimmer(),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 4. Footer
                Center(
                  child: Column(
                    children: [
                      _shimmerRect(context: context, width: 120, height: 10),
                      const SizedBox(height: 6),
                      _shimmerRect(context: context, width: 80, height: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StudentProfileScreenTabletShimmer extends StatelessWidget {
  const StudentProfileScreenTabletShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : null,
      body: _GlossyShimmer(
        child: Row(
          children: [
            // Left Panel Shimmer
            Expanded(
              flex: AppResponsive.getFontSize(
                context,
                mobile: 0,
                smallTablet: 42,
                largeTablet: 35,
              ).toInt(),
              child: Container(
                color: ShimmerColors.baseColor(context).withValues(alpha: 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _shimmerCircle(context: context, size: 140),
                    const SizedBox(height: 24),
                    _shimmerRect(context: context, width: 200, height: 32),
                    const SizedBox(height: 8),
                    _shimmerRect(context: context, width: 150, height: 22),
                    const SizedBox(height: 32),
                    _shimmerRect(
                      context: context,
                      width: 220,
                      height: 48,
                      radius: 16,
                    ),
                  ],
                ),
              ),
            ),
            // Right Panel Shimmer
            Expanded(
              flex: AppResponsive.getFontSize(
                context,
                mobile: 100,
                smallTablet: 58,
                largeTablet: 65,
              ).toInt(),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerRect(context: context, width: 80, height: 28),
                    const SizedBox(height: 32),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: 6,
                        itemBuilder: (context, index) =>
                            const _TabletMenuItemShimmer(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabletMenuItemShimmer extends StatelessWidget {
  const _TabletMenuItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: ShimmerColors.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ShimmerColors.shadowColor(context).withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _shimmerRect(context: context, width: 56, height: 56, radius: 16),
          const SizedBox(width: 24),
          Expanded(
            child: _shimmerRect(context: context, width: 100, height: 18),
          ),
          const SizedBox(width: 8),
          _shimmerRect(context: context, width: 28, height: 28, radius: 12),
        ],
      ),
    );
  }
}

class _HeaderShimmer extends StatelessWidget {
  const _HeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _shimmerCircle(context: context, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerRect(context: context, width: 100, height: 12),
                const SizedBox(height: 6),
                _shimmerRect(context: context, width: 180, height: 16),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _shimmerCircle(context: context, size: 45),
        ],
      ),
    );
  }
}

class _ProfileCardShimmer extends StatelessWidget {
  const _ProfileCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ShimmerColors.cardBackground(context),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ShimmerColors.shadowColor(context).withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              _shimmerCircle(context: context, size: 90),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerRect(
                      context: context,
                      width: 150,
                      height: 20,
                    ), // Name
                    const SizedBox(height: 8),
                    _shimmerRect(
                      context: context,
                      width: 100,
                      height: 12,
                    ), // Email
                  ],
                ),
              ),

              // Edit Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ShimmerColors.baseColor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats Row
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: ShimmerColors.baseColor(context).withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(context),
                _divider(context),
                _statItem(context),
                _divider(context),
                _statItem(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(BuildContext context) {
    return Column(
      children: [
        // Icon Container (Matches real UI size ~40)
        _shimmerRect(context: context, width: 40, height: 40, radius: 12),
        const SizedBox(height: 6),
        // Value
        _shimmerRect(context: context, width: 30, height: 14),
        const SizedBox(height: 4),
        // Label (Added this back to match real details)
        _shimmerRect(context: context, width: 50, height: 10),
      ],
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: ShimmerColors.baseColor(context).withValues(alpha: 0.3),
    );
  }
}

class _MenuItemShimmer extends StatelessWidget {
  const _MenuItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ShimmerColors.cardBackground(context),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ShimmerColors.shadowColor(context).withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Box
          _shimmerRect(context: context, width: 46, height: 46, radius: 12),
          const SizedBox(width: 16),

          // Title & Subtitle (Restored details as they were)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerRect(context: context, width: 140, height: 16), // Title
                const SizedBox(height: 8),
                _shimmerRect(
                  context: context,
                  width: 90,
                  height: 12,
                ), // Subtitle/Details
              ],
            ),
          ),
          const SizedBox(width: 30),
          // Trailing Arrow Box
          _shimmerRect(context: context, width: 28, height: 28, radius: 8),
        ],
      ),
    );
  }
}
