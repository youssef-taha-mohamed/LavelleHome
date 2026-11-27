import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../feature/auth/presentation/forget_password/cubit/forget_password_cubit.dart';
import '../../feature/auth/presentation/impersonate/view/impersonation_screen.dart';
import '../../feature/auth/presentation/login/cubit/login_cubit.dart';
import '../../feature/auth/presentation/otp_change_password/cubit/otp_change_password_cubit.dart';
import '../../feature/auth/presentation/otp_register/cubit/otp_register_cubit.dart';
import '../../feature/auth/presentation/otp_register/view/otp_register.dart';
import '../../feature/auth/presentation/register/cubit/register_cubit.dart';
import '../../feature/auth/presentation/forget_password/view/forget_password_email.dart';
import '../../feature/auth/presentation/login/view/login.dart';
import '../../feature/auth/presentation/otp_change_password/view/otp_change_password.dart';
import '../../feature/auth/presentation/register/view/register.dart';
import '../../feature/auth/presentation/reset_password/cubit/reset_password_cubit.dart';
import '../../feature/auth/presentation/reset_password/view/reset_password.dart';
import '../../feature/auth/presentation/social_login/cubit/social_login_cubit.dart';
import '../../feature/auth/presentation/social_register/cubit/social_register_cubit.dart';
import '../../feature/auth/presentation/social_register/view/social_complete_profile_screen.dart';
import '../../feature/botttom_nav_bar/nav_bar.dart';
import '../../feature/laundry/presentation/view/laundry_screen.dart';
import '../../feature/notifications/domain/entities/parameter/notification_details_arg.dart';
import '../../feature/notifications/presentation/mobile/notification_details.dart';
import '../../feature/setting/presentation/cubit/setting_cubit.dart';
import '../../feature/cart/presentation/view/payment/payment_method_screen.dart';
import '../../feature/cart/presentation/view/summary/cart_summary_screen.dart';
import '../../feature/country/presentation/view/countries_screen.dart';
import '../../feature/contact_us/presentation/view/contact_us_screen.dart';
import '../../feature/setting/presentation/view/faqs_screen.dart';
import '../../feature/setting/presentation/view/privacy_police.dart';
import '../../feature/cart/domain/entities/parameter/subscription_parameter.dart';
import '../../feature/cart/presentation/view/payment_view.dart';
import '../../shared/screens/mobile/closed_app/closed_app_screen.dart';
import '../../feature/auth/presentation/change_password/view/change_password.dart';
import '../../feature/shop/presentation/view/shop_view.dart';
import '../../feature/profile/presentation/view/profile_view.dart';
import '../../feature/setting/presentation/view/setting_view.dart';
import '../../shared/screens/mobile/language/language_screen.dart';
import '../../shared/screens/mobile/splash/splash_view.dart';
import '../authentication/provider.dart';
import '../di/dependency_injector.dart';
import '../../feature/force_update/presentation/force_update_screen.dart';
import '../service/deep_link_service.dart';

abstract final class AppRouter {
  const AppRouter();

  static bool _isInitialLoad = true;
  static bool _hasHandledImpersonation = false;
  static String currentRoute = '';

  static Route? generateRoute(RouteSettings routeSettings) {
    final currentUser = AuthenticationProvider.instance.currentUser;
    final rawRouteName = routeSettings.name ?? '';
    final parsedUri = Uri.tryParse(rawRouteName);
    final routePath = (parsedUri != null && parsedUri.path.isNotEmpty)
        ? parsedUri.path
        : rawRouteName;
    final argument = routeSettings.arguments;
    // 🛡️ Web Impersonation Check (Supports /impersonate?token=... and /?token=...)
    final impersonationToken =
        parsedUri?.queryParameters['token'] ??
        (kIsWeb ? Uri.base.queryParameters['token'] : null) ??
        (argument is String ? argument : null);

    final isImpersonateRoute =
        routePath == ImpersonationScreen.routeName ||
        routePath == '/impersonate' ||
        routePath == 'impersonate';

    final isInitialRootWithToken =
        !_hasHandledImpersonation &&
        kIsWeb &&
        _isInitialLoad &&
        (routePath == '/' || routePath.isEmpty) &&
        impersonationToken != null &&
        impersonationToken.isNotEmpty;

    if (!_hasHandledImpersonation &&
        (isImpersonateRoute || isInitialRootWithToken)) {
      _hasHandledImpersonation = true;
      _isInitialLoad = false;
      debugPrint(
        '🛡️ [AppRouter] Route to ImpersonationScreen with token: "$impersonationToken"',
      );
      return MaterialPageRoute(
        builder: (context) => ImpersonationScreen(token: impersonationToken),
        settings: const RouteSettings(name: ImpersonationScreen.routeName),
      );
    }

    // 🛡️ Web Initial Load Guard: Redirect to Splash if app is not initialized
    if (kIsWeb &&
        _isInitialLoad &&
        routePath != SplashScreen.routeName &&
        routePath != '/') {
      // Check if user opened a course_details deep link on Web
      if (parsedUri != null &&
          (routePath == HomeScreen.routeName ||
              parsedUri.path.contains('home_screen'))) {
        final deepParam = DeepLinkService.parseHomeScreenUri(parsedUri);
        if (deepParam != null) {
          DeepLinkService.setPendingParameter(deepParam);
        }
      }
      _isInitialLoad = false;
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
        settings: const RouteSettings(name: SplashScreen.routeName),
      );
    }
    _isInitialLoad = false;
    currentRoute = routePath;

    if (_authenticatedViews.contains(routePath) && currentUser == null) {
      return generateRoute(const RouteSettings(name: LoginView.routeName));
    }

    MaterialPageRoute buildRoute({
      required Widget Function(BuildContext) builder,
    }) {
      return MaterialPageRoute(builder: builder, settings: routeSettings);
    }

    // 🛡️ Safe Argument Casting Helper
    T? getArg<T>() {
      if (argument is T) return argument;
      return null;
    }

    // 🛡️ Guard for routes that MUST have arguments
    Route? guardArgs<T>(Widget Function(T) builder) {
      final T? arg = getArg<T>();
      if (arg == null && kIsWeb) {
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
          settings: const RouteSettings(name: SplashScreen.routeName),
        );
      }
      return buildRoute(builder: (context) => builder(arg as T));
    }

    switch (routePath) {
      case ImpersonationScreen.routeName:
        return buildRoute(
          builder: (context) => ImpersonationScreen(token: impersonationToken),
        );
      case '/':
      case SplashScreen.routeName:
        return buildRoute(builder: (context) => const SplashScreen());
      case LoginView.routeName:
        return buildRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => LoginCubit()),
              BlocProvider(create: (context) => SocialLoginCubit()),
            ],
            child: LoginView(),
          ),
        );
      case SocialCompleteProfileScreen.routeName:
        return guardArgs<SocialCompleteProfileArgs>(
          (args) => BlocProvider(
            create: (context) => SocialRegisterCubit(
              token: args.token,
              socialMedia: args.socialMedia,
              emailFromProvider: args.emailFromProvider,
              fullNameFromProvider: args.fullNameFromProvider,
              isStudent: args.isStudent,
              countryRepository: DependencyInjector.countryRepo,
            ),
            child: SocialCompleteProfileScreen(
              token: args.token,
              socialMedia: args.socialMedia,
              emailFromProvider: args.emailFromProvider,
              fullNameFromProvider: args.fullNameFromProvider,
              isStudent: args.isStudent,
            ),
          ),
        );
      case CartSummaryScreen.routeName:
        return guardArgs<num>((cartId) => CartSummaryScreen(cartId: cartId));
      case BottomNavBar.routeName:
        return buildRoute(builder: (context) => const BottomNavBar());
      case PaymentMethodScreen.routeName:
        return guardArgs<PaymentMethodScreenArgs>(
          (args) => PaymentMethodScreen(paymentArgs: args),
        );
      // case CancelSession.routeName:
      //   return guardArgs<CancelSessionArgument>(
      //     (arg) => BlocProvider(
      //       create: (context) =>
      //           CancelCubit(repo: DependencyInjector.myCoursesRepo),
      //       child: CancelSession(parameter: arg),
      //     ),
      //   );
      // case ConfirmCancellationScreen.routeName:
      //   final message = getArg<String?>();
      //   return buildRoute(
      //     builder: (context) =>
      //         ConfirmCancellationScreen(messageCancellation: message),
      //   );
      case NotificationDetailsScreen.routeName:
        return guardArgs<NotificationDetailsScreenArguments>(
          (arg) => NotificationDetailsScreen(parameter: arg),
        );
      // region parents routed
      // case HomeParentsView.routeName:
      //   return buildRoute(builder: (context) => const HomeParentsView());
      // case NotificationsScreen.routeName:
      //   return buildRoute(
      //     builder: (context) =>
      //         NotificationsScreen(childId: argument as String?),
      //   );
      // case ParentOrderDetailsScreen.routeName:
      //   return guardArgs<num>(
      //     (orderId) => ParentOrderDetailsScreen(orderId: orderId),
      //   );
      // case ParentOrderScreen.routeName:
      //   return buildRoute(builder: (context) => const ParentOrderScreen());
      // case StudentNavBar.routeName:
      //   return buildRoute(builder: (context) => const StudentNavBar());
      // case ParentNavBar.routeName:
      //   return buildRoute(builder: (context) => const ParentNavBar());
      // case InvitationStudentScreen.routeName:
      //   return buildRoute(
      //     builder: (context) => const InvitationStudentScreen(),
      //   );
      // case AssessmentDetailedReportScreen.routeName:
      //   return guardArgs<MyAssessment>(
      //     (assessment) =>
      //         AssessmentDetailedReportScreen(assessment: assessment),
      //   );
      // case SessionFeedback.routeName:
      //   return guardArgs<SessionFeedbackModel>(
      //     (feedbackModel) => SessionFeedback(argument: feedbackModel),
      //   );
      // case AddChildScreen.routeName:
      //   return buildRoute(builder: (context) => const AddChildScreen());
      // case CoursesDetailsScreen.routeName:
      //   MyCoursesDetailsScreenParameter? param =
      //       getArg<MyCoursesDetailsScreenParameter>();
      //   if (param == null && parsedUri != null) {
      //     param = DeepLinkService.parseCourseDetailsUri(parsedUri);
      //   }
      //   if (param != null) {
      //     return buildRoute(
      //       builder: (context) => CoursesDetailsScreen(parameter: param!),
      //     );
      //   }
      //   return guardArgs<MyCoursesDetailsScreenParameter>(
      //     (p) => CoursesDetailsScreen(parameter: p),
      //   );
      case PaymentWebViewScreen.routeName:
        return guardArgs<SubscriptionParameter>(
          (arg) => PaymentWebViewScreen(paymentData: arg),
        );
      // case EditProfileScreen.routeName:
      //   return buildRoute(builder: (context) => const EditProfileScreen());

      case LanguageScreen.routeName:
        return buildRoute(builder: (context) => const LanguageScreen());
      case ClosedAppScreen.routeName:
        return buildRoute(builder: (context) => const ClosedAppScreen());

      case ContactUsScreen.routeName:
        return buildRoute(builder: (context) => const ContactUsScreen());
      case PrivacyPolicyScreen.routeName:
        return buildRoute(builder: (context) => const PrivacyPolicyScreen());
      case FAQsScreen.routeName:
        return buildRoute(builder: (context) => const FAQsScreen());
      case ChangePasswordScreen.routeName:
        return buildRoute(builder: (context) => const ChangePasswordScreen());
      case RegisterView.routeName:
        return buildRoute(
          builder: (context) => BlocProvider(
            create: (context) => RegisterCubit(
              countryRepository: DependencyInjector.countryRepo,
            ),
            child: const RegisterView(),
          ),
        );
      case OTPRegisterView.routeName:
        return guardArgs<String>(
          (email) => BlocProvider(
            create: (context) =>
                OtpRegisterCubit(repository: DependencyInjector.userRepository),
            child: OTPRegisterView(email: email),
          ),
        );
      case ForgetPasswordEmailView.routeName:
        return buildRoute(
          builder: (context) => BlocProvider(
            create: (context) => ForgetPasswordCubit(
              repository: DependencyInjector.authenticationRepository,
            ),
            child: ForgetPasswordEmailView(),
          ),
        );
      case ResetPasswordView.routeName:
        return guardArgs<ResetPasswordParameter>(
          (parameter) => BlocProvider(
            create: (context) => ResetPasswordCubit(
              repository: DependencyInjector.authenticationRepository,
            ),
            child: ResetPasswordView(parameter: parameter),
          ),
        );
      // case PlansView.routeName:
      //   return guardArgs<PlansScreenArguments>(
      //     (arg) => LayoutBuilder(
      //       builder: (context, constraints) {
      //         if (AppResponsive.isDesktop(context) ||
      //             (kIsWeb && constraints.maxWidth > 900)) {
      //           return PlansDesktopView(arguments: arg);
      //         }
      //         if (constraints.maxWidth > 600) {
      //           return PlansTabletView(arguments: arg);
      //         }
      //         return PlansView(arguments: arg);
      //       },
      //     ),
      //   );
      // case LevelView.routeName:
      //   return guardArgs<PlansScreenArguments>(
      //     (arg) => LayoutBuilder(
      //       builder: (context, constraints) {
      //         if (AppResponsive.isDesktop(context) ||
      //             (kIsWeb && constraints.maxWidth > 900)) {
      //           return LevelDesktopView(arguments: arg);
      //         }
      //         if (constraints.maxWidth > 600) {
      //           return LevelTabletView(arguments: arg);
      //         }
      //         return LevelView(arguments: arg);
      //       },
      //     ),
      //   );
      case OtpChangePasswordView.routeName:
        return guardArgs<String>(
          (arg) => BlocProvider(
            create: (context) => OtpChangePasswordCubit(
              repository: DependencyInjector.authenticationRepository,
              userRepository: DependencyInjector.userRepository,
            ),
            child: OtpChangePasswordView(email: arg),
          ),
        );
      // case SubjectsScreen.routeName:
      //   return guardArgs<SubjectsScreenArguments>(
      //     (arg) => SubjectsScreen(arguments: arg),
      //   );
      // case AccountTypeSelectionScreen.routeName:
      //   return buildRoute(
      //     builder: (context) => const AccountTypeSelectionScreen(),
      //   );
      case CountriesGuestView.routeName:
        return buildRoute(builder: (context) => const CountriesGuestView());
      case SettingView.routeName:
        return buildRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                SettingCubit(repository: DependencyInjector.userRepository),
            child: SettingView(),
          ),
        );

      case ProfileView.routeName:
        return buildRoute(builder: (context) => ProfileView());
      // case ChildSetting.routeName:
      //   return guardArgs<ChildModel>((arg) => ChildSetting(child: arg));
      // case LanguageChildScreen.routeName:
      //   return guardArgs<ChildModel>((arg) => LanguageChildScreen(child: arg));
      // case ReportsScreen.routeName:
      //   return guardArgs<String>((arg) => ReportsScreen(childId: arg));

      // case HoldCourseView.routeName:
      //   return guardArgs<HoildCourseParameter>(
      //     (arg) => BlocProvider(
      //       create: (context) => HoldCourseCubit(
      //         repo: DependencyInjector.myCoursesRepo,
      //         userRepo: DependencyInjector.userRepository,
      //       ),
      //       child: LayoutBuilder(
      //         builder: (context, constraints) {
      //           if (constraints.maxWidth > 600) {
      //             return HoldCourseTablet(parameter: arg);
      //           }
      //           return HoldCourseView(parameter: arg);
      //         },
      //       ),
      //     ),
      //   );
      // case ReportDetailsScreen.routeName:
      //   return guardArgs<String>((arg) => ReportDetailsScreen(reportId: arg));
      // case AssessmentScreen.routeName:
      //   return guardArgs<AssessmentScreenArguments>(
      //     (arg) => AssessmentScreen(arguments: arg),
      //   );
      // case ChildDetailScreen.routeName:
      //   return guardArgs<ChildDetailsParameter>(
      //     (arg) => ChildDetailScreen(parameter: arg),
      //   );
      // case SessionScheduleScreen.routeName:
      //   return guardArgs<SessionScheduleScreenParameter>(
      //     (arg) => SessionScheduleScreen(parameter: arg),
      //   );
      // case ProfileEdit.routeName:
      //   return buildRoute(builder: (context) => const ProfileEdit());
      // case MyCoursesView.routeName:
      //   return guardArgs<bool>(
      //     (canPop) => MyCoursesView(
      //       canPopInitial: canPop,
      //       // selectedPackageId: argument as int?,
      //     ),
      //   );
      case ShopView.routeName:
        return buildRoute(builder: (context) => const ShopView());
      // case UserOrdersScreen.routeName:
      //   return guardArgs<OrderScreenParameter>(
      //     (arg) => UserOrdersScreen(parameter: arg),
      //   );
      // case EditChildProfile.routeName:
      //   return guardArgs<EditChildProfileArgs>(
      //     (arg) => EditChildProfile(args: arg),
      //   );
      // case OrderDetailsScreen.routeName:
      //   return guardArgs<OrderDetailsScreenParameter>(
      //     (arg) => OrderDetailsScreen(parameter: arg),
      //   );
      // case LiveClassroomScreen.routeName:
      //   return guardArgs<LiveClassroomArguments>(
      //     (arg) => LiveClassroomScreen(arguments: arg),
      //   );
      case ForceUpdateScreen.routeName:
        return buildRoute(builder: (context) => const ForceUpdateScreen());
      default:
        throw UnimplementedError();
    }
  }

  static List<String> get _authenticatedViews {
    return <String>[
      // VerifyAccountView.routeName,
      // ChatDreamScreen.routeName,
      // MyTransactionsView.routeName,
      // MyDreamsTabView.routeName,
      // NotificationView.routeName,
      // PaymentInternalMethodsView.routeName,
      // ProfileView.routeName,
      // PaymentMethodsView.routeName,
      // // ContactUsView.routeName,
      // FavouritesView.routeName,
      // CreateDreamView.routeName,
      // MyPackagesView.routeName,
    ];
  }
}
