import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/authentication/cache/base/auth.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../shared/model/api_response.dart';
import '../../../user/domain/entities/parameters/change_email_para.dart';
import '../../../user/domain/entities/user_details.dart';
import '../../../user/domain/repositories/user.dart';
import '../../../user/domain/use_cases/change_email.dart';
import '../../../user/domain/use_cases/confirm_change_email.dart';
import '../../../user/domain/use_cases/fetch_user_by_id.dart';
import '../../../user/domain/use_cases/resend_otp.dart';

part 'student_profile_state.dart';

class StudentProfileCubit extends Cubit<StudentProfileState> {
  final UserBaseRepository repository;
  final AuthenticationCache cache;

  StudentProfileCubit({
    required this.repository,
    required this.cache,
  }) : super(StudentProfileState()) {
    _initializeListeners();
  }

  // Controllers
  final TextEditingController newEmail = TextEditingController();
  final TextEditingController password = TextEditingController();
  final FocusNode newEmailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _initializeListeners() {
    newEmail.addListener(_validateForm);
    password.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = newEmail.text.isNotEmpty &&
        password.text.isNotEmpty &&
        password.text.length >= 6;
    if (isValid != state.isFormValid) {
      emit(
        state.copyWith(state: StudentProfileStateEnum.formValid),
      );
    }
  }

  Future<void> changeEmail() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    try {
      emit(
        state.copyWith(
          state: StudentProfileStateEnum.loading,
        ),
      );
      final useCase = ChangeEmail(repository: repository);
      final ApiResponse result = await useCase.call(
        parameters: ChangeEmailParameters(
          newEmail: newEmail.text,
          password: password.text,
          userId: AuthenticationProvider.instance.currentUser?.details.id ?? '',
        ),
      );
      emit(
        state.copyWith(
          state: StudentProfileStateEnum.emailChangedSuccess,
          successMessage: result.message,
        ),
      );
    } catch (e, s) {
      log('change email error', error: e, stackTrace: s);
      emit(state.copyWith(
        state: StudentProfileStateEnum.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<bool> confirmChangeEmail({required String otp}) async {
    try {
      emit(
        state.copyWith(state: StudentProfileStateEnum.loading),
      );
      final useCase = ConfirmChangeEmail(repository: repository);
      final ApiResponse result = await useCase.call(
        parameters: ChangeEmailParameters(
          newEmail: newEmail.text,
          otp: otp,
          userId: AuthenticationProvider.instance.currentUser?.details.id ?? '',
        ),
      );
      emit(
        state.copyWith(
          state: StudentProfileStateEnum.confirmOTPSuccess,
          successMessage: result.message,
        ),
      );
      return true;
    } catch (e, s) {
      log('confirm change email error', error: e, stackTrace: s);
      emit(state.copyWith(
        state: StudentProfileStateEnum.error,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  Future<void> fetchUserById({String? childId}) async {
    final userCash = AuthenticationProvider.instance.currentUser?.details;
    try {
      emit(
        state.copyWith(
          state: StudentProfileStateEnum.loadingUser,
          userDetails: await cache.cachedUser(),
        ),
      );

      final useCase = FetchUserById(repository: repository);
      final ApiResponse<UserDetails> user = await useCase.call(
        childId: userCash?.role.id == 3 ? childId ?? "" : '',
      );
      emit(
        state.copyWith(
          state: StudentProfileStateEnum.successFetchUser,
          userDetails: user.record,
          successMessage: user.message,
        ),
      );
    } catch (e, s) {
      log('fetch user by id error', error: e, stackTrace: s);
      emit(state.copyWith(
        state: StudentProfileStateEnum.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> resendOTP(String email) async {
    emit(state.copyWith(
      state: StudentProfileStateEnum.loading,
    ));
    try {
      final ApiResponse result = await ResendOtp(
        repository: repository,
      ).call(
        email: email,
      );
      emit(
        state.copyWith(
          state: StudentProfileStateEnum.resendOTPSuccess,
          successMessage: result.message,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        state: StudentProfileStateEnum.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void dispose() {
    newEmail.dispose();
    password.dispose();
    newEmailFocus.dispose();
    passwordFocus.dispose();
  }
}
