import 'package:flutter/material.dart';
import '../../core/utils/crashlytics/app_crashlytics.dart';

class CrashTestButton extends StatelessWidget {
  const CrashTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        // طريقة 1: تسجيل استثناء مخصص
        AppCrashlytics.recordError(
          Exception('اختبار الكراش من الزر!'),
          StackTrace.current,
          reason: 'اختبار زر الكراش',
          fatal: true,
        );

        // طريقة 2: إنشاء استثناء حقيقي (اختر واحدة من الطريقتين)
        // Future.delayed(const Duration(milliseconds: 100), () {
        //   // إنشاء استثناء عشوائي سيؤدي إلى تعطل التطبيق
        //   throw Exception('اختبار كراش مقصود!');
        // });

        // إظهار رسالة تأكيد للمستخدم (سيظهر فقط إذا استخدمت الطريقة 1)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال تقرير الكراش إلى Firebase Crashlytics'),
            backgroundColor: Colors.red,
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          'اختبار Crashlytics',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
