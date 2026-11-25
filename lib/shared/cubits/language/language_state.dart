part of 'language_cubit.dart';

enum LanguageStatus {
  idle,
  loading,
  changed,
  error,
  loadingUpdate,
  successUpdate,
  loadingLanguage,
  successLanguage,
}

extension LanguageStatusExtension on LanguageState {
  bool get isIdle => status == LanguageStatus.idle;

  bool get isLoading => status == LanguageStatus.loading;

  bool get isChanged => status == LanguageStatus.changed;

  bool get isError => status == LanguageStatus.error;

  bool get isLoadingUpdate => status == LanguageStatus.loadingUpdate;

  bool get isSuccessUpdate => status == LanguageStatus.successUpdate;

  bool get isLoadingLanguage => status == LanguageStatus.loadingLanguage;

  bool get isSuccessLanguage => status == LanguageStatus.successLanguage;
}

class LanguageState extends Equatable {
  final String languageCode;
  final LanguageStatus status;
  final String? errorMessage;
  final List<LanguageModel> languages;
  final List<ThemeModel> themes;

  const LanguageState({
    this.languageCode = "",
    this.status = LanguageStatus.idle,
    this.errorMessage,
    this.languages = const [],
    this.themes = const [],
  });

  LanguageState copyWith({
    String? languageCode,
    LanguageStatus? status,
    String? errorMessage,
    List<LanguageModel>? languages,
    List<ThemeModel>? themes,
  }) {
    return LanguageState(
      languageCode: languageCode ?? this.languageCode,
      status: status ?? this.status,
      errorMessage: errorMessage,
      languages: languages ?? this.languages,
      themes: themes ?? this.themes,
    );
  }

  @override
  List<Object?> get props => [
        languageCode,
        status,
        errorMessage,
        languages,
        themes,
      ];
}
