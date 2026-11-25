import 'package:flutter/services.dart';

class ArabicToEnglishDigitsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    const Map<String, String> arabicToEnglish = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };

    arabicToEnglish.forEach((arabic, english) {
      text = text.replaceAll(arabic, english);
    });

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

String replaceArabicNumber(String input) {
  const Map<String, String> arabicToEnglish = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  String result = input;
  arabicToEnglish.forEach((arabic, english) {
    result = result.replaceAll(arabic, english);
  });
  return result;
}
