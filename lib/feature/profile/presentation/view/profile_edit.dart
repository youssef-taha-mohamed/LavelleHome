import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../core/utils/styles_link.dart';
import '../../../../shared/enum/gender.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../auth/presentation/register/view/widgets/country_field.dart';
import '../provider/update_profile.dart';
import 'widgets/image_update.dart';
import '../desctop/profile_edit_desctop.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  static const routeName = '/profileEdit';

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          UpdateProfileProvider(DependencyInjector.userRepository),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1100) {
            return const ProfileEditWeb();
          }
          return Consumer<UpdateProfileProvider>(
            builder: (context, provider, child) {
              return ModalProgressHUD(
                inAsyncCall:
                    provider.state == UpdateProfileProviderState.loading,
                child: Scaffold(
                  body: SafeArea(
                    child: Column(
                      spacing: 16,
                      children: [
                        StreamBuilder<User?>(
                          stream: AuthenticationProvider.instance.userChanges(),
                          builder: (context, snapshot) {
                            final userDetails = snapshot.data?.details;
                            return CustomStudentHeader(
                              title: context.l10n.profile_edit,
                              subTitle: userDetails?.fullName ?? '',
                              image:
                                  userDetails?.image ??
                                  'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
                              showLeading: true,
                            );
                          },
                        ),
                        Expanded(
                          child: CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                sliver: SliverToBoxAdapter(
                                  child: FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: SlideTransition(
                                      position: _slideAnimation,
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          spacing: 24,
                                          children: [
                                            ImageUpdateWidget(
                                              provider: provider,
                                            ),
                                            _buildPersonalInfoForm(provider),
                                            _buildAdditionalInfoForm(provider),
                                            _buildSaveButton(provider, context),
                                            20.ph,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoForm(UpdateProfileProvider provider) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(8),
        border: theme.primaryBorder,
        boxShadow: theme.mediumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: MyColors.primaryColor,
                  size: 20,
                ),
              ),
              MainText(
                context.l10n.personal_information,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColor,
              ),
            ],
          ),
          16.ph,
          // Full Name Field
          MainTextField(
            controller: provider.form.fullNameController,
            label: context.l10n.full_name,
            showClearButton: false,
            prefixIcon: Icon(
              Icons.person_rounded,
              color: MyColors.primaryColor,
            ),
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.startsWith(' ')) {
                  return oldValue;
                }
                if (newValue.text.contains('  ')) {
                  return oldValue;
                }
                if (newValue.text.length > 25) {
                  return oldValue;
                }
                return newValue;
              }),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.full_name_validation;
              }
              if (value.startsWith(' ')) return '';
              if (value.length < 15 || value.length > 25) return '';
              return null;
            },
            validationRules: [
              ValidationRule(
                label: context.l10n.must_not_start_with_space,
                check: (val) => val.isNotEmpty && !val.startsWith(' '),
              ),
              ValidationRule(
                label: context.l10n.from_15_to_20_characters,
                check: (val) => val.length >= 15 && val.length <= 25,
              ),
            ],
          ),
          16.ph,
          MainTextField(
            controller: provider.form.userNameController,
            label: context.l10n.user_name,
            prefixIcon: Icon(
              Icons.alternate_email_rounded,
              color: MyColors.primaryColor,
            ),
            showClearButton: false,
            readOnly: true,
          ),
          16.ph,
          // Phone Field - linked to country
          CustomPhone(
            key: ValueKey('phone_field_${provider.phoneCountryIsoCode}'),
            controller: provider.form.phoneController,
            label: context.l10n.phone_number,
            allowCountryChange: true,
            currentFocusNode: provider.phoneFocusNode,
            showClearButton: true,
            unFocusWhenTapOutside: true,
            textDirection: TextDirection.ltr,
            initialCountryCode: provider.phoneCountryIsoCode,
            onChangedPhoneNumber: (PhoneNumber number) {
              provider.updatePhoneNumber(number);
            },
            validator: (phone) {
              if (phone == null || phone.completeNumber.isEmpty) {
                return context.l10n.please_enter_your_phone_number;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoForm(UpdateProfileProvider provider) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(8),
        border: theme.primaryBorder,
        boxShadow: theme.mediumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MyColors.islamicGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: MyColors.islamicGold,
                  size: 20,
                ),
              ),
              MainText(
                context.l10n.additional_information,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColors.islamicGold,
              ),
            ],
          ),
          16.ph,
          CountryFieldWidget(
            readOnly: true,
            selectedCountry: provider.form.selectedCountry,
            onCountrySelected: (country) {
              provider.selectCountry(country);
            },
          ),
          16.ph,
          MainTextField(
            controller: provider.form.address,
            label: context.l10n.address,
            showClearButton: false,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            prefixIcon: Icon(
              Icons.location_on_rounded,
              color: MyColors.primaryColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.please_enter_address;
              }
              return null;
            },
          ),
          16.ph,
          // Birth Date Field
          _buildDatePickerField(provider),
          16.ph,
          _buildGenderField(provider),
          16.ph,
          MainTextField(
            controller: provider.form.notes,
            label: context.l10n.note,
            suffixIcon: Icon(Icons.note),
            maxLines: 4,
          ),
          16.ph,
        ],
      ),
    );
  }

  Widget _buildDatePickerField(UpdateProfileProvider provider) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    final color = Theme.of(context).extension<AppColorsExtension>()!;
    return GestureDetector(
      onTap: () => provider.selectBirthDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        decoration: BoxDecoration(
          gradient: theme.primaryGradient,
          borderRadius: BorderRadius.circular(8),
          border: theme.primaryBorder,
          boxShadow: theme.mediumShadow,
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MyColors.tertiaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.cake_rounded,
                color: MyColors.tertiaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainText(
                    context.l10n.birth_date,
                    fontSize: 12,
                    color: color.textColor,
                  ),
                  MainText(
                    provider.form.birthday != null
                        ? '${provider.form.birthday!.day}/${provider.form.birthday!.month}/${provider.form.birthday!.year}'
                        : context.l10n.select_birth_date,
                    fontSize: 16,
                    color: color.subTextColor,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.calendar_today_rounded,
              color: MyColors.tertiaryColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderField(UpdateProfileProvider provider) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(8),
        border: theme.primaryBorder,
        boxShadow: theme.mediumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MyColors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.people_rounded,
                  color: MyColors.green,
                  size: 20,
                ),
              ),
              MainText(
                context.l10n.gender,
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: _buildGenderOption(
                  Gender.male,
                  context.l10n.male,
                  provider,
                ),
              ),
              Expanded(
                child: _buildGenderOption(
                  Gender.female,
                  context.l10n.female,
                  provider,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(
    Gender gender,
    String label,
    UpdateProfileProvider provider,
  ) {
    final isSelected = provider.form.gender == gender;

    return GestureDetector(
      onTap: () {}, //=> provider.selectGender(gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    MyColors.green.withValues(alpha: 0.2),
                    MyColors.green.withValues(alpha: 0.1),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? MyColors.green
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: MainText(
            label,
            color: isSelected ? MyColors.green : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(
    UpdateProfileProvider provider,
    BuildContext context,
  ) {
    final isLoading = provider.state == UpdateProfileProviderState.loading;
    final canSave = provider.form.hasChanges && !isLoading;
    return MainButton(
      title: context.l10n.save_edit,
      titleColor: MyColors.white,
      backgroundColor: canSave ? MyColors.primaryColor : MyColors.black50,
      onPressed: canSave
          ? () {
              if (_formKey.currentState!.validate()) {
                provider.saveProfile(context);
              }
            }
          : null,
    );
  }
}
