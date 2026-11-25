import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../../../../core/utils/app_responsive.dart';
import '../../../../../core/utils/utilities.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../login/view/login.dart';
import '../cubit/reset_password_cubit.dart';

class ResetPasswordParameter {
  final String email;
  final String userId;

  ResetPasswordParameter({required this.email, required this.userId});
}

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key, required this.parameter});

  final ResetPasswordParameter parameter;

  static const String routeName = '/reset-password';

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isDark = context.isDark;
    final accent = isDark ? MyColors.skyBlue : MyColors.primaryColor;

    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: _stateHandler,
      builder: (context, state) {
        final cubit = context.read<ResetPasswordCubit>();

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
          context.l10n.change_password,
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          textAlign: TextAlign.center,
          letterSpacing: 0.3,
        ),
        6.ph,
        MainText(
          context.l10n.change_password_desc,
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 13.5,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required ResetPasswordCubit cubit,
    required ResetPasswordState state,
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
              title: context.l10n.new_password,
              color: colors.textColor,
            ),
            18.ph,
            MainTextField(
              controller: cubit.passwordController,
              currentFocusNode: _newPasswordFocus,
              nextFocusNode: _confirmPasswordFocus,
              isPassword: true,
              withLabel: true,
              labelOut: context.l10n.new_password,
              label: context.l10n.password,
              textDirection: context.isArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              prefixIcon: Icon(Icons.lock_outline, color: accent),
              onChanged: (value) => cubit.validateForm(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.password_validation;
                }
                final allSatisfied = [
                  RegExp(
                    r'^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{}|\\:;"<>,./?`~]+$',
                  ).hasMatch(value),
                  value.length >= 8,
                  RegExp(r'[A-Z]').hasMatch(value),
                  RegExp(r'[a-z]').hasMatch(value),
                  RegExp(r'[0-9]').hasMatch(value),
                  RegExp(
                    r'[!@#$%^&*()_+\-=\[\]{}|\\:;"<>,./?`~]',
                  ).hasMatch(value),
                ].every((e) => e);
                return allSatisfied ? null : '';
              },
              validationRules: [
                ValidationRule(
                  label: context.l10n.invalid_password_characters,
                  check: (val) => RegExp(
                    r'^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{}|\\:;"<>,./?`~]+$',
                  ).hasMatch(val),
                ),
                ValidationRule(
                  label: context.l10n.password_validation_size,
                  check: (val) => val.length >= 8,
                ),
                ValidationRule(
                  label: context.l10n.password_validation_capital,
                  check: (val) => RegExp(r'[A-Z]').hasMatch(val),
                ),
                ValidationRule(
                  label: context.l10n.password_validation_small,
                  check: (val) => RegExp(r'[a-z]').hasMatch(val),
                ),
                ValidationRule(
                  label: context.l10n.at_least_one_number,
                  check: (val) => RegExp(r'[0-9]').hasMatch(val),
                ),
                ValidationRule(
                  label: context.l10n.at_least_one_special_char,
                  check: (val) => RegExp(
                    r'[!@#$%^&*()_+\-=\[\]{}|\\:;"<>,./?`~]',
                  ).hasMatch(val),
                ),
                ValidationRule(
                  label: context.l10n.password_same_as_old,
                  check: (val) =>
                      val.isNotEmpty && val != cubit.passwordController.text,
                ),
              ],
            ),
            16.ph,
            MainTextField(
              currentFocusNode: _confirmPasswordFocus,
              nextFocusNode: null,
              withLabel: true,
              labelOut: context.l10n.confirm_password,
              controller: cubit.confirmPasswordController,
              isPassword: true,
              label: context.l10n.confirm_password,
              textDirection: context.isArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              prefixIcon: Icon(Icons.lock_outline, color: accent),
              onChanged: (value) => cubit.validateForm(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.confirm_password_validation;
                }
                if (value != cubit.passwordController.text) {
                  return '';
                }
                return null;
              },
              validationRules: [
                ValidationRule(
                  label: context.l10n.passwords_do_not_match,
                  check: (val) =>
                      val.isNotEmpty && val == cubit.passwordController.text,
                ),
              ],
            ),
            24.ph,
            _GradientButton(
              title: context.l10n.save_password,
              isDimmed: !state.isFormValid,
              isLoading: state.isLoading,
              onTap: state.isFormValid
                  ? () {
                      cubit.resetPassword(
                        email: widget.parameter.email,
                        userId: widget.parameter.userId,
                      );
                    }
                  : () {},
            ),
          ],
        ),
      ),
    );
  }

  void _stateHandler(BuildContext context, ResetPasswordState state) {
    if (state.isLoading) {
      return;
    }
    // Handle error state
    if (state.isError && state.error != null) {
      Fluttertoast.showToast(
        msg: state.error ?? context.l10n.something_went_wrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: MyColors.appRed,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }

    // Handle success state
    if (state.isSuccess) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        autoDismiss: false,
        title: context.l10n.password_changed_successfully,
        desc:
            state.successMessage ??
            context.l10n.you_can_now_log_in_with_your_new_password,
        btnOkText: context.l10n.login_logout,
        btnOkOnPress: () async {
          if (context.mounted) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(LoginView.routeName, (route) => false);
          }
        },
        onDismissCallback: (type) async {
          if (context.mounted) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(LoginView.routeName, (route) => false);
          }
        },
      ).show();
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
