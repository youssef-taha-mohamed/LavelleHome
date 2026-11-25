import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/authentication/provider.dart';
import '../../../../../shared/model/api_response.dart';
import '../../../../user/domain/entities/parameters/change_password.dart';
import '../../../../user/domain/repositories/user.dart';
import '../../../../user/domain/use_cases/change_password.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({
    required this.repository,
  }) : super(const ChangePasswordState()) {
    _initializeControllers();
  }

  final UserBaseRepository repository;

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  void _initializeControllers() {
    oldPassword.addListener(validateForm);
    newPassword.addListener(validateForm);
    confirmPassword.addListener(validateForm);
  }

  Future<void> changePassword() async {
    emit(
      state.copyWith(
        status: ChangePasswordStatus.loading,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      final useCase = ChangePassword(repository: repository);
      final ApiResponse result = await useCase.changePassword(
        parameters: ChangePasswordParameters(
          oldPassword: oldPassword.text,
          newPassword: newPassword.text,
          userId: AuthenticationProvider.instance.currentUser?.details.id ?? '',
          confirmPassword: confirmPassword.text,
        ),
      );

      oldPassword.clear();
      newPassword.clear();
      confirmPassword.clear();

      emit(
        state.copyWith(
          status: ChangePasswordStatus.success,
          successMessage: result.message,
        ),
      );
    } catch (e, s) {
      log('Error Type Ya Youssef $e');
      log('Error Location Ya Youssef $s');
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }

      emit(state.copyWith(
        status: ChangePasswordStatus.error,
        errorMessage: errorToShow,
      ));
    }
  }

  void validateForm() {
    final oldPass = oldPassword.text;
    final newPass = newPassword.text;
    final confirmPass = confirmPassword.text;

    bool isValid = oldPass.isNotEmpty &&
        RegExp(
          r'^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{}|\\:;"<>,./?`~]+$',
        ).hasMatch(newPass) &&
        newPass.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(newPass) &&
        RegExp(r'[a-z]').hasMatch(newPass) &&
        RegExp(r'[0-9]').hasMatch(newPass) &&
        RegExp(r'[!@#$%^&*()_+\-=\[\]{}|\\:;"<>,./?`~]').hasMatch(newPass) &&
        newPass != oldPass &&
        newPass == confirmPass &&
        confirmPass.isNotEmpty;

    final isErrorState = state.status == ChangePasswordStatus.error;

    emit(
      state.copyWith(
        isFormValid: isValid,
        status: isErrorState ? ChangePasswordStatus.initial : state.status,
        errorMessage: isErrorState ? null : state.errorMessage,
      ),
    );
  }

  @override
  Future<void> close() {
    oldPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    return super.close();
  }
}
