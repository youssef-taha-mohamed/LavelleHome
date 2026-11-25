import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/authentication/provider.dart';
import '../../../../../core/db/kv_db/hive.dart';
import '../../../../../core/helper/helper.dart';
import '../../../../../core/service/navigation_service.dart';
import '../../../../../shared/enum/gender.dart';
import '../../../../../shared/model/api_response.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../../country/domain/entities/country.dart';
import '../../../../country/domain/entities/definitions.dart';
import '../../../../country/domain/repository/repository.dart';
import '../../../../country/domain/usecase/fetch.dart';
import '../../../../user/domain/entities/preference_model.dart';
import '../../../../user/domain/entities/user.dart';
import '../../../domain/entities/social_register_credentials.dart';
import '../../../domain/enums/social_media.dart';

part 'social_register_state.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterState> {
  SocialRegisterCubit({
    required this.token,
    required this.socialMedia,
    required this.emailFromProvider,
    required this.fullNameFromProvider,
    required this.isStudent,
    required this.countryRepository,
  }) : super(const SocialRegisterState()) {
    _initControllers();
  }

  // ─── Provider Data ────────────────────────────────────────────────────────
  final String token;
  final SocialMediaAuthentication socialMedia;
  final String emailFromProvider;
  final String fullNameFromProvider;
  final bool isStudent;
  final CountryBaseRepository countryRepository;

  factory SocialRegisterCubit.of(BuildContext context) {
    return BlocProvider.of<SocialRegisterCubit>(context);
  }

  // ─── Controllers ──────────────────────────────────────────────────────────
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  bool agreeToTerms = false;
  DateTime? birthDate;
  PhoneNumber? phoneNumber;
  User? user;
  Gender? gender;
  Countries? selectedCountry;
  num? selectedLanguageId;
  num? selectedThemeId;
  final context = NavigationService.navigatorKey.currentContext!;

  void _initControllers() {
    userNameController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
  }

  // ─── Countries / Preferences ──────────────────────────────────────────────
  void fetchCountries() async {
    emit(state.copyWith(status: SocialRegisterStatus.loadingCountry));
    try {
      final useCase = FetchCountries(repository: countryRepository);
      final ApiResponse<Definitions> response = await useCase.call();
      final preference = response.record.preference;
      final deviceLang = HiveDatabase.getLanguageCode() ?? 'en';
      final resolvedLanguageId = Helper.resolveLanguageId(
        deviceLangCode: deviceLang,
        backendLanguages: preference.language,
      );
      final isDark = HiveDatabase.getTheme() ?? false;
      selectedLanguageId = resolvedLanguageId;
      selectedThemeId = isDark ? 2 : 1;
      emit(
        state.copyWith(
          status: SocialRegisterStatus.initial,
          preference: preference,
        ),
      );
    } catch (e) {
      log('fetchCountries error: $e');
      emit(
        state.copyWith(
          status: SocialRegisterStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // ─── Validation ──────────────────────────────────────────────────────────
  void _validateForm() {
    final usernameValid =
        userNameController.text.length >= 6 &&
        RegExp(r'^[a-zA-Z0-9]+$').hasMatch(userNameController.text) &&
        RegExp(r'[A-Z]').hasMatch(userNameController.text) &&
        RegExp(r'[a-z]').hasMatch(userNameController.text) &&
        RegExp(r'[0-9]').hasMatch(userNameController.text);

    final passwordValid =
        passwordController.text.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(passwordController.text) &&
        RegExp(r'[a-z]').hasMatch(passwordController.text) &&
        RegExp(r'[0-9]').hasMatch(passwordController.text) &&
        RegExp(
          r'[!@#$%^&*()_+\-=\[\]{}|\\:;"<>,./?`~]',
        ).hasMatch(passwordController.text);

    final confirmPasswordValid =
        confirmPasswordController.text == passwordController.text &&
        confirmPasswordController.text.isNotEmpty;

    bool isPhoneValid = false;
    try {
      if (phoneController.text.isNotEmpty) {
        if (phoneNumber != null && phoneNumber!.number.isNotEmpty) {
          isPhoneValid = phoneNumber!.isValidNumber();
        } else {
          isPhoneValid = phoneController.text.length >= 8;
        }
      }
    } catch (_) {
      isPhoneValid = false;
    }

    final isFormValid =
        usernameValid &&
        isPhoneValid &&
        passwordValid &&
        confirmPasswordValid &&
        selectedCountry != null &&
        gender != null &&
        agreeToTerms &&
        (isStudent ? birthDate != null : true);

    emit(
      state.copyWith(
        isFormValid: isFormValid,
        status: state.status == SocialRegisterStatus.error
            ? SocialRegisterStatus.initial
            : state.status,
      ),
    );
  }

  void updatePhoneNumber(PhoneNumber number) {
    phoneNumber = number;
    _validateForm();
  }

  void updateGender(Gender? value) {
    gender = value;
    _validateForm();
  }

  void updateBirthDate(DateTime? date) {
    birthDate = date;
    emit(state.copyWith(birthDate: date));
    _validateForm();
  }

  void updateAgreeToTerms(bool value) {
    agreeToTerms = value;
    emit(state.copyWith(agreeToTerms: value));
    _validateForm();
  }

  void updateSelectedCountry(Countries? country) {
    selectedCountry = country;
    emit(
      state.copyWith(
        status: SocialRegisterStatus.countrySelected,
        selectedCountryId: country?.id,
      ),
    );
    _validateForm();
  }

  // ─── Register ─────────────────────────────────────────────────────────────
  Future<void> register({required UserRole role}) async {
    emit(state.copyWith(status: SocialRegisterStatus.loading));
    try {
      if (!formKey.currentState!.validate()) {
        emit(
          state.copyWith(
            status: SocialRegisterStatus.error,
            errorMessage: context.l10n.please_check_your_inputs,
          ),
        );
        return;
      }

      if (selectedCountry == null) {
        emit(
          state.copyWith(
            status: SocialRegisterStatus.error,
            errorMessage: context.l10n.please_select_your_country,
          ),
        );
        return;
      }

      if (phoneNumber == null || phoneNumber!.number.isEmpty) {
        emit(
          state.copyWith(
            status: SocialRegisterStatus.error,
            errorMessage: context.l10n.please_enter_your_phone_number,
          ),
        );
        return;
      }

      final credentials = SocialRegisterCredentials(
        socialMedia: socialMedia,
        token: token,
        email: emailFromProvider,
        fullName: fullNameFromProvider,
        userName: userNameController.text,
        phone: '${phoneNumber?.number}',
        countryId: selectedCountry?.id ?? 1,
        gender: gender!,
        type: role,
        languageId: selectedLanguageId ?? 1,
        themeId: selectedThemeId ?? 1,
        birthDay: role == UserRole.student ? birthDate : null,
        password: passwordController.text,
      );

      final ApiResponse<User> response = await AuthenticationProvider.instance
          .registerWithSocialMedia(credentials: credentials);

      user = response.record;
      emit(
        state.copyWith(
          status: SocialRegisterStatus.success,
          successMessage: response.message,
        ),
      );
    } catch (e, s) {
      log('Social Register error: $e', stackTrace: s);
      String errorToShow = e.toString();
      if (e is DioException) errorToShow = e.message ?? '';
      emit(
        state.copyWith(
          status: SocialRegisterStatus.error,
          errorMessage: errorToShow,
        ),
      );
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────
  String get selectedCountryDialCode {
    if (selectedCountry == null) return '20';
    return selectedCountry!.code.replaceFirst('+', '');
  }

  String get selectedCountryIsoCode {
    if (selectedCountry == null) return 'EG';
    if (selectedCountry!.isoCode.isNotEmpty) return selectedCountry!.isoCode;
    final cleanDialCode = selectedCountry!.code.replaceFirst('+', '');
    try {
      final country = PhoneNumber.getCountry('+$cleanDialCode');
      return country.code;
    } catch (_) {
      return 'EG';
    }
  }

  void dispose() {
    userNameController.removeListener(_validateForm);
    phoneController.removeListener(_validateForm);
    passwordController.removeListener(_validateForm);
    confirmPasswordController.removeListener(_validateForm);
    userNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    userNameFocusNode.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }
}
