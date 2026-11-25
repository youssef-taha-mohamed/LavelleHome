import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_area_handler/keyboard_area_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../shared/widgets/custom_toast.dart';
import '../../../../../shared/widgets/main_text.dart';
import 'dart:async';

import '../../core/extension/extension_helper.dart';
import '../../core/style/theme/extensions/app_colors_extension.dart';
import '../../core/utils/arabic_digits_formatter.dart';
import '../../l10n/l10n.dart';
import 'main_button.dart';

class OTPBottomSheet extends StatefulWidget {
  final String email;
  final bool isInvitation;
  final Future<bool> Function(String) onVerificationSuccess;
  final VoidCallback onResendOTP;

  const OTPBottomSheet({
    super.key,
    required this.email,
    this.isInvitation = false,
    required this.onVerificationSuccess,
    required this.onResendOTP,
  });

  @override
  State<OTPBottomSheet> createState() => _OTPBottomSheetState();
}

class _OTPBottomSheetState extends State<OTPBottomSheet>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  bool _isLoading = false;
  bool _isVerifying = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _startResendTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startResendTimer() {
    _timer?.cancel();
    _resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOTP() async {
    if (_controller.text.length != 6) {
      ToastService.showError(context, context.l10n.please_enter_complete_otp);
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final bool success = await widget.onVerificationSuccess(_controller.text);

      if (success && mounted) {
        _timer?.cancel();
        _focusNode.unfocus();

        Future.delayed(Duration.zero, () {
          if (mounted) Navigator.of(context).pop(true);
        });
      } else {
        if (mounted) {
          ToastService.showError(context, context.l10n.invalid_otp);
          _clearOTP();
        }
      }
    } catch (e) {
      if (mounted) {
        ToastService.showError(context, context.l10n.invalid_otp);
        _clearOTP();
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  void _clearOTP() {
    setState(() {
      _controller.clear();
    });
    _focusNode.requestFocus();
  }

  Future<void> _resendOTP() async {
    setState(() {
      _isLoading = true;
    });

    try {
      widget.onResendOTP();
      _startResendTimer();
      _clearOTP();

      if (mounted) {
        ToastService.showSuccess(context, context.l10n.otp_resent_successfully);
      }
    } catch (e) {
      if (mounted) {
        ToastService.showError(context, context.l10n.failed_to_resend_otp);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Container(
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 24.0,
        // bottom: 24.0 + MediaQuery.of(context).viewInsets.bottom,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.containerBackground,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: KeyboardAreaHandler(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: MyColors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              24.ph,

              // // Icon
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: MyColors.primaryColor.withValues(alpha: 0.1),
              //     shape: BoxShape.circle,
              //   ),
              //   child: Icon(
              //     widget.isInvitation
              //         ? Icons.email_outlined
              //         : Icons.verified_user_outlined,
              //     size: 32,
              //     color: MyColors.primaryColor,
              //   ),
              // ),
              // 16.ph,

              // Title
              MainText.bigText(
                context.l10n.verify_otp,
                color: MyColors.darkGreen,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              8.ph,

              // Description
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: MyColors.grey4,
                    fontSize: 16,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: widget.isInvitation
                          ? context.l10n.otp_sent_to_invitation
                          : context.l10n.otp_sent_to,
                    ),
                    TextSpan(
                      text: '\n${widget.email}',
                      style: TextStyle(
                        color: MyColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              32.ph,
              Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                   backgroundColor: Colors.transparent,
                   inputFormatters: [
                     ArabicToEnglishDigitsFormatter(),
                   ],
                   appContext: context,
                  length: 6,
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  enableActiveFill: true,
                  textStyle: TextStyle(
                    fontSize: 22,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  autoFocus: true,
                  obscureText: false,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 52.h,
                    fieldWidth: 52.w,
                    activeBorderWidth: 2,
                    inactiveBorderWidth: 1,
                    activeFillColor: colors.background,
                    inactiveFillColor: colors.background,
                    selectedFillColor: colors.settingsTileBackground,
                    borderWidth: 1,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor:
                        isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                    selectedColor: Theme.of(context).primaryColor,
                  ),
                  onCompleted: (value) {
                    _verifyOTP();
                  },
                  onChanged: (value) {},
                  enabled: !_isVerifying,
                ),
              ),
              32.ph,
              // Verify Button
              MainButton(
                onPressed: _controller.text.length == 6 && !_isVerifying
                    ? _verifyOTP
                    : () {},
                title: context.l10n.verify,
                isLoading: _isVerifying,
                titleColor: _controller.text.length == 6
                    ? MyColors.white
                    : MyColors.textDisabled,
                backgroundColor: _controller.text.length == 6
                    ? MyColors.primaryColor
                    : colors.darkPrimaryDark,
                // icon: Icons.verified,
              ),
              16.ph,

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainText(
                    context.l10n.didnt_receive_otp,
                    color: MyColors.grey4,
                    fontSize: 14,
                  ),
                  4.pw,
                  if (_resendTimer > 0)
                    MainText(
                      '(${_resendTimer}s)',
                      color: MyColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )
                  else
                    GestureDetector(
                      onTap: _isLoading ? null : _resendOTP,
                      child: MainText(
                        context.l10n.resend,
                        color: _isLoading
                            ? MyColors.textDisabled
                            : MyColors.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                ],
              ),
              8.ph,

              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: MainText(
                  context.l10n.cancel,
                  color: MyColors.grey4,
                  fontSize: 16,
                ),
              ),
              // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
