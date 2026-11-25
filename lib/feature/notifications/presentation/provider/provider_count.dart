import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../shared/model/api_response.dart';
import '../../domain/entities/parameter/parameter.dart';
import '../../domain/repository/repository.dart';
import '../../domain/usecase/count.dart';

final class NotificationsProvider {
  NotificationsProvider._();

  static NotificationsProvider get instance {
    if (!_hasInit) {
      init(repository: DependencyInjector.notificationRepo);
    }
    return NotificationsProvider._();
  }

  static bool _hasInit = false;
  static late BehaviorSubject<int> _notificationsCountController;
  static late NotificationBaseRepository _repository;
  static StreamSubscription? _authSubscription;
  static StreamSubscription? _fcmSubscription;

  static void init({required NotificationBaseRepository repository}) {
    if (_hasInit) {
      log("🔔 NotificationsProvider already initialized. Skipping.");
      return;
    }
    _repository = repository;
    _notificationsCountController = BehaviorSubject<int>.seeded(0);
    _startListening();
    _hasInit = true;
  }

  void dispose() {
    _notificationsCountController.close();
  }

  static void _startListening() {
    _fcmSubscription?.cancel();
    _fcmSubscription = FirebaseMessaging.onMessage.listen((message) {
      final auth = AuthenticationProvider.instance;

      if (!auth.canRegisterFcmToken) return;

      reFetchNotificationCount();
    });

    _authSubscription?.cancel();
    _authSubscription = AuthenticationProvider.instance
        .authStateChanges()
        .distinct()
        .listen((isAuth) {
      if (!isAuth) {
        _notificationsCountController.sink.add(0);
        return;
      }

      final auth = AuthenticationProvider.instance;
      if (!auth.canRegisterFcmToken) return;

      reFetchNotificationCount();
    });
  }

  static bool _isFetching = false;

  static Future<void> reFetchNotificationCount() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final auth = AuthenticationProvider.instance;

      if (!auth.canRegisterFcmToken) {
        _notificationsCountController.sink.add(0);
        return;
      }

      log("🔔 NotificationsProvider: reFetchNotificationCount triggered");
      final usecase = FetchNotificationsCount(repository: _repository);
      final ApiResponse<int> count = await usecase.call(
        parameters: NotificationParameter(),
      );
      _notificationsCountController.sink.add(count.record);
    } catch (e) {
      log("Error: $e");
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      _notificationsCountController.addError(errorToShow);
    } finally {
      _isFetching = false;
    }
  }

  Stream<int> get notificationsCount {
    return _notificationsCountController.stream;
  }

  static Future<void> markAsReadAll() async {
    _notificationsCountController.sink.add(0);
  }

  static void updateCount(int i) {
    _notificationsCountController.sink.add(i);
  }
}
