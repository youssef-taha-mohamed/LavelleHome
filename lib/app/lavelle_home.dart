import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:requests_inspector/requests_inspector.dart';
import '../core/network/client/dio/client.dart';
import '../core/routes/app_router.dart';
import '../core/service/navigation_service.dart';
import '../core/style/theme/theme_manager.dart';
import '../core/utils/size_utils.dart';
import '../l10n/arb/app_localizations.dart';
import '../shared/show_case/management/showcase_root.dart';
import '../shared/widgets/network_banner_wrapper.dart';

class LavelleHome extends StatelessWidget {
  const LavelleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: inspectorNotifier,
      builder: (context, isEnabled, child) {
        return RequestsInspector(
          navigatorKey: NavigationService.navigatorKey,
          enabled: isEnabled,
          showInspectorOn: ShowInspectorOn.LongPress,
          hideInspectorBanner: true,
          child: Sizer(
            builder: (context, orientation, deviceType) {
              return ScreenUtilInit(
                useInheritedMediaQuery: true,
                designSize: const Size(375, 790),
                child: ThemeManager(
                  child: Builder(
                    builder: (context) {
                      final themeScope = ThemeScope.of(context);

                      return MaterialApp(
                        builder: (context, child) {
                          return ShowcaseRoot(
                            child: NetworkBannerWrapper(child: child!),
                          );
                        },
                        debugShowCheckedModeBanner: false,
                        navigatorObservers: [AppNavObserver()],
                        localizationsDelegates: [
                          ...AppLocalizations.localizationsDelegates,
                          FlutterQuillLocalizations.delegate,
                        ],
                        supportedLocales: AppLocalizations.supportedLocales,
                        locale: themeScope.locale,
                        navigatorKey: NavigationService.navigatorKey,
                        onGenerateRoute: AppRouter.generateRoute,
                        theme: themeScope.lightTheme,
                        darkTheme: themeScope.darkTheme,
                        themeMode: themeScope.themeMode,
                        initialRoute: '/',
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class AppNavObserver extends NavigatorObserver {
  static final navStack = <RouteStackItem>[];

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null) navStack.removeLast();
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    log('didPush: ${route.settings.name}');
    navStack.add(RouteStackItem.fromRoute(route));
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    if (previousRoute != null) navStack.removeLast();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute != null) navStack.removeLast();
    if (newRoute != null) {
      navStack.add(RouteStackItem.fromRoute(newRoute));
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

class RouteStackItem {
  final String? name;
  final Object? args;

  const RouteStackItem({required this.name, required this.args});

  factory RouteStackItem.fromRoute(Route route) =>
      RouteStackItem(name: route.settings.name, args: route.settings.arguments);
}
