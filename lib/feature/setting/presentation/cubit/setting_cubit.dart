import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user/domain/repositories/user.dart';
import '../../../user/domain/use_cases/delete_account.dart';
import '../../../user/domain/use_cases/user_toggle_notifications.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit({required this.repository}) : super(const SettingState());

  final UserBaseRepository repository;

  Future<void> toggleNotification() async {
    emit(state.copyWith(status: SettingStatus.loadingToggle));

    try {
      final useCase = UserToggleNotification(repository: repository);
      final result = await useCase.call();

      if (result.status) {
        emit(
          state.copyWith(
            status: SettingStatus.successToggle,
            successMessage: result.message,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SettingStatus.errorToggle,
            errorMessage: result.message,
          ),
        );
      }
    } catch (e, s) {
      log("Error toggling notification: $e");
      log("Stack trace: $s");

      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(
          status: SettingStatus.errorToggle,
          errorMessage: errorToShow,
        ),
      );
    }
  }

  Future<void> deleteAccount({String? childId}) async {
    emit(state.copyWith(status: SettingStatus.loadingDelete));

    try {
      final useCase = DeleteAccountUseCase(repository: repository);
      final result = await useCase.call(childId: childId ?? "");

      if (result.status) {
        emit(
          state.copyWith(
            status: SettingStatus.successDelete,
            successMessage: result.message,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SettingStatus.errorDelete,
            errorMessage: result.message,
          ),
        );
      }
    } catch (e, s) {
      log("Error deleting account: $e");
      log("Stack trace: $s");

      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(
          status: SettingStatus.errorDelete,
          errorMessage: errorToShow,
        ),
      );
    }
  }
}
