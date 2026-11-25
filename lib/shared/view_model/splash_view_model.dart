import 'dart:developer' as dev;
import '../../../../core/authentication/cache/disk/hive.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../core/db/kv_db/hive.dart';
import '../../core/di/dependency_injector.dart';
import '../../core/utils/notification/notification.dart';
import '../../feature/notifications/presentation/provider/provider_count.dart';
import '../../feature/setting/domain/use_case/setting.dart';
import '../show_case/management/showcase_manager.dart';
import 'state.dart';

final class SplashScreenViewModel {
  const SplashScreenViewModel();

  Future<SplashState> init() async {
    bool isUpdateRequired = false;
    bool isAppClosed = false;

    // 🚀 تشغيل عمليات التهيئة والشبكة المستقلة بالتوازي لتقليل وقت فتح التطبيق
    await Future.wait([
      _initNotificationServices(),
      _checkForceUpdate().then((value) => isUpdateRequired = value),
      _checkAppStatusIsClosed().then((value) => isAppClosed = value),
      _initAuthSession(),
    ]);

    // 1️⃣ أولوية التحديث الإجباري
    if (isUpdateRequired) {
      return SplashState.forceUpdate;
    }

    // 2️⃣ أولوية إغلاق التطبيق من الإدارة
    if (isAppClosed) {
      return SplashState.closedApp;
    }

    // 3️⃣ التحقق من أول مرة فتح التطبيق
    final firstTimeOpenedApp = HiveDatabase.firstTimeOpenedApp();
    if (firstTimeOpenedApp) {
      await HiveDatabase.cacheTheAppIsOpened();
      return SplashState.notOpenedAppBefore;
    }

    // 4️⃣ التحقق من تسجيل الدخول
    final auth = AuthenticationProvider.instance;
    final user = auth.currentUser;
    if (user?.details == null) {
      return SplashState.notLoggedIn;
    }

    // مزامنة تفضيلات المستخدم (اللغة والثيم)
    if (user != null) {
      await AuthenticationProvider.instance.syncPreferenceFromUser(user);
    }

    // 5️⃣ التوجيه بحسب حالة تفعيل الحساب
    if (user?.details.emailVerified == true) {
      return SplashState.loggedIn;
    }

    return SplashState.phoneNotVerified;
  }

  /// تهيئة خدمات ومستمعات الإشعارات
  Future<void> _initNotificationServices() async {
    try {
      NotificationsProvider.init(
        repository: DependencyInjector.notificationRepo,
      );
      await NotificationUtils.startListin();
    } catch (e) {
      dev.log('⚠️ Error initializing notification services: $e');
    }
  }

  /// التحقق من وجود تحديث إجباري
  Future<bool> _checkForceUpdate() async {
    try {
      final forceUpdateService = DependencyInjector.forceUpdateService;
      await forceUpdateService.init();
      return await forceUpdateService.isUpdateRequired();
    } catch (e) {
      dev.log('⚠️ Error checking force update: $e');
      return false;
    }
  }

  /// التحقق من حالة فتح التطبيق أو إغلاقه بواسطة الأدمن
  Future<bool> _checkAppStatusIsClosed() async {
    try {
      final appStatusUseCase = GetAppStatusUseCase(
        repository: DependencyInjector.settingRepository,
      );
      final response = await appStatusUseCase.call(null);
      if (response.record.appStatus == 1) {
        dev.log('🔒 App is closed by admin (appStatus == 1)');
        return true;
      }
      dev.log('✅ App is open (appStatus == 0)');
      return false;
    } catch (e) {
      dev.log('⚠️ Error checking app status: $e');
      return false;
    }
  }

  /// تهيئة قواعد البيانات المحلية وجلسة المستخدم
  Future<void> _initAuthSession() async {
    await _initAppDatabases();
    try {
      await AuthenticationProvider.instance.init();
    } catch (e) {
      dev.log('⚠️ Error initializing auth provider: $e');
    }
  }

  /// تهيئة صناديق Hive الخاصة بالـ Auth والـ Showcase
  Future<void> _initAppDatabases() async {
    try {
      await HiveAuthenticationCache().init();
    } catch (e) {
      dev.log('❌ Error initializing HiveAuthenticationCache: $e');
    }

    try {
      await ShowcaseManager().init();
      dev.log('✅ ShowcaseManager initialized successfully');
    } catch (e) {
      dev.log('❌ Error initializing ShowcaseManager: $e');
    }
  }
}
