import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/authentication/provider.dart';
import '../../../../../core/db/kv_db/hive.dart';
import '../../../../../core/helper/helper.dart';
import '../../../../../shared/enum/gender.dart';
import '../../../../../shared/model/api_response.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../../country/domain/entities/definitions.dart';
import '../../../../country/domain/repository/repository.dart';
import '../../../../country/domain/usecase/fetch.dart';
import '../../../domain/entities/register_credentials.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({this.countryRepository}) : super(const RegisterState()) {
    _initPreferences();
  }

  final CountryBaseRepository? countryRepository;

  factory RegisterCubit.of(BuildContext context) {
    return BlocProvider.of<RegisterCubit>(context);
  }

  num? selectedLanguageId;
  num? selectedThemeId;

  void _initPreferences() {
    final deviceLang = HiveDatabase.getLanguageCode() ?? 'ar';
    final isDark = HiveDatabase.getTheme() ?? false;
    selectedThemeId = isDark ? 2 : 1;
    selectedLanguageId = deviceLang == 'ar' ? 1 : 2;

    if (countryRepository != null) {
      fetchCountries();
    }
  }

  void fetchCountries() async {
    if (countryRepository == null) return;
    try {
      final useCase = FetchCountries(repository: countryRepository!);
      final ApiResponse<Definitions> response = await useCase.call();
      final preference = response.record.preference;
      final deviceLang = HiveDatabase.getLanguageCode() ?? 'ar';
      final resolvedLanguageId = Helper.resolveLanguageId(
        deviceLangCode: deviceLang,
        backendLanguages: preference.language,
      );
      final isDark = HiveDatabase.getTheme() ?? false;
      selectedLanguageId = resolvedLanguageId;
      selectedThemeId = isDark ? 2 : 1;
    } catch (e) {
      log('fetchCountries error in RegisterCubit: $e');
    }
  }

  Future<void> register({
    required String fullName,
    required PhoneNumber phone,
    required String area,
    required String address,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      final cleanDialCode = phone.countryCode.replaceFirst('+', '');
      final cleanNumber = phone.number.trim();

      final credentials = RegisterCredentials(
        fullName: fullName,
        phone: cleanNumber,
        phoneNumberCode: '+$cleanDialCode',
        isoCode: phone.countryISOCode.isNotEmpty ? phone.countryISOCode : 'EG',
        address: address,
        note: area,
        countryId: 1,
        email: '',
        userName: cleanNumber,
        password: '',
        type: UserRole.student,
        gender: Gender.male,
        languageId: selectedLanguageId ?? 1,
        themeId: selectedThemeId ?? 1,
      );

      final ApiResponse response = await AuthenticationProvider.instance
          .register(credentials: credentials);

      emit(
        state.copyWith(
          status: RegisterStatus.success,
          successMessage: response.message,
        ),
      );
    } catch (e, s) {
      log('Register error: $e', stackTrace: s);
      String errorToShow = e.toString();
      if (e is DioException) {
        final serverMessage = e.response?.data is Map
            ? e.response?.data['message']?.toString()
            : null;
        errorToShow = serverMessage ?? e.message ?? e.toString();
      }
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: errorToShow,
        ),
      );
    }
  }
}
