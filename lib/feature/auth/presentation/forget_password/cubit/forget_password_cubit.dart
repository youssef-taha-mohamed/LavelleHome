import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/model/api_response.dart';
import '../../../data/repositories/authentication.dart';
import '../../../domain/use_cases/send_otp_to_reset_password.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit({required this.repository})
      : super(ForgetPasswordState()) {
    _initializeControllers();
  }

  final AuthenticationRepository repository;

  factory ForgetPasswordCubit.of(BuildContext context) {
    return BlocProvider.of<ForgetPasswordCubit>(context);
  }

  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  void _initializeControllers() {
    emailController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = emailController.text;
    final bool isEmailValid = email.isNotEmpty && 
        RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
 
    final bool isErrorState = state.status == ForgetPasswordStatus.error;
 
    emit(
      state.copyWith(
        isFormValid: isEmailValid,
        status: isErrorState ? ForgetPasswordStatus.initial : state.status,
        errorMessage: isErrorState ? null : state.errorMessage,
      ),
    );
  }

  Future<void> sendEmail() async {
    if (formKey.currentState!.validate()) {
      emit(state.copyWith(status: ForgetPasswordStatus.loading));
      try {
        final useCase = SendOtpToResetPassword(repository: repository);
        final ApiResponse response =
            await useCase.call(email: emailController.text);
        emit(
          state.copyWith(
            status: ForgetPasswordStatus.success,
            successMessage: response.message,
          ),
        );
      } catch (e, s) {
        log('sendEmail error', error: e);
        log('sendEmail stack trace', stackTrace: s);
        String errorToShow = e.toString();

        if (e is DioException) {
          errorToShow = e.message ?? "";
        }
        emit(
          state.copyWith(
            status: ForgetPasswordStatus.error,
            errorMessage: errorToShow,
          ),
        );
      }
    }
  }

  void dispose() {
    emailController.removeListener(_validateForm);
    emailController.dispose();
    emailFocusNode.dispose();
  }
}
