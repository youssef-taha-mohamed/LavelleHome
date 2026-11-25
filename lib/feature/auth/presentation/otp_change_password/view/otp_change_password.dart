import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/utils/styles_link.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../reset_password/view/reset_password.dart';
import '../cubit/otp_change_password_cubit.dart';

class OtpChangePasswordView extends StatefulWidget {
  const OtpChangePasswordView({super.key, required this.email});

  final String email;

  static const String routeName = '/otp-verification';

  @override
  State<OtpChangePasswordView> createState() => _OtpChangePasswordViewState();
}

class _OtpChangePasswordViewState extends State<OtpChangePasswordView>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  bool _isVerifying = false;
  int _remainingTime = 0;
  Timer? _timer;
  final int _resendDuration = 40;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _remainingTime = _resendDuration;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _verifyOtp() async {
    setState(() {
      _isVerifying = true;
    });
    final cubit = context.read<OtpChangePasswordCubit>();
    await cubit.verifyOtpChangePassword(widget.email);
    setState(() {
      _isVerifying = false;
    });
  }

  void _resendOtp() {
    if (_isVerifying || _remainingTime > 0) return;
    final cubit = context.read<OtpChangePasswordCubit>();
    cubit.otpController.clear();
    cubit.resendOtp(widget.email);

    _startResendTimer();
  }

  String get _formattedRemainingTime {
    return '00:${_remainingTime.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDark = context.isDark;
    final accent = isDark ? MyColors.skyBlue : MyColors.primaryColor;

    return BlocConsumer<OtpChangePasswordCubit, OtpChangePasswordState>(
      listener: _stateHandler,
      builder: (context, state) {
        final cubit = context.read<OtpChangePasswordCubit>();

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (!didPop) {
              showExitDialog(context);
            }
          },
          child: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = MediaQuery.of(context).size.height;
                final heroHeight = (screenHeight * 0.36).clamp(280.0, 360.0);
                final topInset = MediaQuery.of(context).padding.top;

                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: heroHeight,
                                child: const _HeroBackground(),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  AppResponsive.getPadding(context),
                                  topInset + 20,
                                  AppResponsive.getPadding(context),
                                  32,
                                ),
                                child: Column(
                                  children: [
                                    _Reveal(child: _buildHeader(context)),
                                    28.ph,
                                    _Reveal(
                                      begin: 0.2,
                                      dy: 40,
                                      child: _buildCard(
                                        context: context,
                                        cubit: cubit,
                                        state: state,
                                        colors: colors,
                                        isDark: isDark,
                                        accent: accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (defaultTargetPlatform == TargetPlatform.iOS)
                        PositionedDirectional(
                          top: topInset + 8,
                          start: 16,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => showExitDialog(context),
                            child: Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.16),
            border: Border.all(
              color: MyColors.skyBlue.withValues(alpha: 0.55),
              width: 1.2,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              height: 62,
              width: 62,
              child: const Center(child: AppLogo()),
            ),
          ),
        ),
        14.ph,
        MainText(
          context.l10n.verify_otp,
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          textAlign: TextAlign.center,
          letterSpacing: 0.3,
        ),
        6.ph,
        MainText(
          context.l10n.otp_verification_description,
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 13.5,
          textAlign: TextAlign.center,
        ),
        10.ph,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: MyColors.skyBlue.withValues(alpha: 0.45)),
          ),
          child: MainText(
            widget.email,
            color: Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required OtpChangePasswordCubit cubit,
    required OtpChangePasswordState state,
    required AppColorsExtension colors,
    required bool isDark,
    required Color accent,
  }) {
    final isCompact = MediaQuery.of(context).size.height <= 650;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 450),
      padding: EdgeInsets.fromLTRB(22, 24, 22, isCompact ? 16 : 22),
      decoration: BoxDecoration(
        color: isDark ? MyColors.darkItemBG5 : MyColors.cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: MyColors.skyBlue.withValues(alpha: isDark ? 0.18 : 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : MyColors.primaryColor.withValues(alpha: 0.15),
            blurRadius: 40,
            spreadRadius: -4,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Form(
        key: cubit.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.lock_reset_rounded,
              title: context.l10n.enter_otp,
              color: colors.textColor,
            ),
            20.ph,
            ScaleTransition(
              scale: _animation,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: cubit.otpController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  enableActiveFill: true,
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : MyColors.textDark,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 52,
                    fieldWidth: isCompact ? 40 : 45,
                    activeFillColor: isDark
                        ? MyColors.darkItemBG3
                        : Colors.white,
                    inactiveFillColor: isDark
                        ? MyColors.darkItemBG3.withValues(alpha: 0.6)
                        : MyColors.skyBlue.withValues(alpha: 0.06),
                    selectedFillColor: isDark
                        ? MyColors.darkItemBG3
                        : MyColors.skyBlue.withValues(alpha: 0.12),
                    borderWidth: 1.2,
                    activeColor: accent,
                    inactiveColor: isDark
                        ? Colors.white.withValues(alpha: 0.14)
                        : MyColors.skyBlue.withValues(alpha: 0.35),
                    selectedColor: accent,
                  ),
                  inputFormatters: [ArabicToEnglishDigitsFormatter()],
                  backgroundColor: Colors.transparent,
                  onCompleted: (value) {
                    _verifyOtp();
                  },
                  onChanged: (value) => cubit.onOtpChanged(value),
                  enabled: !_isVerifying,
                ),
              ),
            ),
            isCompact ? 12.ph : 22.ph,
            _GradientButton(
              title: context.l10n.verify,
              isDimmed: cubit.otpController.text.length < 6,
              isLoading: _isVerifying,
              onTap: _verifyOtp,
            ),
            20.ph,
            _softDivider(),
            16.ph,
            Center(
              child: _remainingTime == 0
                  ? Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        MainText(
                          context.l10n.didnt_receive_otp,
                          fontSize: 12.5,
                          color: colors.subTextColor,
                        ),
                        TextButton(
                          onPressed: _resendOtp,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            minimumSize: const Size(0, 36),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: MainText(
                            context.l10n.resend_code,
                            color: accent,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.skyBlue.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: MyColors.skyBlue.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer_outlined, size: 16, color: accent),
                          6.pw,
                          MainText(
                            _formattedRemainingTime,
                            color: accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
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

  Widget _softDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.skyBlue.withValues(alpha: 0.0),
            MyColors.skyBlue.withValues(alpha: 0.55),
            MyColors.skyBlue.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  void _stateHandler(BuildContext context, OtpChangePasswordState state) {
    if (state.isLoading) return;

    if (state.isError && state.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: state.errorMessage ?? context.l10n.something_went_wrong,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: MyColors.appRed,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      });
      return;
    }

    if (state.isSuccess) {
      final successMessage =
          state.successMessage ?? context.l10n.code_sent_successfully;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastService.showSuccess(context, successMessage);
        Navigator.of(context).pushNamedAndRemoveUntil(
          ResetPasswordView.routeName,
          arguments: ResetPasswordParameter(
            email: widget.email,
            userId: state.userId ?? '',
          ),
          (route) => false,
        );
      });
    }
    if (state.isResendOtp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastService.showSuccess(context, state.successMessage!);
      });
      return;
    }
    if (state.isErrorResend) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: state.errorMessage ?? context.l10n.something_went_wrong,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: MyColors.appRed,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      });
      return;
    }

    if (state.isNotValidOTP && state.formError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: state.errorMessage ?? context.l10n.something_went_wrong,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: MyColors.appRed,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      });
    }
  }
}

// ═════════════════════════════════════════════════════════════
// Private widgets (matching Login / Register visual identity)
// ═════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [MyColors.primaryColor, MyColors.primaryContainer],
            ),
            boxShadow: [
              BoxShadow(
                color: MyColors.primaryColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MainText(
            title,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _Reveal extends StatelessWidget {
  final Widget child;
  final double begin;
  final double dy;

  const _Reveal({required this.child, this.begin = 0.0, this.dy = 24});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1100),
      child: child,
      builder: (context, t, child) {
        final v = Interval(begin, 1.0, curve: Curves.easeOutCubic).transform(t);
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * dy),
            child: child,
          ),
        );
      },
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String title;
  final bool isDimmed;
  final bool isLoading;
  final VoidCallback onTap;

  const _GradientButton({
    required this.title,
    required this.isDimmed,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    final active = !isDimmed || isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: active
              ? const [MyColors.primaryColor, MyColors.primaryContainer]
              : [
                  MyColors.primaryColor.withValues(alpha: 0.4),
                  MyColors.primaryContainer.withValues(alpha: 0.4),
                ],
        ),
        boxShadow: active && !isLoading
            ? [
                BoxShadow(
                  color: MyColors.primaryColor.withValues(alpha: 0.38),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: isLoading ? null : onTap,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MainText(
                        title,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _HeroBackground extends StatelessWidget {
  const _HeroBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipPath(
        clipper: _HeroWaveClipper(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                MyColors.deepBlue,
                MyColors.primaryColor,
                MyColors.primaryContainer,
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            children: [
              _bubble(top: -50, right: -40, size: 180, alpha: 0.07),
              _bubble(top: 100, left: -60, size: 150, alpha: 0.06),
              _bubble(top: 60, left: 80, size: 30, alpha: 0.12),
              _bubble(top: 170, right: 50, size: 22, alpha: 0.14),
              _bubble(top: 30, right: 120, size: 14, alpha: 0.18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bubble({
    double? top,
    double? left,
    double? right,
    required double size,
    required double alpha,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
          border: Border.all(
            color: MyColors.skyBlue.withValues(alpha: alpha + 0.08),
          ),
        ),
      ),
    );
  }
}

class _HeroWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 50)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height,
        size.width * 0.55,
        size.height - 28,
      )
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height - 62,
        size.width,
        size.height - 24,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
