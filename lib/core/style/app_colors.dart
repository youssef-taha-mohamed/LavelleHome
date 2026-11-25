import 'package:flutter/material.dart';

class MyColors {
  // ═══════════════════════════════════════════════════════════
  //  SHARED BRAND TOKENS  (جديدة - نفس القيم تماماً في تطبيق المحل)
  //  أضيفت فقط، لم يُحذف أو يُغيّر أي اسم موجود
  // ═══════════════════════════════════════════════════════════
  static const Color primary = Color(0xFF00488D); // الكحلي الأساسي
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF005FB8);
  static const Color onPrimaryContainer = Color(0xFFCADCFF);
  static const Color primaryDark = Color(0xFF002E5C);
  static const Color deepBlue = Color(0xFF002E5C); // كحلي أعمق للتدرج
  static const Color skyBlue = Color(0xFF7EC9E8); // السماوي (لون الهوية الثاني)
  static const Color secondary = Color(0xFF002E5C);
  static const Color tertiary = Color(0xFF00505B);
  static const Color surface = Color(0xFFF9F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FB);
  static const Color surfaceContainer = Color(0xFFECEDF6);
  static const Color surfaceContainerHigh = Color(0xFFE7E8F0);
  static const Color surfaceContainerHighest = Color(0xFFE1E2EA);
  static const Color onSurface = Color(0xFF191C21);
  static const Color onSurfaceVariant = Color(0xFF424752);
  static const Color outline = Color(0xFF727783);
  static const Color outlineVariant = Color(0xFFC2C6D4);
  static const Color success = Color(0xFF16A34A);
  static const Color successContainer = Color(0xFFD1FAE5);

  // ================= PRIMARY SWATCH (كان Indigo ← أصبح Navy) =================

  static const MaterialColor defaultColor = MaterialColor(
    _defaultColorPrimaryValue,
    <int, Color>{
      50: Color(0xFFE6EDF4), // was EEF2FF
      100: Color(0xFFCCDAE8), // was E0E7FF
      200: Color(0xFF99B6D1), // was C7D2FE
      300: Color(0xFF6691BB), // was A5B4FC
      400: Color(0xFF336DA4), // was 818CF8
      500: Color(_defaultColorPrimaryValue),
      600: Color(0xFF004281), // was 4338CA
      700: Color(0xFF003B74), // was 3730A3
      800: Color(0xFF003468), // was 312E81
      900: Color(0xFF002E5C), // was 1E1B4B
    },
  );
  static const int _defaultColorPrimaryValue = 0xFF00488D; // was 0xFF4F46E5

  static const primaryColor = defaultColor;
  static const Color darkPrimary = Color(0xFF003B74); // was 3730A3
  static const Color darkPrimaryLight = Color(0xFF004281); // was 4338CA
  static const Color darkPrimaryDark = Color(0xFF003468); // was 312E81
  static const Color cardBg = Color(0xFFfbfbf9);
  static const Color purple = Color(0xFF336DA4); // was 6366F1

  static const Color secondaryColor = Color(0xFF99B6D1); // was C7D2FE
  static const Color tertiaryColor = Color(0xFF7EC9E8); // was 818CF8
  static const Color textDisabled = Color(0xFFC7C7C7);

  static const Color goldAccent = Color(
    0xFFE4B95B,
  ); // was F59E0B (= تطبيق المحل)
  static const Color darkGreen = Color(0xFF002E5C); // was 1E1B4B (كحلي عميق)
  static const Color navyColor = Color(0xFF0f1c2e);

  static const Color darkThemeBg = Color(0xFF1B1E23);
  static const Color lightThemeBg = Color(0xFFFDFDFD);

  static const Color background = Color(
    0xFFF9F9FF,
  ); // was F4F4F5 (لمسة زرقاء خفيفة)

  static const Color colorTheme = Color(0xFFEFB287);
  static const Color colorDark = Color(0xFFEDA674);
  static const Color colorLight = Color(0xFFF2D1B7);
  static const Color amber = Color(0xFFD97706);

  static const Color textTwo = Color(0xff8E8E8E);
  static const Color customRed = Color(0xffE7484C);
  static const Color black = Color(0xff021424);
  static const Color grey1 = Color(0xFF606060);
  static const Color scaffoldColor = Color(0xFFF2F3FB); // was F4F4F4
  static const Color dialogColor = Color(0xff2A303E);
  static const Color appYellow = Color(0xffEDA10E);
  static const Color green = Color(0xFF0C9B23);
  static const Color greenOpacity1 = Color(0x1A4CAF50);
  static const Color hintTextColor = Color(0xFF515151);
  static const Color white0 = Color(0xFF6C6C6C);
  static const Color iconBackColor = Color(0xFF001A72);
  static const Color grey19 = Color(0xffD9D9D9);
  static const Color grey10 = Color(0xff626262);
  static const Color grey4 = Color(0xff8D8D8D);
  static const Color blurOpacity = Color(0xffCEE5FB);
  static const Color grey3 = Color(0xffA0A0A0);
  static const Color chatColor = Color(0xffCCCCCC);
  static const Color chatColor2 = Color(0xffE9E9E9);
  static const Color colorCard = Color(0xffDDDDDD);
  static const Color textCard = Color(0xff717171);
  static const Color buttonProfile = Color(0xffA0A0A0);
  static const Color textBottomSheetColor = Color(0xff52616A);
  static const Color buttonBlue = Color.fromRGBO(14, 123, 223, 0.10);
  static const Color red = Colors.red;
  static const Color appRed = Color(0xFFAC3C44);
  static const Color white = Colors.white;
  static const Color whiteOpacity2 = Color(0x33FFFFFF);
  static const Color whiteOpacity5 = Color(0x80FFFFFF);
  static Color red700 = Colors.red.shade700;
  static const Color grey = Colors.grey;
  static const Color itemBHome = Color(0xff4D4D4D);
  static const Color blackOpacity700 = Color(0xB3000000);
  static const Color colorShimmerCard = Color(0xFF112637);
  static const Color baseColorShimmer = Color(0xFF2b556b);
  static const Color iconsColor = Color(0xffABABAB);
  static const Color greyBorder = Color(0xffD3D3D3);
  static const Color textThree = Color(0xff4E4E4E);
  static const Color darkBlue = Color(0xFF0865AE); // was 454F54 (= تطبيق المحل)
  static const Color appGreen = Color(0xff56EEC5);
  static const Color blue = Colors.blue;
  static const Color itemBG = Color(0xFFE8E7E7);
  static const Color darkItemBG = Color(0xFF2B2B2B);
  static const Color darkItemBG2 = Color(0xFF24292D);
  static const Color darkItemBG3 = Color(0xFF0F1116);
  static const Color darkItemBG4 = Color(0xFF1c1f24);
  static const Color darkItemBG5 = Color((0xFF1B2735));
  static const Color darkItemBG6 = Color((0xFF1B2735));
  static const Color darkGrey = Color(0xff1B1B1B);
  static const Color yellow2 = Color(0xffFDDB7A);
  static const color6 = Color(0xff97A1AF);
  static const grey50 = Color(0xFFFAFAFA);
  static const grey100 = Color(0xFFF5F5F5);
  static const grey200 = Color(0xFFEEEEEE);
  static const grey300 = Color(0xFFE0E0E0);
  static const grey400 = Color(0xFFBDBDBD);
  static const grey500 = Color(0xFF9E9E9E);
  static const grey600 = Color(0xFF757575);
  static const navyColorOpacity = Color(0x500F1C2E);
  static const grey700 = Color(0xFF616161);
  static const errorText = Color(0xFF718096);
  static const colorPlanError = Color(0xFF2D3748);
  static const Color color2 = Color(0xffF5EDFB);
  static const Color color14 = Color(0xff111827);

  static const color3 = Color(0xff476D8E);
  static const color8 = Color(0xff0b2235);
  static const Color error = Color(0xFFF44336); // was DC3545 (= تطبيق المحل)

  // new colors
  static const Color islamicGold = Color(0xFFDAAA33);
  static const Color darkCard = Color(0xFF16181D);
  static const Color darkCardElevated = Color(0xFF1E2128);
  static const Color darkBorder = Color(0xFF282C34);

  // لون أخضر مائل للأزرق بدرجة أفتح قليلا
  static const Color lightTeal = Color(0xFF3DACAC);

  // لون أخضر داكن لإضافة العمق
  static const Color deepGreen = Color(0xFF174D4D);

  // درجات لون الخط المناسبة للتطبيق
  static const Color textDark = Color(0xFF1A3838);
  static const Color textLight = Color(0xFFF9FFFF);

  // لون خلفية بديل للوضع الفاتح
  static const Color lightBackground = Color(0xFFF0F7F7);

  // ألوان مناسبة لعناصر الآيات القرآنية
  static const Color verseBackground = Color(0xFFF8F4E9);
  static const Color verseBorder = Color(0xFFD1C9B0);

  // ألوان تمييز أحكام التجويد
  static const Color tajweedRed = Color(0xFFD13A3A);
  static const Color tajweedBlue = Color(0xFF3A64D1);
  static const Color tajweedGreen = Color(0xFF3AD15A);

  static const Color yellow900 = Color(0xFF2F2602);
  static const Color yellow800 = Color(0xFF5D4C05);
  static const Color yellow700 = Color(0xFF927500);
  static const Color yellow600 = Color(0xFFC39C00);
  static const Color yellow500 = Color(0xFFF3C300);
  static const Color yellow400 = Color(0xFFFFD52A);
  static const Color yellow300 = Color(0xFFFFDF5F);
  static const Color yellow200 = Color(0xFFF4E4A0);
  static const Color yellow100 = Color(0xFFFAF1D0);
  static const Color yellow50 = Color(0xFFFCF8E8);

  // Black Color Palette
  static const Color black900 = Color(0xFF000000);
  static const Color black800 = Color(0xFF1C1C1C);
  static const Color black700 = Color(0xFF393939);
  static const Color black600 = Color(0xFF565656);
  static const Color black500 = Color(0xFF727272);
  static const Color black400 = Color(0xFF8F8F8F);
  static const Color black300 = Color(0xFFABABAB);
  static const Color black200 = Color(0xFFC7C7C7);
  static const Color black100 = Color(0xFFE4E4E4);
  static const Color black50 = Color(0xFFF2F2F2);

  // Neutral Color Palette
  static const Color neutral900 = Color(0xFF1B1B1B);
  static const Color neutral800 = Color(0xFF363636);
  static const Color neutral700 = Color(0xFF525252);
  static const Color neutral600 = Color(0xFF6D6D6D);
  static const Color neutral500 = Color(0xFF898989);
  static const Color neutral400 = Color(0xFFA4A4A4);
  static const Color neutral300 = Color(0xFFC0C0C0);
  static const Color neutral200 = Color(0xFFDBDBDB);
  static const Color neutral100 = Color(0xFFF7F7F7);
  static const Color neutral50 = Color(0xFFFAFAFA);

  // Success Color Palette
  static const Color success900 = Color(0xFF042619);
  static const Color success800 = Color(0xFF07442D);
  static const Color success700 = Color(0xFF056842);
  static const Color success600 = Color(0xFF068756);
  static const Color success500 = Color(0xFF08A76A);
  static const Color success400 = Color(0xFF0BE994);
  static const Color success300 = Color(0xFF43F6B1);
  static const Color success200 = Color(0xFF90EDCA);
  static const Color success100 = Color(0xFFCBF7E6);
  static const Color success50 = Color(0xFFE9FCF4);

  // Error Color Palette (كانت وردية/كرمزي ← أصبحت نفس باليت تطبيق المحل)
  static const Color error900 = Color(0xFF572024);
  static const Color error800 = Color(0xFF6D272D);
  static const Color error700 = Color(0xFF823038);
  static const Color error600 = Color(0xFF99363E);
  static const Color error500 = Color(0xFFAC3C44);
  static const Color error400 = Color(0xFFBE6269);
  static const Color error300 = Color(0xFFD18A90);
  static const Color error200 = Color(0xFFE0ADB1);
  static const Color error100 = Color(0xFFEED1D3);
  static const Color error50 = Color(0xFFF8EBEC);

  // Warning Color Palette
  static const Color warning900 = Color(0xFF311E07);
  static const Color warning800 = Color(0xFF68400F);
  static const Color warning700 = Color(0xFFA56210);
  static const Color warning600 = Color(0xFFDE8315);
  static const Color warning500 = Color(0xFFEDA145);
  static const Color warning400 = Color(0xFFF0B369);
  static const Color warning300 = Color(0xFFF4C68D);
  static const Color warning200 = Color(0xFFF1D7B8);
  static const Color warning100 = Color(0xFFF7EAD9);
  static const Color warning50 = Color(0xFFFBF3EA);

  static const color26 = Color(0xFFFEFFD3);
  static const color27 = Color(0xFFEEE7ED);
  static const color28 = Color(0xFFFFCF4E);
  static const color29 = Color(0xFFEAE5EE);
  static const color30 = Color(0xFFE8E8E8);
  static const color31 = Color(0xFF848484);
  static const color32 = Color(0xFF717585);
  static const color33 = Color(0xFFDF0000);
  static const color34 = Color(0xFFD7D6E0);
  static const color35 = Color(0xFFD1D5DB);
  static const color36 = Color(0xFF9CA3AF);
  static const color37 = Color(0xFFE5E7EB);
  static const color38 = Color(0xFFD3FFD5);
  static const color39 = Color(0xFFFFF0E3);
  static const color40 = Color(0xFFFFD3D3);
  static const colorCancel = Color(0xFF770909);
  static const colorComplete = Color(0xFF197709);
  static const colorOngoing = Color(0xFFFE9B4B);
  static const color41 = Color(0xFFD6D6D6);
  static const color25 = Color(0xFF775209);
}
