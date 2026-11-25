import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/service/navigation_service.dart';
import '../../../../../shared/model/api_response.dart';
import '../../../data/repositories/authentication.dart';
import '../../../domain/entities/reset_password_parameters.dart';
import '../../../domain/use_cases/reset_password.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({required this._repository})
    : super(ResetPasswordState()) {
    _initializeControllers();
  }

  void _initializeControllers() {
    passwordController.addListener(() {
      _resetErrorState();
      validateForm();
    });
    confirmPasswordController.addListener(() {
      _resetErrorState();
      validateForm();
    });
  }

  void _resetErrorState() {
    if (state.status == ResetPasswordStatus.error) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.initial,
          formError: null,
          error: null,
        ),
      );
    }
  }

  final AuthenticationRepository _repository;

  factory ResetPasswordCubit.of(BuildContext context) {
    return BlocProvider.of<ResetPasswordCubit>(context);
  }

  final context = NavigationService.navigatorKey.currentContext!;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  void validateForm() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    final bool isPasswordValid =
        RegExp(
          r'^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{}|\\:;"<>,./?`~]+$',
        ).hasMatch(password) &&
        password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*()_+\-=\[\]{}|\\:;"<>,./?`~]').hasMatch(password);

    final bool isConfirmValid =
        confirmPassword == password && confirmPassword.isNotEmpty;

    emit(state.copyWith(isFormValid: isPasswordValid && isConfirmValid));
  }

  Future<void> resetPassword({
    required String email,
    required String userId,
  }) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading, formError: null));
    try {
      final useCase = ResetPassword(repository: _repository);
      final ApiResponse result = await useCase.call(
        parameters: ResetPasswordParameters(
          password: passwordController.text,
          email: email,
          userId: userId,
        ),
      );
      emit(
        state.copyWith(
          status: ResetPasswordStatus.success,
          successMessage: result.message,
        ),
      );
    } catch (e, s) {
      log('Error Type : $e');
      log('Error Stack : $s');

      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(status: ResetPasswordStatus.error, error: errorToShow),
      );
    }
  }

  @override
  Future<void> close() {
    passwordController.removeListener(_resetErrorState);
    confirmPasswordController.removeListener(_resetErrorState);
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
