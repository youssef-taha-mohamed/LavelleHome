import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/extension/extension_helper.dart';
import '../../core/style/app_colors.dart';
import '../../feature/cart/presentation/provider/provider.dart';
import 'main_text.dart';

class FloatingCartButton extends StatefulWidget {
  const FloatingCartButton({
    super.key,
    required this.onPressed,
    this.margin = const EdgeInsets.all(16),
    this.showWhenEmpty = false,
    this.enableAddedBanner = true,
  });

  final VoidCallback onPressed;
  final EdgeInsetsGeometry margin;
  final bool showWhenEmpty;
  final bool enableAddedBanner;

  @override
  State<FloatingCartButton> createState() => _FloatingCartButtonState();
}

class _FloatingCartButtonState extends State<FloatingCartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  int _lastCount = 0;
  bool _showBanner = false;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pulseAnimation = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _onCountChanged(int count) {
    if (count > _lastCount) {
      _pulseController.forward(from: 0);
      if (widget.enableAddedBanner) {
        _showAddedBanner();
      }
    }
    _lastCount = count;
  }

  void _showAddedBanner() {
    _bannerTimer?.cancel();
    setState(() => _showBanner = true);
    _bannerTimer = Timer(const Duration(milliseconds: 1700), () {
      if (mounted) setState(() => _showBanner = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<CartProvider, int>(
      selector: (context, provider) => provider.cartInfo?.count ?? 0,
      builder: (context, count, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _onCountChanged(count);
        });

        if (!widget.showWhenEmpty && count == 0) {
          return const SizedBox.shrink();
        }

        final isDark = context.isDark;

        return Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Padding(
            padding: widget.margin,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: InkWell(
                    onTap: widget.onPressed,
                    customBorder: const CircleBorder(),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: MyColors.primaryColor.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.primaryColor.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_cart_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
                if (count > 0)
                  PositionedDirectional(
                    top: -6,
                    end: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: MainText(
                        '$count',
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (_showBanner)
                  PositionedDirectional(
                    end: 0,
                    bottom: 58,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _showBanner ? 1 : 0,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 200),
                        offset:
                            _showBanner ? Offset.zero : const Offset(0, 0.2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: MyColors.green
                                .withValues(alpha: isDark ? 0.9 : 1),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: MyColors.green.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              MainText(
                                'تمت الإضافة للسلة',
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
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
      },
    );
  }
}
