import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/authentication/provider.dart';
import '../../../../../shared/enum/user_role.dart';
import '../../../../../shared/model/api_response.dart';
import '../../../domain/entities/parameter/parameter.dart';
import '../../../domain/repository/repository.dart';
import '../../../domain/usecase/read.dart';
import '../../provider/provider_count.dart';

part 'read_notification_state.dart';

class ReadNotificationCubit extends Cubit<ReadNotificationState> {
  ReadNotificationCubit({
    required this.repo,
  }) : super(ReadNotificationState());

  final NotificationBaseRepository repo;

  Future<void> readNotification({
    required NotificationParameter parameter,
  }) async {
    emit(
      state.copyWith(
        status: ReadNotificationStatus.loading,
      ),
    );
    try {
      final useCase = ReadUseCase(repository: repo);
      final effectiveId = _getEffectiveChildId(parameter.childId);
      final ApiResponse<Map> result = await useCase.call(
        parameters: parameter.copyWith(
          childId: effectiveId,
          clearChildId: effectiveId == null,
        ),
      );
      emit(
        state.copyWith(
          status: ReadNotificationStatus.success,
          successMessage: result.message,
        ),
      );
      await NotificationsProvider.reFetchNotificationCount();
    } catch (e, s) {
      log("Error: $e");
      log("Stack: $s");
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(
          status: ReadNotificationStatus.error,
          errorMessage: errorToShow,
        ),
      );
    }
  }
  String? _getEffectiveChildId(String? childId) {
    final user = AuthenticationProvider.instance.currentUser;
    if (user != null && user.details.role == UserRole.parent) {
      if (childId == null || childId == user.details.id) {
        return null;
      }
    }
    return childId;
  }
}
