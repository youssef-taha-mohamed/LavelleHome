import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/authentication/provider.dart';
import '../../../../../shared/model/api_response.dart';
import '../../../../user/domain/entities/parameters/verify_account.dart';
import '../../../../user/domain/entities/user.dart';
import '../../../../user/domain/repositories/user.dart';
import '../../../../user/domain/use_cases/resend_otp.dart';

part 'otp_register_state.dart';

class OtpRegisterCubit extends Cubit<OtpRegisterState> {
  OtpRegisterCubit({required this._repository}) : super(OtpRegisterState());

  factory OtpRegisterCubit.of(BuildContext context) {
    return BlocProvider.of<OtpRegisterCubit>(context);
  }

  final UserBaseRepository _repository;
  User? user;
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void _resetErrorState() {
    final bool isError =
        state.status == OtpRegisterStatus.error ||
        state.status == OtpRegisterStatus.notValidOTP;

    if (isError) {
      emit(
        state.copyWith(
          status: OtpRegisterStatus.initial,
          errorMessage: null,
          formError: null,
        ),
      );
    }
  }

  void onOtpChanged(String value) {
    _resetErrorState();
    emit(state.copyWith(isFormValid: value.length == 6));
  }

  Future<void> verifyOtp(String email) async {
    emit(state.copyWith(status: OtpRegisterStatus.loading));
    try {
      final otp = otpController.text;

      final ApiResponse result = await AuthenticationProvider.instance
          .verifyAccount(
            parameters: VerifyAccountParameters(otp: otp, email: email),
          );

      emit(
        state.copyWith(
          status: OtpRegisterStatus.success,
          successMessage: result.message,
        ),
      );
    } catch (e, s) {
      log('verifyOtp error', error: e);
      log('verifyOtp stack trace', stackTrace: s);
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }

      emit(
        state.copyWith(
          status: OtpRegisterStatus.error,
          errorMessage: errorToShow,
        ),
      );
    }
  }

  Future<void> resendOtp(String email) async {
    emit(state.copyWith(status: OtpRegisterStatus.loading));
    try {
      final ApiResponse result = await ResendOtp(
        repository: _repository,
      ).call(email: email);
      emit(
        state.copyWith(
          status: OtpRegisterStatus.initial,
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
          status: OtpRegisterStatus.error,
          errorMessage: errorToShow,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    try {
      otpController.removeListener(_resetErrorState);
    } catch (_) {}
    try {
      otpController.dispose();
    } catch (e) {
      log('Error disposing otpController in OtpRegisterCubit: $e');
    }
    return super.close();
  }
}
