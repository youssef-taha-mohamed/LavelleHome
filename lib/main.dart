import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'app/lavelle_home.dart';
import 'core/service/deep_link_service.dart';
import 'core/utils/crashlytics/app_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/di/dependency_injector.dart';
import 'feature/botttom_nav_bar/provider/nav_bar.dart';
import 'feature/cart/presentation/provider/provider.dart';
import 'feature/order/presentation/cubit/order_draft_cubit.dart';
import 'firebase_options.dart';
import 'core/db/kv_db/hive.dart';
import 'core/authentication/provider.dart';
import 'core/network/client/dio/client.dart';
import 'core/constant/endpoint.dart';
import 'shared/show_case/management/showcase_manager.dart';

class BlocObserverImp extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log(
      'onChange(${bloc.runtimeType}, ${change.currentState.runtimeType} -> ${change.nextState.runtimeType})',
    );
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('onEvent(${bloc.runtimeType}, ${event.runtimeType})');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log(
      'onTransition(${bloc.runtimeType}, ${transition.currentState.runtimeType} -> ${transition.nextState.runtimeType})',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error)');
    AppCrashlytics.recordError(error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('onCreate(${bloc.runtimeType})');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('onClose(${bloc.runtimeType})');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      final i = int.tryParse(message.notification?.apple?.badge ?? '');
      if (i != null) FlutterAppBadge.count(i);
    }
  } catch (e) {
    debugPrint('[FCM] Background handling error: $e');
  }
}

/// 1. تهيئة التوقيت المحلي للمنطقة
Future<void> _initTimezone() async {
  try {
    tz.initializeTimeZones();
    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    final String timeZoneId = currentTimeZone.identifier;
    tz.setLocalLocation(tz.getLocation(timeZoneId));
    debugPrint('[Timezone] Configured successfully to: $timeZoneId');
  } catch (e) {
    debugPrint('[Timezone] Error configuring timezone: $e');
  }
}

/// 2. تهيئة خدمات Firebase و Crashlytics و Analytics
Future<void> _initFirebaseServices() async {
  try {
    if (DefaultFirebaseOptions.currentPlatform.apiKey == 'TEMP_API_KEY') {
      debugPrint(
        '[FCM] Skipping Firebase initialization (temporary FirebaseOptions)',
      );
      return;
    }

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('[FCM] Firebase initialized successfully in background');

    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    }

    await Future.wait([
      AppCrashlytics.setCollectionEnabled(true).catchError((e) {
        debugPrint('[Crashlytics] Error enabling collection: $e');
      }),
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true).catchError(
        (e) {
          debugPrint('[Analytics] Error enabling collection: $e');
        },
      ),
    ]);
  } catch (e) {
    debugPrint('[FCM] Firebase initialization failed in background: $e');
  }
}

/// 3. تهيئة قواعد البيانات المحلية (Hive & Showcase) وإعدادات الـ Environment والـ DI
Future<void> _initLocalStorageAndDependencies() async {
  try {
    await HiveDatabase.init();
    await ShowcaseManager().init();

    // Restore developer settings from Hive
    final isDev = HiveDatabase.isDeveloperMode();
    inspectorEnabled = isDev;
    final savedUrl = HiveDatabase.getDeveloperEnvironment();
    if (savedUrl != null) {
      ApiConfig.baseUrl = savedUrl;
    } else if (kIsWeb) {
      final host = Uri.base.host.toLowerCase();
      if (host.contains('azurewebsites.net')) {
        ApiConfig.baseUrl = 'https://devapi.tiba-academy.com/api';
        debugPrint(
          '🌐 [Web Environment] Detected Dev environment: ${ApiConfig.baseUrl}',
        );
      } else if (host.contains('knoz.online')) {
        ApiConfig.baseUrl = 'https://api.tiba-academy.com/api';
        debugPrint(
          '🌐 [Web Environment] Detected Production environment: ${ApiConfig.baseUrl}',
        );
      }
    }

    // Dependency Injection Setup
    DependencyInjector.setup();
  } catch (e, s) {
    debugPrint('❌ Startup Diagnostic Error (Hive/DI): $e');
    debugPrint(s.toString());
  }
}

/// 4. تهيئة الـ Providers والـ Services التي تعتمد على الـ DI
void _initAppProvidersAndServices() {
  AuthenticationProvider.injectDelegate(
    delegate: DependencyInjector.authenticationDelegateWithRxdart,
  );
  CartProvider.init(repository: DependencyInjector.cartRepo);
  Bloc.observer = BlocObserverImp();
  DeepLinkService.init();
}

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      FlutterError.onError = (FlutterErrorDetails details) {
        AppCrashlytics.recordFlutterFatalError(details);
      };

      // 🚀 تشغيل التهيئة الأساسية المستقلة بالتوازي لتسريع فتح التطبيق
      await Future.wait([
        _initTimezone(),
        _initFirebaseServices(),
        _initLocalStorageAndDependencies(),
      ]);

      // تهيئة الـ Providers والـ Services بعد اكتمال الـ DI والـ Hive
      _initAppProvidersAndServices();

      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => DependencyInjector.themeCubit),
            BlocProvider(create: (context) => DependencyInjector.languageCubit),
            // يُوفَّر مرة واحدة على مستوى التطبيق (فوق MaterialApp) ليراه الـ Shell والـ Checkout والخريطة.
            BlocProvider(create: (context) => DependencyInjector.locationCubit),
            BlocProvider(create: (_) => OrderDraftCubit()),
            ChangeNotifierProvider(create: (context) => CartProvider.instance),
            ChangeNotifierProvider(
              create: (_) => NavigationProvider.instance,
            ),
          ],
          child: LavelleHome(),
        ),
      );
    },
    (error, stack) {
      AppCrashlytics.recordError(error, stack, fatal: true);
      debugPrint('Fatal error occurred: $error');
      debugPrint(stack.toString());
    },
  );
}
