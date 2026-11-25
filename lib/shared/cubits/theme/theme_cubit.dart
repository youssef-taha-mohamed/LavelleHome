import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/authentication/provider.dart';
import '../../../core/db/kv_db/hive.dart';
import '../../../feature/user/domain/entities/parameters/update_preference.dart';
import '../../../feature/user/domain/entities/theme_model.dart';
import '../../../feature/user/domain/entities/user.dart';
import '../../../feature/user/domain/repositories/user.dart';
import '../../../feature/user/domain/use_cases/preference.dart';
import '../../../feature/user/domain/use_cases/update_preference.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> with WidgetsBindingObserver {
  ThemeCubit({required this.repository}) : super(const ThemeState()) {
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  final UserBaseRepository repository;

  void init() {
    log('🟡 ThemeCubit.init() started');

    final saved = HiveDatabase.getTheme();
    log('📦 Saved theme in Hive: $saved');

    if (saved != null) {
      log('✅ Using saved theme from Hive: ${saved ? "Dark" : "Light"}');

      emit(
        state.copyWith(
          isDark: saved,
          themeMode: saved ? ThemeMode.dark : ThemeMode.light,
        ),
      );
      return;
    }

    log('⚠️ No saved theme, resolving from system');

    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final isDark = brightness == Brightness.dark;

    log('📱 System brightness: $brightness');
    log('🎯 Resolved theme: ${isDark ? "Dark" : "Light"}');

    HiveDatabase.setTheme(isDark);
    log('💾 Theme saved to Hive: ${isDark ? "Dark" : "Light"}');

    emit(
      state.copyWith(
        isDark: isDark,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      ),
    );

    log('🚀 Theme emitted to state');
  }

  /// User changes theme manually
  void toggleTheme() {
    final newValue = !state.isDark;

    log('🔄 Toggling theme to: ${newValue ? "Dark" : "Light"}');

    HiveDatabase.setTheme(newValue);
    log('💾 Theme updated in Hive');

    emit(
      state.copyWith(
        isDark: newValue,
        themeMode: newValue ? ThemeMode.dark : ThemeMode.light,
      ),
    );

    log('✅ Theme changed successfully');
  }

  /// Override via direct theme
  void setThemeMode(ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;

    log('🎯 Setting theme directly: ${isDark ? "Dark" : "Light"}');

    HiveDatabase.setTheme(isDark);
    log('💾 Theme updated in Hive');

    emit(state.copyWith(isDark: isDark, themeMode: mode));
  }

  @override
  void didChangePlatformBrightness() {
    // 1. تشيك هل فيه سيم يدوي متسجل؟
    final saved = HiveDatabase.getTheme();

    // 2. لو مفيش (يعني أول مرة خالص) يبقى نلحق نغير مع النظام
    if (saved == null) {
      log('📱 First-time user: Following system brightness');
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final isDark = brightness == Brightness.dark;

      // مش هنخزن في Hive هنا عشان نفضل نتبع النظام لحد ما هو يغير بنفسه
      // أو نسجل دخول والباك اند يبعت لنا.
      emit(
        state.copyWith(
          isDark: isDark,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        ),
      );
    } else {
      // 3. لو فيه قيمة في Hive (سواء من Toggle أو من الباك اند) -> طنش النظام تماماً
      log(
        '🚫 System brightness changed but ignored (Manual preference exists)',
      );
    }
  }

  Future<void> getPreference() async {
    log('🟡 ThemeCubit.getPreference() started');

    emit(state.copyWith(status: ThemeStatus.loadingTheme));

    try {
      final result = await FetchPreference(repository: repository).call();

      if (result.status) {
        log('✅ Theme list fetched successfully');

        emit(
          state.copyWith(
            status: ThemeStatus.successTheme,
            themes: result.record.themes,
          ),
        );
      }
    } catch (e, s) {
      log('❌ Error in getPreference: $e');
      log('$s');

      emit(
        state.copyWith(status: ThemeStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updatePreference(UpdatePreference parameters) async {
    log('🟡 ThemeCubit.updatePreference() started');

    emit(state.copyWith(status: ThemeStatus.loadingUpdate));

    try {
      final result = await UpdatePreferenceUseCase(
        repository: repository,
      ).call(parameters: parameters);

      if (result.status) {
        log('✅ Theme preference updated successfully');

        // 🔥🔥🔥 النقطة الحاسمة
        final auth = AuthenticationProvider.instance;
        final currentUser = auth.currentUser;

        if (currentUser != null) {
          final oldDetails = currentUser.details;
          final oldPreference = oldDetails.preference;

          final updatedPreference = oldPreference.copyWith(
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
            '🧠 User cache updated → themeId=${parameters.themeId}',
          );
        }

        emit(state.copyWith(status: ThemeStatus.successUpdate));
      } else {
        emit(state.copyWith(status: ThemeStatus.error));
      }
    } catch (e, s) {
      log('❌ Error updating theme: $e');
      log('$s');

      emit(
        state.copyWith(status: ThemeStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
