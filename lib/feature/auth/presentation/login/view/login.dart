import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../../../../core/utils/custom_dialog.dart';
import '../../../../../core/utils/toast_alert.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../../botttom_nav_bar/provider/nav_bar.dart';
import '../../../../botttom_nav_bar/nav_bar.dart';
import '../../../domain/enums/social_media.dart';
import '../../otp_register/view/otp_register.dart';
import '../../social_login/cubit/social_login_cubit.dart';
import '../../social_register/view/social_complete_profile_screen.dart';
import '../cubit/login_cubit.dart';
import 'widgets/or_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDark = context.isDark;
    // لون التمييز: كحلي في الفاتح، سماوي في الداكن لضمان التباين
    final accent = isDark ? MyColors.skyBlue : MyColors.primaryColor;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: _stateHandler,
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        return BlocConsumer<SocialLoginCubit, SocialLoginState>(
          listener: socialStateHandler,
          builder: (context, socialState) {
            final socialCubit = context.read<SocialLoginCubit>();
            return ForceUpdateGuard(
              child: Scaffold(
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    final heroHeight = (screenHeight * 0.42).clamp(
                      320.0,
                      440.0,
                    );
                    final topInset = MediaQuery.of(context).padding.top;

                    return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Stack(
                          children: [
                            // الهيرو الكحلي (يتحرك مع المحتوى عند السكرول)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: heroHeight,
                              child: const _HeroBackground(),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                8,
                                topInset + 12,
                                8,
                                32,
                              ),
                              child: Column(
                                children: [
                                  _Reveal(child: _buildHeader(context)),
                                  36.ph,
                                  _Reveal(
                                    begin: 0.2,
                                    dy: 40,
                                    child: _buildCard(
                                      context: context,
                                      cubit: cubit,
                                      state: state,
                                      socialState: socialState,
                                      socialCubit: socialCubit,
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
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ───────────────────────── الهيدر: الشعار + العنوان ─────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // هالة زجاجية + دائرة بيضاء للشعار
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.16),
            border: Border.all(
              color: MyColors.skyBlue.withValues(alpha: 0.55),
              width: 1.2,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              height: 76,
              width: 76,
              child: const Center(child: AppLogo()),
            ),
          ),
        ),
        18.ph,
        MainText(
          context.l10n.welcome_to_lavelle,
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          textAlign: TextAlign.center,
          letterSpacing: 0.4,
        ),
        8.ph,
        Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            _accentLine(),
            Flexible(
              child: MainText(
                context.l10n.laundry_tagline,
                textAlign: TextAlign.center,
                fontSize: 13.5,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            _accentLine(),
          ],
        ),
      ],
    );
  }

  Widget _accentLine() => Container(
    width: 20,
    height: 1.5,
    decoration: BoxDecoration(
      color: MyColors.skyBlue,
      borderRadius: BorderRadius.circular(2),
    ),
  );

  // ───────────────────────── الكارت العائم ─────────────────────────

  Widget _buildCard({
    required BuildContext context,
    required LoginCubit cubit,
    required LoginState state,
    required SocialLoginState socialState,
    required SocialLoginCubit socialCubit,
    required AppColorsExtension colors,
    required bool isDark,
    required Color accent,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
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
            // عنوان البطاقة
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        MyColors.primaryColor,
                        MyColors.primaryContainer,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_open_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                MainText(
                  context.l10n.login,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: colors.textColor,
                ),
              ],
            ),
            16.ph,
            // البريد / اسم المستخدم
            MainTextField(
              withLabel: true,
              labelOut: context.l10n.email_userName,
              controller: cubit.userNameController,
              currentFocusNode: cubit.userNameFocusNode,
              nextFocusNode: cubit.passwordFocusNode,
              keyboardType: TextInputType.emailAddress,
              textDirection: context.isArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              hint: 'name@example.com',
              prefixIcon: Icon(Icons.email_outlined, color: accent),
              onChanged: (value) => cubit.validateForm(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.field_required;
                }
                return null;
              },
              validationRules: [
                ValidationRule(
                  label: context.l10n.field_required,
                  check: (val) => val.isNotEmpty,
                ),
              ],
            ),
            16.ph,
            // كلمة المرور
            MainTextField(
              controller: cubit.passwordController,
              currentFocusNode: cubit.passwordFocusNode,
              nextFocusNode: null,
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              withLabel: true,
              labelOut: context.l10n.password,
              hint: context.l10n.enter_password,
              textDirection: context.isArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              prefixIcon: Icon(Icons.lock_outline, color: accent),
              onChanged: (value) => cubit.validateForm(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.password_validation;
                }
                return null;
              },
              validationRules: [
                ValidationRule(
                  label: context.l10n.password_validation,
                  check: (val) => val.isNotEmpty,
                ),
              ],
            ),

            // نسيت كلمة المرور
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    BottomNavBar.routeName,
                    (route) => false,
                  );
                  // Navigator.pushNamed(
                  //   context,
                  //   ForgetPasswordEmailView.routeName,
                  // );
                },
                child: MainText(
                  context.l10n.forget_password,
                  color: isDark ? MyColors.skyBlue : MyColors.primaryContainer,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            12.ph,

            // زر الدخول
            _GradientLoginButton(
              title: context.l10n.login,
              enabled: state.isFormValid,
              isLoading: state.isLoading,
              onTap: () => cubit.login(),
            ),

            // سوشيال + ضيف + تسجيل جديد
            OrWidget(
              isGoogleLoading:
                  socialState.isLoading &&
                  socialState.socialMedia == SocialMediaAuthentication.google,
              isAppleLoading:
                  socialState.isLoading &&
                  socialState.socialMedia == SocialMediaAuthentication.apple,
              googleTap: () => socialCubit.loginWithGoogle(),
              appleTap: () => socialCubit.loginWithApple(),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────── Handlers (بدون تغيير في المنطق) ─────────────────────────

  void _stateHandler(BuildContext context, LoginState state) {
    final cubit = context.read<LoginCubit>();

    if (state.isLoading) {
      return;
    }

    if (state.isError && state.errorMessage != null) {
      Fluttertoast.showToast(
        msg: state.errorMessage ?? context.l10n.something_went_wrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: MyColors.appRed,
        textColor: MyColors.white,
        fontSize: 14.0,
      );

      return;
    }

    if (state.isEmailNotVerified) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        OTPRegisterView.routeName,
        (route) => false,
        arguments: cubit.user?.details.email,
      );
      return;
    }

    if (state.isLoggedIn) {
      if (cubit.user?.details.role.id == UserRole.student.id) {
        context.read<NavigationProvider>().changeIndex(0);
        Navigator.pushNamedAndRemoveUntil(
          context,
          BottomNavBar.routeName,
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
          msg: context.l10n.something_went_wrong,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: MyColors.appRed,
          textColor: MyColors.white,
          fontSize: 14.0,
        );
      }
    }
  }

  void socialStateHandler(BuildContext context, SocialLoginState state) {
    if (state.isLoading) return;

    if (state.isError && state.errorMessage != null) {
      Fluttertoast.showToast(
        msg: state.errorMessage ?? context.l10n.something_went_wrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: MyColors.appRed,
        textColor: MyColors.white,
        fontSize: 14.0,
      );
      return;
    }

    if (state.isLoginSuccess) {
      context.read<NavigationProvider>().changeIndex(0);
      Navigator.pushNamedAndRemoveUntil(
        context,
        BottomNavBar.routeName,
        (route) => false,
      );

      return;
    }

    if (state.isNeedsReg) {
      // الحساب غير مسجل — نعرض رسالة تأكيد أولاً (نصوص مترجمة)
      CustomDialog.show(
        context: context,
        type: DialogType.question,
        title: context.l10n.new_account,
        message: context.l10n.social_account_not_registered(
          state.emailFromProvider ?? context.l10n.not_available,
        ),
        confirmText: context.l10n.continue_registration,
        cancelText: context.l10n.cancel,
        onConfirm: () {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            SocialCompleteProfileScreen.routeName,
            arguments: SocialCompleteProfileArgs(
              token: state.token!,
              socialMedia: state.socialMedia!,
              emailFromProvider: state.emailFromProvider ?? '',
              fullNameFromProvider: state.fullNameFromProvider ?? '',
              isStudent: true, // default — يمكن تعديله لاحقاً
            ),
          );
        },
        onCancel: () {
          Navigator.pop(context);
          context.showToast(
            message: context.l10n.registration_cancelled,
            type: ToastType.info,
            position: ToastPosition.top,
            duration: const Duration(seconds: 3),
          );
        },
      );
    }
  }
}

// ═════════════════════════════════════════════════════════════
// Private widgets
// ═════════════════════════════════════════════════════════════

/// ظهور تدريجي + انزلاق خفيف عند فتح الشاشة
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

/// زر الدخول بتدرج الهوية
class _GradientLoginButton extends StatelessWidget {
  final String title;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  const _GradientLoginButton({
    required this.title,
    required this.enabled,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = enabled || isLoading;
    final radius = BorderRadius.circular(16);

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
                  MyColors.primaryColor.withValues(alpha: 0.35),
                  MyColors.primaryContainer.withValues(alpha: 0.35),
                ],
        ),
        boxShadow: enabled && !isLoading
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
          onTap: enabled && !isLoading ? onTap : null,
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

/// الهيرو العلوي: تدرج كحلي + حافة موجية + فقاعات زخرفية
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
              _bubble(top: -50, right: -40, size: 190, alpha: 0.07),
              _bubble(top: 110, left: -60, size: 160, alpha: 0.06),
              _bubble(top: 50, left: 70, size: 36, alpha: 0.12),
              _bubble(top: 180, right: 50, size: 24, alpha: 0.14),
              _bubble(top: 250, left: 30, size: 16, alpha: 0.16),
              _bubble(top: 30, right: 110, size: 14, alpha: 0.18),
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
