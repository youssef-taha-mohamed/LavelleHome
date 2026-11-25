part of 'theme_cubit.dart';

enum ThemeStatus {
  idle,
  loadingTheme,
  successTheme,
  loadingUpdate,
  successUpdate,
  error,
}

class ThemeState extends Equatable {
  final bool isDark;
  final ThemeMode themeMode;
  final ThemeStatus status;
  final List<ThemeModel> themes;
  final String? errorMessage;

  const ThemeState({
    this.isDark = false,
    this.themeMode = ThemeMode.light,
    this.status = ThemeStatus.idle,
    this.themes = const [],
    this.errorMessage,
  });

  ThemeState copyWith({
    bool? isDark,
    ThemeMode? themeMode,
    ThemeStatus? status,
    List<ThemeModel>? themes,
    String? errorMessage,
  }) {
    return ThemeState(
      isDark: isDark ?? this.isDark,
      themeMode: themeMode ?? this.themeMode,
      status: status ?? this.status,
      themes: themes ?? this.themes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isDark, themeMode, status, themes, errorMessage];
}
