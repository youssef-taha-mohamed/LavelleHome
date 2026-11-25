import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../core/utils/app_responsive.dart';
import '../../../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../otp_change_password/view/otp_change_password.dart';
import '../cubit/forget_password_cubit.dart';

class ForgetPasswordEmailView extends StatelessWidget {
  const ForgetPasswordEmailView({super.key});

  static const String routeName = '/forget-password-email';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: _stateHandler,
      builder: (context, state) {
        final cubit = context.read<ForgetPasswordCubit>();
        return LayoutBuilder(
          builder: (context, constraints) {
            return Scaffold(
              body: Stack(
                children: [
                  // Top Background Header with Indigo Gradient
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            MyColors.primaryColor,
                            MyColors.darkPrimaryDark,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),
                  // Main Content
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.getPadding(context),
                        vertical: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          70.ph,
                          // Logo inside a circular badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              height: 80,
                              width: 80,
                              child: const Center(child: AppLogo()),
                            ),
                          ),
                          24.ph,
                          MainText(
                            context.l10n.forget_password,
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                          8.ph,
                          MainText(
                            context
                                .l10n
                                .enter_your_email_to_reset_your_password,
                            textAlign: TextAlign.center,
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          48.ph,
                          // Floating Form Card
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 450),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 32,
                            ),
                            decoration: BoxDecoration(
                              color: context.isDark
                                  ? MyColors.darkItemBG5
                                  : MyColors.cardBg,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: context.isDark
                                      ? Colors.black.withValues(alpha: 0.3)
                                      : MyColors.primaryColor.withValues(
                                          alpha: 0.15,
                                        ),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Form(
                              key: cubit.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MainText(
                                    context.l10n.forget_password,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textColor,
                                  ),
                                  24.ph,
                                  MainTextField(
                                    controller: cubit.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    currentFocusNode: cubit.emailFocusNode,
                                    nextFocusNode: null,
                                    textDirection: context.isArabic
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    withLabel: true,
                                    labelOut: context.l10n.email,
                                    hint: 'student@kunoz.com',
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: MyColors.primaryColor,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return context.l10n.email_va;
                                      }
                                      if (!RegExp(
                                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      ).hasMatch(value)) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    validationRules: [
                                      // Required Rule
                                      ValidationRule(
                                        label: context.l10n.email_va,
                                        check: (val) => val.isNotEmpty,
                                      ),
                                      // Format Rule
                                      ValidationRule(
                                        label: context.l10n.email_err,
                                        check: (val) => RegExp(
                                          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                                        ).hasMatch(val),
                                      ),
                                    ],
                                  ),
                                  24.ph,
                                  MainButton(
                                    onPressed: state.isFormValid
                                        ? () => cubit.sendEmail()
                                        : () {},
                                    title: context.l10n.send_code,
                                    isLoading: state.isLoading,
                                    titleColor: state.isFormValid
                                        ? MyColors.white
                                        : MyColors.white0,
                                    backgroundColor: state.isFormValid
                                        ? MyColors.primaryColor
                                        : MyColors.black50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _stateHandler(BuildContext context, ForgetPasswordState state) {
    if (state.isLoading) {
      return;
    }

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
      final successMessage = state.successMessage ?? '';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastService.showSuccess(context, successMessage);

        //Future.delayed(const Duration(milliseconds: 500), () {
        final cubit = context.read<ForgetPasswordCubit>();
        Navigator.pushNamedAndRemoveUntil(
          context,
          OtpChangePasswordView.routeName,
          arguments: cubit.emailController.text,
          (route) => false,
        );
        //});
      });
      return;
    }
  }
}
