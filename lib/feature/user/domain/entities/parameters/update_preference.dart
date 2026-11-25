import 'package:equatable/equatable.dart';

base class UpdatePreference extends Equatable {
  final String? childId;
  final num themeId;
  final num languageId;

  const UpdatePreference({
    this.childId,
    required this.themeId,
    required this.languageId,
  });

  @override
  List<Object?> get props => [
        childId,
        themeId,
        languageId,
      ];
}
