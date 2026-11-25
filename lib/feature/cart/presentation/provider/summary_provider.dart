import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../shared/model/api_response.dart';
import '../../domain/entities/summary.dart';
import '../../domain/repository/repository.dart';
import '../../domain/use_case/summary.dart';

enum SummaryProviderState { initial, loading, success, error }

class SummaryProvider extends ChangeNotifier {
  final CartBaseRepository _repository;

  SummaryProvider({required this._repository});

  OrderSummary? summary;

  SummaryProviderState _state = SummaryProviderState.initial;

  SummaryProviderState get state => _state;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  String? _successMessage;

  String? get successMessage => _successMessage;

  void _setState(SummaryProviderState newState) {
    log('CART_PROVIDER_STATE: Setting state from $_state to $newState');
    _state = newState;
    notifyListeners();
  }

  Future<void> getSummary({required num cartId}) async {
    _setState(SummaryProviderState.loading);
    _errorMessage = null;
    _successMessage = null;

    try {
      final useCase = SummaryUseCase(repository: _repository);
      final ApiResponse<OrderSummary> result = await useCase.call(
        cartId: cartId,
      );
      summary = result.record;
      _setState(SummaryProviderState.success);
    } catch (e, s) {
      log('Error Summary Ya Youssef $e');
      log('Error Summary Location Ya Youssef $s');
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      _errorMessage = errorToShow;
      _setState(SummaryProviderState.error);
    }
  }

  void clearError() {
    _errorMessage = null;
  }

  void clearSuccessMessage() {
    _successMessage = null;
  }
}
