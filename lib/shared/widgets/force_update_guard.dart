import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as dev;

/// Guard يفحص تحديثات الـ Store الرسمية:
/// - Android: يستخدم Google Play In-App Update API (Immediate - إجباري بالكامل)
/// - iOS: يستخدم App Store API ويعرض Dialog غير قابل للإغلاق
class ForceUpdateGuard extends StatefulWidget {
  final Widget child;
  const ForceUpdateGuard({super.key, required this.child});

  @override
  State<ForceUpdateGuard> createState() => _ForceUpdateGuardState();
}

class _ForceUpdateGuardState extends State<ForceUpdateGuard>
    with WidgetsBindingObserver {
  bool _iosDialogVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdate());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForUpdate();
    }
  }

  Future<void> _checkForUpdate() async {
    if (!mounted) return;
    if (kIsWeb) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _checkAndroid();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _checkIOS();
    }
  }

  // ─────────────────────────────────────────────
  // Android: Google Play Immediate Update Flow
  // ─────────────────────────────────────────────
  Future<void> _checkAndroid() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      dev.log('🤖 Android update status: ${info.updateAvailability}');

      if (info.updateAvailability == UpdateAvailability.updateAvailable &&
          info.immediateUpdateAllowed) {
        // Immediate Update: Google Play تأخذ التحكم كاملاً - المستخدم مش قادر يرفضه
        final result = await InAppUpdate.performImmediateUpdate();
        dev.log('🔄 Immediate update result: $result');
      }
    } catch (e) {
      dev.log('⚠️ Android update check failed: $e');
    }
  }

  // ─────────────────────────────────────────────
  // iOS: App Store version check + forced dialog
  // ─────────────────────────────────────────────
  Future<void> _checkIOS() async {
    if (_iosDialogVisible) return;
    try {
      final newVersion = NewVersionPlus();
      final status = await newVersion.getVersionStatus();
      dev.log(
        '🍎 iOS version – local: ${status?.localVersion}, store: ${status?.storeVersion}',
      );

      if (status == null || !mounted) return;

      final hasUpdate = status.canUpdate;
      if (hasUpdate && !_iosDialogVisible) {
        _iosDialogVisible = true;
        await _showIOSForceUpdateDialog(
          storeUrl: status.appStoreLink,
          storeVersion: status.storeVersion,
          localVersion: status.localVersion,
        );
      }
    } catch (e) {
      dev.log('⚠️ iOS update check failed: $e');
    }
  }

  Future<void> _showIOSForceUpdateDialog({
    required String storeUrl,
    required String storeVersion,
    required String localVersion,
  }) async {
    final languageCode = Localizations.localeOf(context).languageCode;
    final isAr = languageCode == 'ar';

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => PopScope(
            canPop: false, // منع الإغلاق بزر الرجوع
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1B5E20), Color(0xFF004D40)],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // أيقونة
                    Container(
                      width: 80.r,
                      height: 80.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                      child: Icon(
                        Icons.system_update_rounded,
                        size: 44.r,
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // العنوان
                    Text(
                      isAr ? 'تحديث جديد متاح 🚀' : 'New Update Available 🚀',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // الرسالة
                    Text(
                      isAr
                          ? 'الإصدار $storeVersion متاح الآن.\nيرجى تحديث التطبيق للاستمرار في الاستخدام.'
                          : 'Version $storeVersion is now available.\nPlease update to continue using the app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.6,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // الإصدار الحالي
                    Text(
                      isAr
                          ? 'إصدارك الحالي: $localVersion'
                          : 'Your version: $localVersion',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // زر التحديث
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final url = Uri.parse(storeUrl);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        icon: Icon(Icons.apple_rounded, size: 22.r),
                        label: Text(
                          isAr ? 'تحديث من App Store' : 'Update on App Store',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    if (mounted) setState(() => _iosDialogVisible = false);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
