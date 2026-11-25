import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/model/api_response.dart';
import '../../../../user/domain/entities/user.dart';
import '../../../../user/domain/repositories/user.dart';
import '../../../../user/domain/use_cases/resend_otp.dart';
import '../../../data/repositories/authentication.dart';
import '../../../domain/entities/otp_confirmation_parameters.dart';
import '../../../domain/use_cases/confirm_otp_to_reset_password.dart';

part 'otp_change_password_state.dart';

class OtpChangePasswordCubit extends Cubit<OtpChangePasswordState> {
  OtpChangePasswordCubit({
    required this._repository,
    required this._userRepository,
  }) : super(OtpChangePasswordState());

  factory OtpChangePasswordCubit.of(BuildContext context) {
    return BlocProvider.of<OtpChangePasswordCubit>(context);
  }

  final AuthenticationRepository _repository;
  final UserBaseRepository _userRepository;

  User? user;
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> verifyOtpChangePassword(String email) async {
    emit(state.copyWith(status: OtpChangePasswordStatus.loading));
    try {
      if (!formKey.currentState!.validate()) {
        emit(
          state.copyWith(
            status: OtpChangePasswordStatus.notValidOTP,
            formError: 'Please enter a valid OTP',
          ),
        );
        return;
      }

      final otp = otpController.text;

      final useCase = ConfirmOtpToResetPassword(repository: _repository);
      final ApiResponse<String> result = await useCase.call(
        parameters: OtpConfirmationParameters(otp: otp, email: email),
      );
      emit(
        state.copyWith(
          status: OtpChangePasswordStatus.success,
          successMessage: result.message,
          userId: result.record,
        ),
      );
    } catch (e, s) {
      log('verifyOtpChangePassword error', error: e);
      log('verifyOtpChangePassword stack trace', stackTrace: s);
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(
          status: OtpChangePasswordStatus.error,
          errorMessage: errorToShow,
        ),
      );
    }
  }

  Future<void> resendOtp(String email) async {
    try {
      final ApiResponse result = await ResendOtp(
        repository: _userRepository,
      ).call(email: email);
      emit(
        state.copyWith(
          status: OtpChangePasswordStatus.resendOtp,
          successMessage: result.message,
        ),
      );
    } catch (e, s) {
      log('resendOtp error', error: e);
      log('resendOtp stack trace', stackTrace: s);
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(
          status: OtpChangePasswordStatus.errorResend,
          errorMessage: errorToShow,
        ),
      );
    }
  }

  void onOtpChanged(String value) {
    _resetErrorState();
  }

  void _resetErrorState() {
    final bool isError =
        state.status == OtpChangePasswordStatus.error ||
        state.status == OtpChangePasswordStatus.notValidOTP ||
        state.status == OtpChangePasswordStatus.errorResend;

    if (isError) {
      emit(
        state.copyWith(
          status: OtpChangePasswordStatus.initial,
          errorMessage: null,
          formError: null,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    // Safely remove listener if it was added (extra safety)
    try {
      otpController.removeListener(_resetErrorState);
    } catch (_) {}

    // Dispose the controller, but catch errors if it was already disposed by another process
    try {
      otpController.dispose();
    } catch (e) {
      log('Error disposing otpController: $e');
    }
    return super.close();
  }
}
