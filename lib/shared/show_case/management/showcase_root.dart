import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../core/style/app_colors.dart';
import '../../../l10n/l10n.dart';
import 'showcase_helper.dart';

class ShowcaseRoot extends StatefulWidget {
  final Widget child;
  final bool enableAutoScroll;
  final bool disableBarrierInteraction;
  final double blurValue;

  const ShowcaseRoot({
    super.key,
    required this.child,
    this.enableAutoScroll = true,
    this.disableBarrierInteraction = true,
    this.blurValue = 8,
  });

  @override
  State<ShowcaseRoot> createState() => _ShowcaseRootState();
}

class _ShowcaseRootState extends State<ShowcaseRoot> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registerShowcase();
  }

  void _registerShowcase() {
    // تسجيل الإعدادات العالمية مرة واحدة لضمان ثبات الهوية البصرية (الأسود والذهبي)
    ShowcaseView.register(
      blurValue: widget.blurValue,
      autoPlay: false,
      enableAutoScroll: widget.enableAutoScroll,
      disableBarrierInteraction: widget.disableBarrierInteraction,
      globalTooltipActionConfig: const TooltipActionConfig(
        position: TooltipActionPosition.outside,
        alignment: MainAxisAlignment.spaceBetween,
        actionGap: 16,
        gapBetweenContentAndAction: 12,
      ),
      globalTooltipActions: [
        TooltipActionButton(
          type: TooltipDefaultActionType.previous,
          name: context.l10n.sh_prev,
          backgroundColor: Colors.transparent,
          textStyle: const TextStyle(
            color: MyColors.islamicGold,
            fontWeight: FontWeight.bold,
          ),
          onTap: () => ShowcaseView.get().previous(),
        ),
        TooltipActionButton(
          type: TooltipDefaultActionType.next,
          name: context.l10n.sh_next,
          backgroundColor: MyColors.islamicGold,
          textStyle: const TextStyle(
            color: MyColors.black,
            fontWeight: FontWeight.bold,
          ),
          onTap: () => ShowcaseView.get().next(),
        ),
      ],
      globalFloatingActionWidget: (context) => FloatingActionWidget(
        bottom: 16,
        right: 16,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 💨 زر التخطي المؤقت
            ElevatedButton(
              onPressed: () {
                ShowcaseController.skipActive();
                ShowcaseView.get().dismiss();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.black.withValues(alpha: 0.8),
                foregroundColor: MyColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.close_rounded, size: 16),
                  const SizedBox(width: 4),
                  Text(context.l10n.sh_skip),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 🛑 زر الإخفاء النهائي (يسجل في الكاش للأبد)
            ElevatedButton(
              onPressed: () async {
                await ShowcaseController.markActiveAsCompleted();
                ShowcaseView.get().dismiss();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.black,
                foregroundColor: MyColors.islamicGold,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                side: const BorderSide(color: MyColors.islamicGold, width: 1.5),
                elevation: 10,
                shadowColor: MyColors.islamicGold.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.visibility_off_rounded, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    context.l10n.sh_hide,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // ملاحظة: لا نقوم بعمل unregister هنا للحفاظ على تسجيل الإعدادات العالمية
    // طوال فترة بقاء التطبيق مفتوحاً، مما يحل مشكلة الـ BottomNav
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // نرجع الـ child مباشرة لأن الإعدادات مسجلة عالمياً
    // والـ CustomShowcase ستبحث عنها في الـ Singleton الخاص بالمكتبة
    return widget.child;
  }
}
