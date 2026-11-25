// lib/core/widgets/custom_toast.dart
import 'package:flutter/material.dart';

class CustomToast {
  static OverlayEntry? _currentOverlay;

  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
    ToastPosition position = ToastPosition.bottom,
  }) {
    // إزالة الـ Toast السابق إذا وجد
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlayState = Overlay.of(context);
    final renderObject = context.findRenderObject();
    final offset = renderObject is RenderBox
        ? renderObject.localToGlobal(Offset.zero)
        : Offset.zero;

    final entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        type: type,
        position: position,
        offset: offset,
        onDismiss: () {
          _currentOverlay?.remove();
          _currentOverlay = null;
        },
      ),
    );

    _currentOverlay = entry;
    overlayState.insert(entry);

    // إخفاء الـ Toast تلقائيًا بعد المدة المحددة
    Future.delayed(duration, () {
      entry.remove();
      if (_currentOverlay == entry) {
        _currentOverlay = null;
      }
    });
  }
}

enum ToastType { success, error, warning, info }

enum ToastPosition { top, bottom, center }

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final ToastPosition position;
  final Offset offset;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.position,
    required this.offset,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.red;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.info:
        return Colors.blue;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
      case ToastType.warning:
        return Icons.warning_amber_outlined;
      case ToastType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    double? top;
    double? bottom;

    if (widget.position == ToastPosition.top) {
      top = (topPadding > 0 ? topPadding : 44) + 20;
    } else if (widget.position == ToastPosition.bottom) {
      bottom = (bottomPadding > 0 ? bottomPadding : 20) + 20;
    } else {
      top = screenSize.height / 2 - 40;
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: 0,
      right: 0,
      child: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                _controller.reverse().then((_) {
                  widget.onDismiss();
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getIcon(), color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// دالة مساعدة للاستخدام السهل
extension CustomToastExtension on BuildContext {
  void showToast({
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
    ToastPosition position = ToastPosition.bottom,
  }) {
    CustomToast.show(
      context: this,
      message: message,
      type: type,
      duration: duration,
      position: position,
    );
  }
}
