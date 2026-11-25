import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_text.dart';

const Duration _toastDuration = Duration(seconds: 3);

void showAssessmentToast(
  BuildContext context,
  String message, {
  Color? color,
}) {
  final overlayEntry = OverlayEntry(
    builder: (context) => _AssessmentToastWidget(
      context: context,
      message: message,
      color: color,
    ),
  );

  Overlay.of(context).insert(overlayEntry);
  Future.delayed(_toastDuration, () {
    overlayEntry.remove();
  });

  HapticFeedback.lightImpact();
}

class _AssessmentToastWidget extends StatelessWidget {
  final BuildContext context;
  final String message;
  final Color? color;

  const _AssessmentToastWidget({
    required this.context,
    required this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color ?? Colors.orange.shade800,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MainText(
                  message,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // (اختياري) زر إغلاق سريع
              GestureDetector(
                onTap: () {
                  // إزالة الـ Overlay يدوياً إذا ضغط المستخدم على زر الإغلاق
                  // ملاحظة: OverlayEntry غير متاح هنا مباشرة، يجب استدعاء دالة إزالة
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.close, color: Colors.white70, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
