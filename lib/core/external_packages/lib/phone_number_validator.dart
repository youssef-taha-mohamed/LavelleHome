import 'countries.dart';
import 'phone_number.dart';

/// Intelligent phone number validator adhering to international telecommunications standards,
/// country-specific mobile number plans (lengths, operator prefixes), and anti-fake pattern filters.
class SmartPhoneValidator {
  /// Validates [phone] according to the country's national mobile prefix and length standards.
  /// Returns `null` if valid, or a localized descriptive error message if invalid.
  static String? validate(
    PhoneNumber? phone, {
    String languageCode = 'ar',
  }) {
    if (phone == null || phone.number.trim().isEmpty) {
      return _msg(
        ar: 'يرجى إدخال رقم الهاتف',
        en: 'Please enter phone number',
        lang: languageCode,
      );
    }

    final rawNumber = phone.number.trim().replaceAll(RegExp(r'\D'), '');
    final iso = phone.countryISOCode.toUpperCase();

    if (rawNumber.isEmpty) {
      return _msg(
        ar: 'رقم الهاتف غير صالح',
        en: 'Invalid phone number',
        lang: languageCode,
      );
    }

    // 1. Detect fake identical digits (e.g. 111111111, 000000000, 999999999)
    if (rawNumber.length >= 6 && RegExp(r'^(\d)\1+$').hasMatch(rawNumber)) {
      return _msg(
        ar: 'رقم الهاتف يبدو غير صحيح أو وهمياً',
        en: 'Phone number appears to be invalid or fake',
        lang: languageCode,
      );
    }

    // 2. Detect sequential digits (e.g. 123456789, 987654321)
    if (rawNumber == '123456789' ||
        rawNumber == '1234567890' ||
        rawNumber == '987654321' ||
        rawNumber == '9876543210') {
      return _msg(
        ar: 'رقم الهاتف غير صالح',
        en: 'Invalid phone number',
        lang: languageCode,
      );
    }

    // 3. Country-specific telecom authority validations
    switch (iso) {
      case 'EG': // مصر (Egypt)
        // Mobile in Egypt (excluding international +20 and national 0):
        // Exactly 10 digits starting with 10, 11, 12, or 15 (Vodafone, Etisalat, Orange, WE)
        if (rawNumber.length < 10) {
          return _msg(
            ar: 'رقم الهاتف غير مكتمل (يتكون من 10 أرقام)',
            en: 'Phone number is incomplete (requires 10 digits)',
            lang: languageCode,
          );
        }
        if (rawNumber.length > 10) {
          return _msg(
            ar: 'رقم الهاتف المصري لا يزيد عن 10 أرقام',
            en: 'Egyptian phone number cannot exceed 10 digits',
            lang: languageCode,
          );
        }
        if (!RegExp(r'^1[0125]\d{8}$').hasMatch(rawNumber)) {
          return _msg(
            ar: 'رقم الهاتف في مصر يجب أن يبدأ بـ 10 أو 11 أو 12 أو 15',
            en: 'Egyptian numbers must start with 10, 11, 12, or 15',
            lang: languageCode,
          );
        }
        break;

      case 'SA': // المملكة العربية السعودية (Saudi Arabia)
        // Mobile in SA: exactly 9 digits starting with 5 (e.g. 5xxxxxxxx)
        if (rawNumber.length < 9) {
          return _msg(
            ar: 'رقم الجوال غير مكتمل (يتكون من 9 أرقام)',
            en: 'Mobile number is incomplete (requires 9 digits)',
            lang: languageCode,
          );
        }
        if (rawNumber.length > 9) {
          return _msg(
            ar: 'رقم الجوال السعودي لا يزيد عن 9 أرقام',
            en: 'Saudi mobile number cannot exceed 9 digits',
            lang: languageCode,
          );
        }
        if (!RegExp(r'^5\d{8}$').hasMatch(rawNumber)) {
          return _msg(
            ar: 'رقم الجوال السعودي يجب أن يبدأ بالرقم 5',
            en: 'Saudi mobile number must start with 5',
            lang: languageCode,
          );
        }
        break;

      case 'AE': // الإمارات العربية المتحدة (UAE)
        // Mobile in UAE: exactly 9 digits starting with 50, 52, 54, 55, 56, 58
        if (rawNumber.length != 9) {
          return _msg(
            ar: 'رقم الجوال الإماراتي يجب أن يتكون من 9 أرقام',
            en: 'UAE mobile number must be exactly 9 digits',
            lang: languageCode,
          );
        }
        if (!RegExp(r'^5[024568]\d{7}$').hasMatch(rawNumber)) {
          return _msg(
            ar: 'رقم الجوال الإماراتي يجب أن يبدأ بـ 50، 52، 54، 55، 56، أو 58',
            en: 'UAE mobile number must start with 50, 52, 54, 55, 56, or 58',
            lang: languageCode,
          );
        }
        break;

      case 'KW': // الكويت (Kuwait)
        // Mobile in KW: 8 digits starting with 5, 6, 9
        if (rawNumber.length != 8) {
          return _msg(
            ar: 'رقم الهاتف الكويتي يجب أن يتكون من 8 أرقام',
            en: 'Kuwait phone number must be 8 digits',
            lang: languageCode,
          );
        }
        if (!RegExp(r'^[569]\d{7}$').hasMatch(rawNumber)) {
          return _msg(
            ar: 'رقم الهاتف الكويتي يجب أن يبدأ بـ 5 أو 6 أو 9',
            en: 'Kuwait phone number must start with 5, 6, or 9',
            lang: languageCode,
          );
        }
        break;

      case 'QA': // قطر (Qatar)
        // Mobile in QA: 8 digits starting with 3, 5, 6, 7
        if (rawNumber.length != 8) {
          return _msg(
            ar: 'رقم الهاتف القطري يجب أن يتكون من 8 أرقام',
            en: 'Qatar phone number must be 8 digits',
            lang: languageCode,
          );
        }
        if (!RegExp(r'^[3567]\d{7}$').hasMatch(rawNumber)) {
          return _msg(
            ar: 'رقم الهاتف القطري يجب أن يبدأ بـ 3، 5، 6، أو 7',
            en: 'Qatar phone number must start with 3, 5, 6, or 7',
            lang: languageCode,
          );
        }
        break;

      case 'BH': // البحرين (Bahrain)
        if (rawNumber.length != 8) {
          return _msg(
            ar: 'رقم الهاتف البحريني يجب أن يتكون من 8 أرقام',
            en: 'Bahrain phone number must be 8 digits',
            lang: languageCode,
          );
        }
        if (!RegExp(r'^[36]\d{7}$').hasMatch(rawNumber)) {
          return _msg(
            ar: 'رقم الهاتف البحريني يجب أن يبدأ بـ 3 أو 6',
            en: 'Bahrain phone number must start with 3 or 6',
            lang: languageCode,
          );
        }
        break;

      case 'OM': // سلطنة عمان (Oman)
        if (rawNumber.length != 8) {
          return _msg(
            ar: 'رقم الهاتف العماني يجب أن يتكون من 8 أرقام',
            en: 'Oman phone number must be 8 digits',
            lang: languageCode,
          );
        }
        if (!RegExp(r'^[79]\d{7}$').hasMatch(rawNumber)) {
          return _msg(
            ar: 'رقم الهاتف العماني يجب أن يبدأ بـ 7 أو 9',
            en: 'Oman phone number must start with 7 or 9',
            lang: languageCode,
          );
        }
        break;

      case 'JO': // الأردن (Jordan)
        if (rawNumber.length != 9) {
          return _msg(
            ar: 'رقم الهاتف الأردني يجب أن يتكون من 9 أرقام',
            en: 'Jordan phone number must be 9 digits',
            lang: languageCode,
          );
        }
        if (!RegExp(r'^7[789]\d{7}$').hasMatch(rawNumber)) {
          return _msg(
            ar: 'رقم الهاتف الأردني يجب أن يبدأ بـ 77 أو 78 أو 79',
            en: 'Jordan mobile number must start with 77, 78, or 79',
            lang: languageCode,
          );
        }
        break;

      default:
        // Generic length validation based on Country definitions
        final matchedCountry = countries.firstWhere(
          (c) => c.code.toUpperCase() == iso,
          orElse: () => countries.first,
        );
        if (rawNumber.length < matchedCountry.minLength) {
          return _msg(
            ar: 'رقم الهاتف غير مكتمل (الحد الأدنى ${matchedCountry.minLength} أرقام)',
            en: 'Phone number is too short (min ${matchedCountry.minLength} digits)',
            lang: languageCode,
          );
        }
        if (rawNumber.length > matchedCountry.maxLength) {
          return _msg(
            ar: 'رقم الهاتف يتجاوز الحد المسموح (${matchedCountry.maxLength} رقماً)',
            en: 'Phone number exceeds maximum length of ${matchedCountry.maxLength}',
            lang: languageCode,
          );
        }
        break;
    }

    return null;
  }

  /// Fast boolean check whether [phone] is valid.
  static bool isValid(PhoneNumber? phone) {
    return validate(phone) == null;
  }

  static String _msg({
    required String ar,
    required String en,
    required String lang,
  }) {
    final clean = lang.split('_').first.split('-').first.toLowerCase();
    return clean == 'ar' ? ar : en;
  }
}
