part of 'country_cubit.dart';

enum CountryStatus { initial, loading, success, error, selectCountry }

extension CountryStateX on CountryState {
  bool get isLoading => status == CountryStatus.loading;

  bool get isError => status == CountryStatus.error;

  bool get isInitial => status == CountryStatus.initial;

  bool get isSuccess => status == CountryStatus.success;

  bool get isSelectedCountry => status == CountryStatus.selectCountry;
}

class CountryState extends Equatable {
  final CountryStatus? status;
  final String? errorMessage;
  final PreferenceModel? preference;
  final Countries? selectedCountry;

  const CountryState({
    this.status = CountryStatus.initial,
    this.errorMessage,
    this.preference,
    this.selectedCountry,
  });

  CountryState copyWith({
    CountryStatus? status,
    String? errorMessage,
    PreferenceModel? preference,
    Countries? selectedCountry,
  }) {
    return CountryState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      preference: preference ?? this.preference,
      selectedCountry: selectedCountry ?? this.selectedCountry,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        preference,
        selectedCountry,
      ];
}
