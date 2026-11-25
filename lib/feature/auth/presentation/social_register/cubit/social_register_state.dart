part of 'social_register_cubit.dart';

enum SocialRegisterStatus {
  initial,
  loading,
  success,
  error,
  countrySelected,
  loadingCountry,
}

class SocialRegisterState extends Equatable {
  final SocialRegisterStatus status;
  final String? successMessage;
  final String? errorMessage;
  final bool isFormValid;
  final bool agreeToTerms;
  final DateTime? birthDate;
  final num? selectedCountryId;
  final PreferenceModel? preference;

  const SocialRegisterState({
    this.status = SocialRegisterStatus.initial,
    this.successMessage,
    this.errorMessage,
    this.isFormValid = false,
    this.agreeToTerms = false,
    this.birthDate,
    this.selectedCountryId,
    this.preference,
  });

  bool get isLoading  => status == SocialRegisterStatus.loading;
  bool get isSuccess  => status == SocialRegisterStatus.success;
  bool get isError    => status == SocialRegisterStatus.error;

  SocialRegisterState copyWith({
    SocialRegisterStatus? status,
    String? successMessage,
    String? errorMessage,
    bool? isFormValid,
    bool? agreeToTerms,
    DateTime? birthDate,
    num? selectedCountryId,
    PreferenceModel? preference,
  }) {
    return SocialRegisterState(
      status:            status            ?? this.status,
      successMessage:    successMessage    ?? this.successMessage,
      errorMessage:      errorMessage      ?? this.errorMessage,
      isFormValid:       isFormValid       ?? this.isFormValid,
      agreeToTerms:      agreeToTerms      ?? this.agreeToTerms,
      birthDate:         birthDate         ?? this.birthDate,
      selectedCountryId: selectedCountryId ?? this.selectedCountryId,
      preference:        preference        ?? this.preference,
    );
  }

  @override
  List<Object?> get props => [
        status,
        successMessage,
        errorMessage,
        isFormValid,
        agreeToTerms,
        birthDate,
        selectedCountryId,
        preference,
      ];
}
