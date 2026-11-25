import 'dart:developer';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:requests_inspector/requests_inspector.dart';
import '../../../../feature/auth/presentation/login/view/login.dart';
import '../../../../l10n/l10n.dart';
import '../../../authentication/provider.dart';
import '../../../db/kv_db/hive.dart';
import '../../../di/dependency_injector.dart';
import '../../../service/navigation_service.dart';

import '../../../constant/endpoint.dart';

final ValueNotifier<bool> inspectorNotifier = ValueNotifier(false);
bool get inspectorEnabled => inspectorNotifier.value;
set inspectorEnabled(bool value) => inspectorNotifier.value = value;

final class DioClient {
  late final Dio _dio;

  static DioClient? _singleton;

  factory DioClient() {
    _singleton ??= DioClient._internal();
    return _singleton!;
  }

  void updateSettings() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
  }

  DioClient._internal() {
    final options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(milliseconds: 100000),
      receiveTimeout: Duration(milliseconds: 100000),
      sendTimeout: kIsWeb ? null : const Duration(milliseconds: 100000),
      validateStatus: (status) {
        return true;
      },
      receiveDataWhenStatusError: true,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    // Always add inspector interceptor so requests are logged.
    // The inspector UI visibility is controlled by inspectorNotifier in konoz.dart.
    _dio.interceptors.add(RequestsInspectorInterceptor());
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final context = NavigationService.navigatorKey.currentContext;
          final bool hasNet =
              await DependencyInjector.networkService.isConnected;
          if (!hasNet && context != null && context.mounted) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: "",
                message: context.l10n.no_internet_connection,
              ),
            );
          }

          options.headers.addAll({
            "Content-Type": "application/json",
            "Accept": "application/json",
          });

          if (!kIsWeb &&
              defaultTargetPlatform == TargetPlatform.iOS &&
              kDebugMode == false) {
            final packageInfo = await PackageInfo.fromPlatform();
            options.headers['ios_version'] = packageInfo.version;
          }

          final isAuthEndpoint =
              options.path.contains('/Auth/') ||
              options.path.contains('/auth/');

          if (!isAuthEndpoint) {
            String? tkn =
                AuthenticationProvider.instance.currentUser?.accessToken;

            // Fail-safe for Web/Startup: If token is null in provider, try pulling directly from Cache
            if (tkn == null) {
              tkn = await DependencyInjector.hiveAuthenticationCache
                  .cachedToken();
              if (tkn != null) {
                log(
                  '🔑 DioInterceptor: Found token in Cache (Provider was not ready)',
                );
              }
            }
            if (tkn != null) {
              options.headers['Authorization'] = 'Bearer $tkn';
            }
          }
          final locale = HiveDatabase.getLanguageCode() ?? 'ar';
          options.headers['Accept-Language'] = locale;

          if (kDebugMode || kIsWeb) {
            debugPrint('🌐 [Dio] ${options.method} -> ${options.uri}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode == 401) {
            log('401 Unauthorized - Logging out user and redirecting to login');

            await AuthenticationProvider.instance.logoutLocally();
            NavigationService.navigatorKey.currentState
                ?.pushNamedAndRemoveUntil(
                  LoginView.routeName,
                  (route) => false,
                );

            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                message: 'Unauthorized (401). User logged out.',
              ),
            );
          }

          try {
            if (response.data is Map) {
              final json = Map<String, dynamic>.from(response.data as Map);

              if (response.statusCode == 500) {
                if (json['error']?['error_message'] == 'Unauthorized') {
                  log('500 with "Unauthorized" message - Treating as 401');

                  await AuthenticationProvider.instance.logoutLocally();
                  NavigationService.navigatorKey.currentState
                      ?.pushNamedAndRemoveUntil(
                        LoginView.routeName,
                        (route) => false,
                      );

                  return handler.reject(
                    DioException(
                      requestOptions: response.requestOptions,
                      response: response,
                      message: 'Unauthorized (500). User logged out.',
                    ),
                  );
                }
              }
            }
          } catch (e) {
            log('Dio interceptor onResponse parsing error: $e');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          final context = NavigationService.navigatorKey.currentContext;
          String errorMessage = "";

          if ((e.type == DioExceptionType.connectionError ||
                  e.type == DioExceptionType.connectionTimeout ||
                  e.type == DioExceptionType.receiveTimeout) &&
              context != null) {
            errorMessage = context.l10n.no_internet_connection;
          } else {
            if (context != null) errorMessage = context.l10n.unexpected_error;
          }

          return handler.next(e.copyWith(message: errorMessage));
        },
      ),
    );
    _dio.interceptors.add(
      PrettyDioLogger(
        responseBody: false,
        requestHeader: true,
        requestBody: false,
        responseHeader: false,
        logPrint: (object) => log('$object'),
      ),
    );
  }

  Dio get instance => _dio;
}
