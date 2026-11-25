import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/model/api_response.dart';
import '../../../user/domain/entities/preference_model.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/definitions.dart';
import '../../domain/repository/repository.dart';
import '../../domain/usecase/fetch.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit({required this._repository}) : super(CountryState());

  final CountryBaseRepository _repository;

  TextEditingController searchController = TextEditingController();

  static CountryCubit get(BuildContext context) =>
      BlocProvider.of<CountryCubit>(context);

  List<Countries> _countries = [];
  List<Countries> _filteredCountries = [];

  List<Countries> get countries {
    if (searchController.text.isEmpty) {
      return _countries;
    }
    return _filteredCountries;
  }

  void clearSelection() {
    emit(state.copyWith(status: CountryStatus.success, selectedCountry: null));
  }

  void fetchCountries() async {
    emit(state.copyWith(status: CountryStatus.loading));
    try {
      final useCase = FetchCountries(repository: _repository);
      final ApiResponse<Definitions> response = await useCase.call();
      _countries.clear();
      _countries.addAll(response.record.countries);

      _filteredCountries.clear();
      searchController.clear();
      emit(
        state.copyWith(
          status: CountryStatus.success,
          preference: response.record.preference,
        ),
      );
    } catch (e, s) {
      log("error: $e");
      log("stack: $s");
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(status: CountryStatus.error, errorMessage: errorToShow),
      );
    }
  }

  void selectCountry(Countries country) {
    emit(
      state.copyWith(
        status: CountryStatus.selectCountry,
        selectedCountry: country,
      ),
    );
  }

  void searchCountries(String query) {
    emit(state.copyWith(status: CountryStatus.loading));
    if (query.isEmpty) {
      _filteredCountries.clear();
    } else {
      _filteredCountries = _countries
          .where(
            (country) =>
                country.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    final newStatus = (state.status == CountryStatus.selectCountry)
        ? CountryStatus.selectCountry
        : CountryStatus.success;
    emit(state.copyWith(status: newStatus));
  }

  Countries? getSelectedCountry() {
    return state.selectedCountry;
  }

  bool hasSelectedCountry() {
    return state.selectedCountry != null;
  }

  void reset() {
    _countries = [];
    emit(const CountryState());
  }
}
