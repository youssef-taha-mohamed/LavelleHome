import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/service/force_update/force_update_service.dart';
import '../../../../core/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  static const String routeName = '/force_update';

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final service = ForceUpdateService.instance;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [MyColors.darkGreen, MyColors.darkPrimary],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Lottie Animation Container
                Container(
                  height: 250.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 40,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Lottie.network(
                    'https://assets9.lottiefiles.com/packages/lf20_m6cu9m9o.json',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.system_update,
                      size: 150.sp,
                      color: MyColors.goldAccent,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                // Title
                Text(
                  service.getUpdateTitle(languageCode),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 16.h),
                // Message
                Text(
                  service.getUpdateMessage(languageCode),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                    fontFamily: 'Cairo',
                  ),
                ),
                const Spacer(),
                // Update Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse(service.storeUrl);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.goldAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 8,
                      shadowColor: MyColors.goldAccent.withValues(alpha: 0.4),
                    ),
                    child: Text(
                      languageCode == 'ar' ? 'تحديث الآن' : 'Update Now',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // App Version info
                Text(
                  languageCode == 'ar'
                      ? 'نسخة التطبيق الحالية: ${service.currentVersion}'
                      : 'Current Version: ${service.currentVersion}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
