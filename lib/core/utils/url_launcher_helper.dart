import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'toast_alert.dart';

class UrlLauncherHelper {
  /// بدء مكالمة هاتفية
  static Future<void> launchPhone(String phone, {BuildContext? context}) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context != null && context.mounted) {
          CustomToast.show(
            context: context,
            message: 'هذه الميزة غير مدعومة على هذا الجهاز (كالمحاكي).',
            type: ToastType.error,
          );
        }
        debugPrint('Could not launch phone: $uri');
      }
    } catch (e) {
      if (context != null && context.mounted) {
        CustomToast.show(
          context: context,
          message: 'حدث خطأ أثناء محاولة الاتصال.',
          type: ToastType.error,
        );
      }
      debugPrint('Error launching phone: $e');
    }
  }

  /// إرسال بريد إلكتروني
  static Future<void> launchEmail(String email, {String subject = '', String body = ''}) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        debugPrint('Could not launch email: $uri');
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

  /// فتح واتساب وإرسال رسالة
  static Future<void> launchWhatsApp(String phone, {String message = ''}) async {
    // تنظيف رقم الهاتف من أي رموز عدا الأرقام
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final Uri uri = Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch WhatsApp: $uri');
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }
  }

  /// فتح رابط في المتصفح الخارجي
  static Future<void> launchWebsite(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch website: $uri');
      }
    } catch (e) {
      debugPrint('Error launching website: $e');
    }
  }
}
