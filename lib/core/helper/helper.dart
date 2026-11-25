import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../feature/user/domain/entities/language.dart';
import '../service/navigation_service.dart';

class Helper {
  static String toggleDigits(String input) {
    final context = NavigationService.navigatorKey.currentContext;

    final bool isArabic =
        context != null && Localizations.localeOf(context).languageCode == 'ar';

    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    StringBuffer sb = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      String char = input[i];

      if (isArabic) {
        int enIndex = english.indexOf(char);
        if (enIndex != -1) {
          sb.write(arabic[enIndex]);
        } else {
          sb.write(char);
        }
      } else {
        int arIndex = arabic.indexOf(char);
        if (arIndex != -1) {
          sb.write(english[arIndex]);
        } else {
          sb.write(char);
        }
      }
    }

    return sb.toString();
  }

  static Future<void> rateApp() async {
    final Uri url;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      url = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.yourcompany.yourapp',
      );
    } else if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      url = Uri.parse(
        'https://apps.apple.com/app/idYOUR_APP_ID',
      );
    } else {
      return;
    }

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  static num resolveLanguageId({
    required String deviceLangCode,
    required List<LanguageModel> backendLanguages,
  }) {
    final match = backendLanguages.firstWhere(
      (l) => l.code == deviceLangCode,
      orElse: () => backendLanguages.first,
    );

    return match.priority;
  }

  static Future<void> openMeetingLink(String url) async {
    final Uri uri = Uri.parse(url);

    // لو الـ URL بتاع Zoom -> حوّله لـ Deep Link عشان يفتح App مباشرة
    Uri finalUri = _convertToDeepLinkIfNeeded(uri);

    if (await canLaunchUrl(finalUri)) {
      await launchUrl(
        finalUri,
        mode: LaunchMode.externalApplication, // مهم جداً يفتح تطبيق خارجي
      );
    } else {
      // Fallback: افتح في المتصفح
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  static Uri _convertToDeepLinkIfNeeded(Uri uri) {
    // Zoom link تحويل
    // https://zoom.us/j/MEETING_ID?pwd=XXX
    // -> zoomus://zoom.us/join?confno=MEETING_ID&pwd=XXX
    if (uri.host.contains('zoom.us') && uri.pathSegments.contains('j')) {
      final meetingId = uri.pathSegments.last;
      final pwd = uri.queryParameters['pwd'] ?? '';
      return Uri.parse(
        'zoomus://zoom.us/join?confno=$meetingId&pwd=$pwd',
      );
    }

    // Google Meet مش محتاج تحويل - الـ link بتاعه بيشتغل عادي
    return uri;
  }
}
