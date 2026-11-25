import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/extension/extension_helper.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/main_button.dart';
import '../../../../../shared/widgets/main_text.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            32.ph,
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: MainText(
                      context.l10n.no_notifications,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: MyColors.textDark,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            16.ph,
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: MainText(
                      context.l10n.no_notifications_message,
                      fontSize: 15,
                      color: MyColors.grey4,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                      height: 1.5,
                    ),
                  ),
                );
              },
            ),
            40.ph,
            MainButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              width: MediaQuery.of(context).size.width * 0.8,
              title: context.l10n.back_to_home,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessDialog extends StatefulWidget {
  const PaymentSuccessDialog({super.key});

  @override
  State<PaymentSuccessDialog> createState() => _PaymentSuccessDialogState();
}

class _PaymentSuccessDialogState extends State<PaymentSuccessDialog>
    with TickerProviderStateMixin {
  late AnimationController _dialogController;
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();

    _dialogController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _dialogController.forward();
    _confettiController.repeat();
  }

  @override
  void dispose() {
    _dialogController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _dialogController,
          curve: Curves.easeOutBack,
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 320,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(31),
              color: MyColors.green,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(31),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Lottie.asset(
                      'assets/animation/Success.json',
                      controller: _confettiController,
                      repeat: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  decoration: const BoxDecoration(
                    //color: MyColors.green,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // MainText(
                      //   context.l10n.booking_successful,
                      //   color: Colors.white,
                      //   fontSize: 20,
                      //   fontWeight: FontWeight.w500,
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // MainText(
                      //   context.l10n.for_your_vehicle,
                      //   color: Colors.white,
                      //   fontSize: 12,
                      //   fontWeight: FontWeight.w400,
                      // ),
                      SizedBox(height: 12),
                      MainText(
                        "Suzuki - Swift Dzire",
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      MainText(
                        "19 Jun 2024 | 10:00 am",
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
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
