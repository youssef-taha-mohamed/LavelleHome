import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/authentication/provider.dart';
import '../../../../../shared/enum/user_role.dart';
import '../../../../../shared/model/api_response.dart';
import '../../../../../shared/model/pagination.dart';
import '../../../data/model/notification_modal.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/entities/notification_modal.dart';
import '../../../domain/entities/parameter/notification_parameter.dart';
import '../../../domain/entities/parameter/parameter.dart';
import '../../../domain/enum/type.dart';
import '../../../domain/repository/repository.dart';
import '../../../data/model/notification_model.dart';
import '../../../domain/usecase/clear.dart';
import '../../../domain/usecase/delete.dart';
import '../../../domain/usecase/list.dart';
import '../../../domain/usecase/read.dart';
import '../../../domain/usecase/read_all.dart';
import '../../provider/provider_count.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({required this.repo}) : super(NotificationsState());

  static NotificationsCubit get(BuildContext context) {
    return BlocProvider.of<NotificationsCubit>(context);
  }

  final NotificationBaseRepository repo;
  final int _limit = 15;

  Future<void> changeFilter(NotificationType type, {String? childId}) async {
    if (state.selectedType == type) return;

    emit(
      state.copyWith(
        selectedType: type,
        page: 1,
        notifications: null,
        hasReachedMax: false,
        status: NotificationStatus.loading,
      ),
    );

    await getNotifications(childId: _getEffectiveChildId(childId));
  }

  Future<void> getNotifications({
    bool refresh = false,
    bool loadMore = false,
    String? childId,
  }) async {
    final effectiveChildId = _getEffectiveChildId(childId);
    if (refresh) {
      emit(state.copyWith(
        status: NotificationStatus.loading,
        page: 1,
        hasReachedMax: false,
      ));
    } else {
      if (state.notifications?.notifications.isEmpty ?? true) {
        emit(
          state.copyWith(
            status: NotificationStatus.loading,
          ),
        );
      }
    }
    try {
      final useCase = NotificationsUseCase(repository: repo);
      final int currentPage = refresh ? 1 : state.page;

      final ApiResponse<NotificationsApp> result = await useCase.call(
        parameters: NotificationListParameter(
          type: NotificationType.fromId(state.selectedType.id),
          pagination: Pagination(
            page: currentPage,
            limit: _limit,
          ),
          childId: effectiveChildId,
        ),
      );

      final NotificationsApp data = result.record;
      final List<NotificationModel> newNotifications = data.notifications;
      final bool hasReachedMax = newNotifications.length < _limit;

      emit(
        state.copyWith(
          status: NotificationStatus.loaded,
          notifications: data,
          hasReachedMax: hasReachedMax,
          page: currentPage + 1,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } catch (e, s) {
      log("Error: $e");
      log("Stack: $s");
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(
            status: NotificationStatus.error, errorMessage: errorToShow),
      );
    }
  }

  Future<void> loadMoreNotifications({String? childId}) async {
    final effectiveChildId = _getEffectiveChildId(childId);
    if (state.hasReachedMax || state.status == NotificationStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: NotificationStatus.loadingMore));

    try {
      final useCase = NotificationsUseCase(repository: repo);

      final ApiResponse<NotificationsApp> result = await useCase.call(
        parameters: NotificationListParameter(
          type: NotificationType.fromId(state.selectedType.id),
          pagination: Pagination(
            page: state.page,
            limit: _limit,
          ),
          childId: effectiveChildId,
        ),
      );

      final NotificationsApp data = result.record;
      final List<NotificationModel> newNotifications = data.notifications;

      if (newNotifications.isEmpty) {
        emit(state.copyWith(
            hasReachedMax: true, status: NotificationStatus.loaded));
      } else {
        final List<NotificationModel> totalNotifications = [
          ...?state.notifications?.notifications,
          ...newNotifications
        ];

        final updatedNotifications =
            (state.notifications as NotificationsAppDTO).copyWith(
          notifications: totalNotifications,
        );

        emit(state.copyWith(
          status: NotificationStatus.loaded,
          notifications: updatedNotifications,
          hasReachedMax: newNotifications.length < _limit,
          page: state.page + 1,
        ));
      }
    } catch (e, s) {
      log("Error: $e");
      log("Stack: $s");
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(
            status: NotificationStatus.error, errorMessage: errorToShow),
      );
    }
  }

  Future<void> readAll({
    required NotificationParameter parameter,
  }) async {
    emit(
      state.copyWith(
        statusReadAll: NotificationStatus.loading,
      ),
    );
    try {
      final useCase = ReadAllUseCase(repository: repo);
      final effectiveId = _getEffectiveChildId(parameter.childId);
      final ApiResponse<Map> result = await useCase.call(
        parameters: parameter.copyWith(
          childId: effectiveId,
          clearChildId: effectiveId == null,
        ),
      );
      emit(
        state.copyWith(
          statusReadAll: NotificationStatus.loaded,
          successMessage: result.message,
        ),
      );
      getNotifications(
        childId: _getEffectiveChildId(parameter.childId),
        refresh: true,
      );
      await NotificationsProvider.markAsReadAll();
    } catch (e, s) {
      log("Error: $e");
      log("Stack: $s");
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(
          statusReadAll: NotificationStatus.error,
          errorMessage: errorToShow,
        ),
      );
    }
  }

  Future<void> readNotification({
    required NotificationParameter parameter,
  }) async {
    final currentNotifications = state.notifications?.notifications ?? [];
    final index = currentNotifications.indexWhere(
      (n) => n.notificationId == parameter.notificationId,
    );

    if (index != -1 && !currentNotifications[index].isRead) {
      // 1. Optimistic update (optional but good for UX) or just wait for API
      // I'll do it after a successful API call to be safe, or before if we want speed.
      // Let's do it after to ensure consistency with backend.

      try {
        final useCase = ReadUseCase(repository: repo);
        final effectiveId = _getEffectiveChildId(parameter.childId);
        await useCase.call(
          parameters: parameter.copyWith(
            childId: effectiveId,
            clearChildId: effectiveId == null,
          ),
        );

        // 2. Update local state
        final updatedList = List<NotificationModel>.from(currentNotifications);
        final oldNotif = updatedList[index];

        if (oldNotif is NotificationDTO) {
          updatedList[index] = oldNotif.copyWith(isRead: true);
        } else {
          // Fallback if it's not a DTO for some reason
          updatedList[index] =
              NotificationDTO.fromEntity(oldNotif).copyWith(isRead: true);
        }

        final updatedApp =
            (state.notifications as NotificationsAppDTO).copyWith(
          notifications: updatedList,
        );

        emit(state.copyWith(
          notifications: updatedApp,
          readStatus: NotificationStatus.loaded,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));

        // 3. Update global count
        await NotificationsProvider.reFetchNotificationCount();
      } catch (e) {
        String errorToShow = e.toString();

        if (e is DioException) {
          errorToShow = e.message ?? "";
        }
        log("Error reading notification: $e");
        emit(
          state.copyWith(
            readStatus: NotificationStatus.error,
            errorMessage: errorToShow,
          ),
        );
      }
    }
  }

  Future<void> delete({
    required NotificationParameter parameter,
  }) async {
    emit(
      state.copyWith(
        statusDelete: NotificationStatus.loading,
      ),
    );
    try {
      final useCase = DeleteUseCase(repository: repo);
      final effectiveId = _getEffectiveChildId(parameter.childId);
      final ApiResponse<Map> result = await useCase.call(
        parameters: parameter.copyWith(
          childId: effectiveId,
          clearChildId: effectiveId == null,
        ),
      );
      emit(
        state.copyWith(
          statusDelete: NotificationStatus.loaded,
          successMessage: result.message,
        ),
      );
      getNotifications(
        childId: _getEffectiveChildId(parameter.childId),
        refresh: false,
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
          statusDelete: NotificationStatus.error,
          errorMessage: errorToShow,
        ),
      );
    }
  }

  Future<void> clear({
    required NotificationParameter parameter,
  }) async {
    emit(
      state.copyWith(
        statusClear: NotificationStatus.loading,
      ),
    );
    try {
      final useCase = ClearUseCase(repository: repo);
      final effectiveId = _getEffectiveChildId(parameter.childId);
      final ApiResponse<Map> result = await useCase.call(
        parameters: parameter.copyWith(
          childId: effectiveId,
          clearChildId: effectiveId == null,
        ),
      );
      emit(
        state.copyWith(
          statusClear: NotificationStatus.loaded,
          successMessage: result.message,
        ),
      );
      getNotifications(
        childId: _getEffectiveChildId(parameter.childId),
        refresh: true,
      );
      await NotificationsProvider.markAsReadAll();
    } catch (e, s) {
      log("Error: $e");
      log("Stack: $s");
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(
          statusClear: NotificationStatus.error,
          errorMessage: errorToShow,
        ),
      );
    }
  }

  Future<void> allowNotification(bool allow) async {
    emit(state.copyWith(status: NotificationStatus.loading));
    try {
      final message = await repo.allowNotification(allow);

      emit(state.copyWith(
          status: NotificationStatus.loaded,
          successMessage: message,
          timestamp: DateTime.now().millisecondsSinceEpoch));
    } catch (e) {
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      emit(
        state.copyWith(
            status: NotificationStatus.error, errorMessage: errorToShow),
      );
    }
  }

  String? _getEffectiveChildId(String? childId) {
    final user = AuthenticationProvider.instance.currentUser;
    if (user != null && user.details.role == UserRole.parent) {
      // If childId is provided but it matches the parent's id, it's not a child context.
      if (childId == null || childId == user.details.id) {
        return null;
      }
    }
    return childId;
  }
}
