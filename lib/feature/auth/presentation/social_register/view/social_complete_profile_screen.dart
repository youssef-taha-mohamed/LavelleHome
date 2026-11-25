import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../../core/utils/styles_link.dart';
import '../../../../../shared/enum/gender.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../../botttom_nav_bar/provider/nav_bar.dart';
import '../../../../botttom_nav_bar/nav_bar.dart';
import '../../../domain/enums/social_media.dart';
import '../../register/view/widgets/country_field.dart';
import '../cubit/social_register_cubit.dart';

/// Arguments passed via Navigator to [SocialCompleteProfileScreen]
class SocialCompleteProfileArgs {
  const SocialCompleteProfileArgs({
    required this.token,
    required this.socialMedia,
    required this.emailFromProvider,
    required this.fullNameFromProvider,
    required this.isStudent,
  });

  final String token;
  final SocialMediaAuthentication socialMedia;
  final String emailFromProvider;
  final String fullNameFromProvider;
  final bool isStudent;
}

class SocialCompleteProfileScreen extends StatefulWidget {
  static const String routeName = '/social-complete-profile';

  const SocialCompleteProfileScreen({
    super.key,
    required this.token,
    required this.socialMedia,
    required this.emailFromProvider,
    required this.fullNameFromProvider,
    required this.isStudent,
  });

  final String token;
  final SocialMediaAuthentication socialMedia;
  final String emailFromProvider;
  final String fullNameFromProvider;
  final bool isStudent;

  @override
  State<SocialCompleteProfileScreen> createState() =>
      _SocialCompleteProfileScreenState();
}

class _SocialCompleteProfileScreenState
    extends State<SocialCompleteProfileScreen> {
  late final SocialRegisterCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SocialRegisterCubit>();
    _cubit.fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return BlocConsumer<SocialRegisterCubit, SocialRegisterState>(
      listener: _stateHandler,
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.isLoading,
          child: Scaffold(
            backgroundColor: colors.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: MainText(
                context.l10n.complete_profile,
                color: colors.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.getPadding(context),
                  vertical: 16,
                ),
                child: Form(
                  key: _cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Provider badge ────────────────────────────────────
                      _ProviderBadge(socialMedia: widget.socialMedia),
                      const SizedBox(height: 24),

                      // ── Pre-filled: Full Name (disabled) ──────────────────
                      MainText(
                        context.l10n.full_name,
                        color: colors.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 8),
                      _DisabledField(
                        value: widget.fullNameFromProvider,
                        icon: Icons.person_outline,
                        colors: colors,
                      ),
                      const SizedBox(height: 16),

                      // ── Pre-filled: Email (disabled) ───────────────────────
                      MainText(
                        context.l10n.email,
                        color: colors.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 8),
                      _DisabledField(
                        value: widget.emailFromProvider,
                        icon: Icons.email_outlined,
                        colors: colors,
                      ),
                      const SizedBox(height: 16),

                      // ── Username ───────────────────────────────────────────
                      MainTextField(
                        withLabel: true,
                        labelOut: context.l10n.user_name,
                        controller: _cubit.userNameController,
                        currentFocusNode: _cubit.userNameFocusNode,
                        nextFocusNode: _cubit.passwordFocusNode,
                        textDirection: TextDirection.ltr,
                        hint: 'Ahmed123',
                        prefixIcon: Icon(
                          Icons.alternate_email,
                          color: MyColors.primaryColor,
                        ),
                        onChanged: (_) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.user_name_validation;
                          }
                          if (value.length < 6) {
                            return context.l10n.user_name_validation_size;
                          }
                          return null;
                        },
                        validationRules: [
                          ValidationRule(
                            label: context.l10n.field_required,
                            check: (val) => val.isNotEmpty,
                          ),
                          ValidationRule(
                            label: context.l10n.user_name_validation_size,
                            check: (val) => val.length >= 6,
                          ),
                          ValidationRule(
                            label: context.l10n.invalid_user_name_characters,
                            check: (val) =>
                                RegExp(r'^[a-zA-Z0-9]+$').hasMatch(val),
                          ),
                          ValidationRule(
                            label: context.l10n.user_name_validation_capital,
                            check: (val) => RegExp(r'[A-Z]').hasMatch(val),
                          ),
                          ValidationRule(
                            label: context.l10n.user_name_validation_small,
                            check: (val) => RegExp(r'[a-z]').hasMatch(val),
                          ),
                          ValidationRule(
                            label: context.l10n.user_name_validation,
                            check: (val) => RegExp(r'[0-9]').hasMatch(val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Password ───────────────────────────────────────────
                      MainTextField(
                        controller: _cubit.passwordController,
                        currentFocusNode: _cubit.passwordFocusNode,
                        nextFocusNode: _cubit.confirmPasswordFocusNode,
                        isPassword: true,
                        withLabel: true,
                        labelOut: context.l10n.password,
                        textDirection: TextDirection.ltr,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: MyColors.primaryColor,
                        ),
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
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Confirm Password ───────────────────────────────────
                      MainTextField(
                        controller: _cubit.confirmPasswordController,
                        currentFocusNode: _cubit.confirmPasswordFocusNode,
                        nextFocusNode: _cubit.phoneFocusNode,
                        isPassword: true,
                        withLabel: true,
                        labelOut: context.l10n.confirm_password,
                        textDirection: TextDirection.ltr,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: MyColors.primaryColor,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.confirm_password_validation;
                          }
                          if (value != _cubit.passwordController.text) {
                            return context.l10n.passwords_do_not_match;
                          }
                          return null;
                        },
                        validationRules: [
                          ValidationRule(
                            label: context.l10n.passwords_do_not_match,
                            check: (val) =>
                                val == _cubit.passwordController.text,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Country ────────────────────────────────────────────
                      CountryFieldWidget(
                        selectedCountry: _cubit.selectedCountry,
                        onCountrySelected: (country) {
                          _cubit.updateSelectedCountry(country);
                        },
                      ),
                      const SizedBox(height: 16),

                      // ── Phone ──────────────────────────────────────────────
                      if (_cubit.selectedCountry != null)
                        CustomPhone(
                          key: ValueKey(
                            '${_cubit.selectedCountryIsoCode}_${_cubit.selectedCountry?.id}',
                          ),
                          controller: _cubit.phoneController,
                          label: context.l10n.phone_number,
                          allowCountryChange: false,
                          currentFocusNode: _cubit.phoneFocusNode,
                          nextFocusNode: null,
                          showClearButton: true,
                          unFocusWhenTapOutside: true,
                          textDirection: TextDirection.ltr,
                          initialCountryCode: _cubit.selectedCountryIsoCode,
                          onChangedPhoneNumber: (PhoneNumber number) {
                            _cubit.updatePhoneNumber(number);
                          },
                          validator: (phone) {
                            if (phone == null || phone.completeNumber.isEmpty) {
                              return context
                                  .l10n
                                  .please_enter_your_phone_number;
                            }
                            return null;
                          },
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: MyColors.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: MyColors.primaryColor.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              const Icon(Icons.info_outline, size: 20),
                              Expanded(
                                child: MainText(
                                  context.l10n.please_select_country_first,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),

                      // ── Gender ─────────────────────────────────────────────
                      CustomDropdown<Gender>(
                        getLabel: (g) => g == Gender.male
                            ? context.l10n.male
                            : context.l10n.female,
                        selectedValue: _cubit.gender,
                        hint: context.l10n.select_gender,
                        genderItems: const [Gender.male, Gender.female],
                        onChanged: _cubit.updateGender,
                      ),
                      const SizedBox(height: 16),

                      // ── BirthDate (Student only) ───────────────────────────
                      if (widget.isStudent) ...[
                        CustomDatePickerField(
                          label: context.l10n.birth_date,
                          hint: context.l10n.select_birth_date,
                          selectedDate: state.birthDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          onDateSelected: _cubit.updateBirthDate,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // ── Terms ──────────────────────────────────────────────
                      Row(
                        children: [
                          Checkbox(
                            value: state.agreeToTerms,
                            onChanged: (v) =>
                                _cubit.updateAgreeToTerms(v ?? false),
                            activeColor: MyColors.primaryColor,
                          ),
                          Expanded(
                            child: MainText(
                              context.l10n.agree_terms_conditions,
                              fontSize: 12,
                              color: colors.subTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Submit button ──────────────────────────────────────
                      MainButton(
                        onPressed: state.isFormValid
                            ? () => _cubit.register(
                                role: widget.isStudent
                                    ? UserRole.student
                                    : UserRole.parent,
                              )
                            : () {},
                        title: context.l10n.registration_data,
                        isLoading: false,
                        titleColor: state.isFormValid
                            ? MyColors.white
                            : MyColors.white0,
                        backgroundColor: state.isFormValid
                            ? MyColors.primaryColor
                            : MyColors.black50,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _stateHandler(BuildContext context, SocialRegisterState state) {
    if (state.isLoading) return;

    if (state.isError && state.errorMessage != null) {
      Fluttertoast.showToast(
        msg: state.errorMessage ?? context.l10n.something_went_wrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: MyColors.appRed,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }

    if (state.isSuccess) {
      context.read<NavigationProvider>().changeIndex(0);
      Navigator.pushNamedAndRemoveUntil(
        context,
        BottomNavBar.routeName,
        (route) => false,
      );
    }
  }
}

// ─── Sub-Widgets ──────────────────────────────────────────────────────────────

class _ProviderBadge extends StatelessWidget {
  const _ProviderBadge({required this.socialMedia});

  final SocialMediaAuthentication socialMedia;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isGoogle = socialMedia == SocialMediaAuthentication.google;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: MyColors.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: MyColors.primaryColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            spacing: 8,
            children: [
              Icon(
                isGoogle ? Icons.g_mobiledata : Icons.apple,
                color: MyColors.primaryColor,
                size: 20,
              ),
              MainText(
                isGoogle ? 'Google' : 'Apple',
                color: MyColors.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: MainText(
            isGoogle
                ? context.l10n.complete_google_profile
                : context.l10n.complete_apple_profile,
            color: colors.subTextColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _DisabledField extends StatelessWidget {
  const _DisabledField({
    required this.value,
    required this.icon,
    required this.colors,
  });

  final String value;
  final IconData icon;
  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Icon(icon, color: colors.subTextColor, size: 20),
        Expanded(
          child: MainText(
            value.isEmpty ? '—' : value,
            color: colors.subTextColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
