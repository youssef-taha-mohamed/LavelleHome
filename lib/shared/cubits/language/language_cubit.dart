import 'dart:developer';
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/authentication/provider.dart';
import '../../../core/db/kv_db/hive.dart';
import 'dart:ui' as ui;
import '../../../feature/user/domain/entities/language.dart';
import '../../../feature/user/domain/entities/parameters/update_preference.dart';
import '../../../feature/user/domain/entities/theme_model.dart';
import '../../../feature/user/domain/entities/user.dart';
import '../../../feature/user/domain/repositories/user.dart';
import '../../../feature/user/domain/use_cases/preference.dart';
import '../../../feature/user/domain/use_cases/update_preference.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit({required this.repository}) : super(const LanguageState()) {
    init();
  }

  final UserBaseRepository repository;

  /// Load saved language from storage
  static const _supported = ['ar', 'en', 'fr'];

  void init() {
    log('🟡 LanguageCubit.init() started');
    final saved = HiveDatabase.getLanguageCode();
    log('📦 Saved language in Hive: $saved');

    if (saved != null && _supported.contains(saved)) {
      log('✅ Using saved language from Hive: $saved');
      emit(state.copyWith(languageCode: saved));
      return;
    }

    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    final deviceLang = deviceLocale.languageCode;

    log('📱 Device locale: ${deviceLocale.toLanguageTag()}');
    log('📱 Device languageCode: $deviceLang');

    final isSupported = _supported.contains(deviceLang);
    log('🔍 Is device language supported? $isSupported');

    final resolvedLang = isSupported ? deviceLang : 'fr';

    log('🎯 Resolved language: $resolvedLang');

    HiveDatabase.setLanguageCode(resolvedLang);
    log('💾 Language saved to Hive: $resolvedLang');

    emit(state.copyWith(languageCode: resolvedLang));
    log('🚀 Language emitted to state: $resolvedLang');
  }

  /// Change language + save in DB
  Future<void> changeLanguage(String code) async {
    if (code == state.languageCode) {
      log('⚠️ changeLanguage called with same language: $code');
      return;
    }

    log('🔄 Changing language to: $code');

    emit(state.copyWith(status: LanguageStatus.loading));

    try {
      await HiveDatabase.setLanguageCode(code);
      log('💾 Language updated in Hive: $code');

      emit(state.copyWith(languageCode: code, status: LanguageStatus.changed));
      log('✅ Language changed successfully: $code');
    } catch (e, s) {
      log('❌ Error changing language: $e');
      log('$s');
      emit(
        state.copyWith(
          status: LanguageStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Locale get currentLocale => Locale(state.languageCode);

  Future<void> getPreference() async {
    emit(state.copyWith(status: LanguageStatus.loadingLanguage));
    try {
      final useCase = FetchPreference(repository: repository);
      final result = await useCase.call();
      if (result.status) {
        emit(
          state.copyWith(
            status: LanguageStatus.successLanguage,
            languages: result.record.language,
            themes: result.record.themes,
          ),
        );
      }
    } catch (e, s) {
      log("Error in getLanguage: $e");
      log("Error in getLanguage: $s");
      emit(
        state.copyWith(
          status: LanguageStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updatePreference(UpdatePreference parameters) async {
    emit(state.copyWith(status: LanguageStatus.loadingUpdate));
    try {
      final useCase = UpdatePreferenceUseCase(repository: repository);
      final result = await useCase.call(parameters: parameters);
      if (result.status) {
        if (result.status) {
          final auth = AuthenticationProvider.instance;
          final currentUser = auth.currentUser;

          if (currentUser != null) {
            final oldDetails = currentUser.details;
            final oldPreference = oldDetails.preference;

            final selectedLang = state.languages.firstWhere(
              (l) => l.priority == parameters.languageId,
              orElse: () => state.languages.first,
            );

            final updatedPreference = oldPreference.copyWith(
              languageId: selectedLang.priority,
              languageName: selectedLang.name,
              languageCode: selectedLang.code,
              theme: parameters.themeId,
            );

            final updatedDetails = oldDetails.copyWith(
              preference: updatedPreference,
            );

            auth.sinkUser(
              User(
                accessToken: currentUser.accessToken,
                details: updatedDetails,
              ),
            );

            log(
              '🧠 User cache updated → languageCode=${selectedLang.code}, themeId=${parameters.themeId}',
            );
          }
        }
        emit(state.copyWith(status: LanguageStatus.successUpdate));
      } else {
        emit(state.copyWith(status: LanguageStatus.error));
      }
    } catch (e, s) {
      log("Error in getLanguage: $e");
      log("Error in getLanguage: $s");
      emit(
        state.copyWith(
          status: LanguageStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
