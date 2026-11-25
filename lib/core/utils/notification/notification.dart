import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import '../../../feature/notifications/domain/enum/target_type.dart';
import '../../../feature/notifications/presentation/provider/provider_count.dart';
import '../../../feature/notifications/presentation/view/notification_screen.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/main_text.dart';
import '../../db/kv_db/hive.dart';
import '../../service/navigation_service.dart';
import 'local_notification.dart';

abstract class NotificationUtils {
  const NotificationUtils();

  static bool isinitialized = false;
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static Map<String, dynamic>? _pendingNotificationData;

  /// Gets the current FCM token (with iOS retry for APNS delay)
  static Future<String?> fcmToken() async {
    try {
      if (kIsWeb) {
        const String webVapidKey =
            'BDqwsFrMVVAnD8HkuU9k8lnCtlnTLKj2qX7o-nr5QYZ_pgM4MZRGqCqEBZqIEszeDIm0rnc7hVkuIUltLhJqRFo';
        final token = await FirebaseMessaging.instance.getToken(
          vapidKey: webVapidKey,
        );
        if (token != null) {
          log('✅ FCM Token (Web): $token', name: 'NotificationUtils');
        }
        return token;
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        for (int i = 0; i < 4; i++) {
          final token = await FirebaseMessaging.instance.getToken();
          if (token != null && token.isNotEmpty) {
            log('✅ FCM Token (iOS): $token', name: 'NotificationUtils');
            return token;
          }
          await Future.delayed(const Duration(seconds: 2));
        }
        return null;
      }
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        log('✅ FCM Token: $token', name: 'NotificationUtils');
      }
      return token;
    } catch (e) {
      log('Error getting FCM token: $e', name: 'NotificationUtils');
      return null;
    }
  }

  /// Deletes the current FCM token
  static Future<void> deleteFcmToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      log('Error deleting FCM token: $e', name: 'NotificationUtils');
    }
  }

  /// Stream that emits FCM token updates
  static Stream<String> onTokenRefresh() {
    return FirebaseMessaging.instance.onTokenRefresh;
  }

  static Future<void> startListin() async {
    if (isinitialized) return;
    NotificationUtils.isinitialized = true;

    log('Starting notification listeners', name: 'NotificationUtils');

    // 1️⃣ اطلب Permission الأول (مهم جداً لـ iOS)
    await _requestNotificationPermissions();

    // Initialize Local Notifications
    await LocalNotificationUtils().init();

    // 2️⃣ بعد الـ permission، اعمل set للـ foreground options
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // 3️⃣ استمع للـ foreground messages
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint('═══════════════════════════════');
      debugPrint('📩 Foreground Message Received');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Data: ${message.data}');
      debugPrint('═══════════════════════════════');

      if (kIsWeb) {
        await _handleWebNotification(message);
      } else if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        await _handleNotificationMessage(message);
      }
    });

    // 4️⃣ استمع لفتح التطبيق من notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      debugPrint("🔥 Firebase Notification Click");
      log(
        'App opened from notification: ${message.data}',
        name: 'NotificationUtils',
      );
      await notificationHandler(data: message.data);
    });

    // 5️⃣ Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 6️⃣ لو التطبيق اتفتح من notification وهو مقفول
    debugPrint("⏳ Calling getInitialMessage...");
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    debugPrint("⏳ getInitialMessage returned: ${initialMessage?.data}");
    await HiveDatabase.setInitialNotification(
      initialMessage == null ? "NULL" : jsonEncode(initialMessage.data),
    );
    debugPrint("==============================");
    debugPrint("Initial Message =====> ${initialMessage?.data}");
    debugPrint("==============================");
    if (initialMessage != null) {
      log(
        'App opened from terminated state, deferring handling: ${initialMessage.data}',
        name: 'NotificationUtils',
      );
      _pendingNotificationData = initialMessage.data;
    }
  }

  /// Sets the pending notification data for deferred processing
  static void setPendingNotificationData(Map<String, dynamic> data) {
    log('Setting pending notification data: $data', name: 'NotificationUtils');
    _pendingNotificationData = data;
  }

  /// Processes any pending notification that was received during app launch
  static Future<void> processPendingNotification() async {
    if (_pendingNotificationData != null) {
      log('Processing pending notification data', name: 'NotificationUtils');
      final data = Map<String, dynamic>.from(_pendingNotificationData!);
      _pendingNotificationData = null;
      await notificationHandler(data: data);
    }
  }

  static Future<void> _requestNotificationPermissions() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      log(
        'iOS permission status: ${settings.authorizationStatus}',
        name: 'NotificationUtils',
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // تشغيل جلب APNS token في الخلفية حتى لا يعطل فتح التطبيق والشاشة الرئيسية لمدة 8 ثوانٍ
        unawaited(_fetchIosApnsTokenInBackground());
      } else {
        log(
          '❌ iOS notification permission denied: ${settings.authorizationStatus}',
          name: 'NotificationUtils',
        );
      }
    } else if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      log(
        '📱 Requesting Android notification permission...',
        name: 'NotificationUtils',
      );

      final settings = await FirebaseMessaging.instance.requestPermission();
      log(
        'Android permission status: ${settings.authorizationStatus}',
        name: 'NotificationUtils',
      );

      final fcm = await FirebaseMessaging.instance.getToken();
      log('✅ Android FCM Token: $fcm', name: 'NotificationUtils');
    }
  }

  /// جلب APNS Token و FCM Token للـ iOS في الخلفية دون تعطيل واجهة وبدء التطبيق
  static Future<void> _fetchIosApnsTokenInBackground() async {
    try {
      String? apnsToken;
      for (int i = 0; i < 4; i++) {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) break;
        log(
          '⏳ Waiting for APNS token... attempt ${i + 1}/4',
          name: 'NotificationUtils',
        );
        await Future.delayed(const Duration(seconds: 2));
      }

      log('APNS Token: $apnsToken', name: 'NotificationUtils');

      if (apnsToken != null) {
        final fcm = await FirebaseMessaging.instance.getToken();
        log('✅ iOS FCM Token: $fcm', name: 'NotificationUtils');
      } else {
        log(
          '⚠️ APNS token not available after retries',
          name: 'NotificationUtils',
        );
      }
    } catch (e) {
      log('Error resolving iOS APNS token: $e', name: 'NotificationUtils');
    }
  }

  static Future<void> _handleNotificationMessage(RemoteMessage message) async {
    // Update badge count
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      final count = int.tryParse(message.notification?.apple?.badge ?? '');
      await FlutterAppBadge.count(count ?? 0);
      NotificationsProvider.updateCount(count ?? 0);
    } else if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final count = message.notification?.android?.count;
      NotificationsProvider.updateCount(count ?? 0);
    }

    // Show local cubit
    final obj = LocalNotificationUtils();
    await obj.showNotification(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  static Future<void> notificationHandler({
    required Map<String, dynamic> data,
  }) async {
    debugPrint("🔥 notificationHandler");
    debugPrint(data.toString());
    log('Handling notification with data: $data', name: 'NotificationUtils');
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) {
      log('Context is null, cannot navigate', name: 'NotificationUtils');
      return;
    }
    final targetTypeId = int.tryParse('${data['Source']}');
    final id = '${data['Target1']}';
    final target2 = '${data['Target2']}'; // Ensure it's a string
    final notificationId = int.tryParse('${data['NotificationId']}');

    log(
      'Source: $targetTypeId | Target1: $id | NotificationId: $notificationId',
    );
    if (targetTypeId == null) {
      Navigator.of(context).pushNamed(NotificationsScreen.routeName);
      return;
    }

    try {
      TargetType? targetType;
      try {
        targetType = TargetType.fromId(targetTypeId);
      } catch (_) {
        targetType = null;
      }

      await _handleNavigation(context, targetType, id, target2);
    } catch (e) {
      log(
        'Navigation error, falling back to notifications screen: $e',
        name: 'NotificationUtils',
      );
      if (context.mounted) {
        await Navigator.of(
          context,
        ).pushNamed(NotificationsScreen.routeName, arguments: target2);
      }
    }
  }

  static Future<void> _handleNavigation(
    BuildContext context,
    TargetType? targetType,
    String id,
    String target2,
  ) async {
    if (targetType == null) {
      await Navigator.of(
        context,
      ).pushNamed(NotificationsScreen.routeName, arguments: target2);
      return;
    }

    switch (targetType) {
      case TargetType.system:
      case TargetType.security:
      case TargetType.family:
      case TargetType.subscription:
      case TargetType.course:
      case TargetType.contactUs:
      case TargetType.payment:
      case TargetType.feedBack:
      case TargetType.assignment:
        await Navigator.of(
          context,
        ).pushNamed(NotificationsScreen.routeName, arguments: target2);
        return;
    }
  }

  static Future<void> _handleWebNotification(RemoteMessage message) async {
    _showPremiumToast(
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? '',
      onView: () => notificationHandler(data: message.data),
    );

    try {
      await _audioPlayer.stop();
      // Using AssetSource for the local file added by the user
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      log('Error playing sound on web: $e', name: 'NotificationUtils');
    }
  }

  static void _showPremiumToast({
    required String title,
    required String body,
    required VoidCallback onView,
  }) {
    final overlay = NavigationService.navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        return _PremiumNotificationWidget(
          title: title,
          body: body,
          isRtl: isRtl,
          onView: () {
            onView();
            entry.remove();
          },
          onDismiss: () => entry.remove(),
        );
      },
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 5), () {
      if (entry.mounted) entry.remove();
    });
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ← اطبع كل محتوى الرسالة
  debugPrint('═══════════════════════════════');
  debugPrint('📩 Background Message Received');
  debugPrint('Message ID: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');
  debugPrint('Data keys: ${message.data.keys.toList()}');
  debugPrint('═══════════════════════════════');

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
    final i = int.tryParse(message.notification?.apple?.badge ?? '');
    FlutterAppBadge.count(i ?? 0);
    NotificationsProvider.updateCount(i ?? 0);
  } else if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    final i = message.notification?.android?.count;
    NotificationsProvider.updateCount(i ?? 0);
    FlutterAppBadge.count(i ?? 0);
  }
}

class _PremiumNotificationWidget extends StatefulWidget {
  final String title;
  final String body;
  final bool isRtl;
  final VoidCallback onView;
  final VoidCallback onDismiss;

  const _PremiumNotificationWidget({
    required this.title,
    required this.body,
    required this.isRtl,
    required this.onView,
    required this.onDismiss,
  });

  @override
  State<_PremiumNotificationWidget> createState() =>
      _PremiumNotificationWidgetState();
}

class _PremiumNotificationWidgetState extends State<_PremiumNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Slide from the side based on language
    final beginOffset = widget.isRtl
        ? const Offset(-1.2, 0.0)
        : const Offset(1.2, 0.0);

    _offsetAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: widget.isRtl ? null : 30,
      left: widget.isRtl ? 30 : null,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 40,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: GestureDetector(
                    onTap: widget.onView,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.9),
                            Colors.white.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Accent Strip
                            Container(
                              width: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2C7A7B),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF2C7A7B,
                                            ).withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.mark_email_unread_outlined,
                                            color: Color(0xFF2C7A7B),
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: MainText(
                                            widget.title,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: const Color(0xFF1A3838),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: widget.onDismiss,
                                          icon: const Icon(
                                            Icons.close_rounded,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    MainText(
                                      widget.body,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      color: const Color(
                                        0xFF1A3838,
                                      ).withValues(alpha: 0.8),
                                    ),
                                    const SizedBox(height: 18),
                                    Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: ElevatedButton(
                                        onPressed: widget.onView,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF2C7A7B,
                                          ),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: MainText(
                                          context.l10n.view_details,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// I/flutter ( 6826): 📩 Foreground Message Received
// I/flutter ( 6826): Title: ✅ Assessment Approved
// I/flutter ( 6826): Body: Great news! Your assessment for Art_and_Crafts
// I/flutter ( 6826): With Nada Ali.
// I/flutter ( 6826): Good luck!
// I/flutter ( 6826): Data: {NotificationId: 605, Target1: 34, Source: 4, Target2:}
