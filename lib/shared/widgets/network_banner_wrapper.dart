import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../core/di/dependency_injector.dart';
import '../../../core/style/app_colors.dart';
import '../../l10n/l10n.dart';
import 'main_text.dart';

class NetworkBannerWrapper extends StatefulWidget {
  final Widget child;

  const NetworkBannerWrapper({super.key, required this.child});

  @override
  State<NetworkBannerWrapper> createState() => _NetworkBannerWrapperState();
}

class _NetworkBannerWrapperState extends State<NetworkBannerWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  InternetStatus? _previousStatus;
  bool _showConnectedBanner = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleStatus(InternetStatus status) {
    if (status == _previousStatus) return;

    if (status == InternetStatus.disconnected) {
      _showConnectedBanner = false;
      _animController.forward();
    } else if (_previousStatus == InternetStatus.disconnected) {
      // جه من disconnected → connected: اعرض البانر الأخضر ثم اخفيه
      _showConnectedBanner = true;
      _animController.forward();
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) _animController.reverse();
      });
    }

    _previousStatus = status;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        StreamBuilder<InternetStatus>(
          stream: DependencyInjector.networkService.onStatusChange,
          builder: (context, snapshot) {
            final status = snapshot.data;
            if (status != null) _handleStatus(status);

            final isDisconnected = status == InternetStatus.disconnected;
            final isConnected = _showConnectedBanner && !isDisconnected;

            if (!isDisconnected && !isConnected) {
              return const SizedBox.shrink();
            }

            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _BannerContent(isConnected: isConnected),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Banner UI — نفس شكل dashboard error banner بس dynamic
// ─────────────────────────────────────────────────────────────
class _BannerContent extends StatelessWidget {
  const _BannerContent({required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final Color baseColor =
        isConnected ? MyColors.success500 : MyColors.customRed;
    final Color bgColor = isConnected ? MyColors.success50 : MyColors.error100;
    final Color borderColor = isConnected
        ? MyColors.success500.withValues(alpha: 0.35)
        : MyColors.customRed.withValues(alpha: 0.35);
    final IconData icon =
        isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded;

    // نص مناسب لكل حالة
    final String displayLabel =
        isConnected ? 'Back online' : context.l10n.no_internet_connection_bar;

    return SafeArea(
      bottom: false,
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: baseColor.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              spacing: 10,
              children: [
                // أيقونة في دائرة صغيرة
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: baseColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: baseColor, size: 16),
                ),
                // النص
                Expanded(
                  child: MainText(
                    displayLabel,
                    fontSize: 12,
                    color: baseColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // نقطة الحالة (pulse dot)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: baseColor.withValues(alpha: 0.4),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
