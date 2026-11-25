import 'package:equatable/equatable.dart';

base class Preference extends Equatable {
  final num theme;
  final num languageId;
  final String languageName;
  final String languageCode;

  const Preference({
    required this.theme,
    required this.languageId,
    required this.languageName,
    required this.languageCode,
  });

  Preference copyWith({
    num? theme,
    num? languageId,
    String? languageName,
    String? languageCode,
  }) {
    return Preference(
      theme: theme ?? this.theme,
      languageId: languageId ?? this.languageId,
      languageName: languageName ?? this.languageName,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [theme, languageId, languageName, languageCode];
}
