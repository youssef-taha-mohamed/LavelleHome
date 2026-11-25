import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/authentication/provider.dart';
import '../../../../../core/service/navigation_service.dart';
import '../../../../../shared/model/api_response.dart';
import '../../../../user/domain/entities/user.dart';
import '../../../domain/entities/login_credentials.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState()) {
    _initializeControllers();
  }

  factory LoginCubit.of(BuildContext context) {
    return BlocProvider.of<LoginCubit>(context);
  }

  final TextEditingController userNameController =
      TextEditingController(text: '');//(text: "youssef.taha.mohamedd@gmail.com");//(text: 'Test10');
  final TextEditingController passwordController =
      TextEditingController(text: '');
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  User? user;
  final context = NavigationService.navigatorKey.currentContext!;

  void _initializeControllers() {
    userNameController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }

  void validateForm() {
    final isEmailValid = userNameController.text.isNotEmpty;
    final isPasswordValid = passwordController.text.isNotEmpty &&
        passwordController.text.length >= 8;

    final isFormValid = isEmailValid && isPasswordValid;

    emit(state.copyWith(
      isFormValid: isFormValid,
      status: state.status == LoginStatus.error ? LoginStatus.initial : state.status,
    ));
  }

  Future<void> login() async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final ApiResponse<User> result =
          await AuthenticationProvider.instance.login(
        credentials: LoginCredentials(
          username: userNameController.text,
          password: passwordController.text,
        ),
      );
      final User user = result.record;
      this.user = user;

      if (!user.details.emailVerified) {
        emit(state.copyWith(
            status: LoginStatus.emailNotVerified,
            successMessage: result.message));
      } else {
        emit(state.copyWith(
          status: LoginStatus.success,
          successMessage: result.message,
        ));
      }
    } catch (e, s) {
      log('login error', error: e);
      log('login stack trace', stackTrace: s);
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(state.copyWith(
        status: LoginStatus.error,
        errorMessage: errorToShow,
      ));
    }
  }

  void dispose() {
    userNameController.removeListener(validateForm);
    passwordController.removeListener(validateForm);
    userNameController.dispose();
    passwordController.dispose();
    userNameFocusNode.unfocus();
    passwordFocusNode.unfocus();
  }
}
