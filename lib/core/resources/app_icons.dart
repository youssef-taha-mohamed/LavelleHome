library;

import 'package:flutter/widgets.dart';

abstract final class AppIcons {
  AppIcons._();

  static const _kFontFam = 'MyFlutterApp';
  static const _fontFamily = 'IconBroken';
  static const _fontMofaser = 'NavBarIcon';
  static const _chatMofaser = 'Chat';
  static const _kFontBlog = 'Blog';

  static const blog = IconData(0xe801, fontFamily: _kFontBlog);
  static const moon = IconData(0xe800, fontFamily: _kFontFam);
  static const myDreams = IconData(0xe801, fontFamily: _kFontFam);
  static const newDream = IconData(0xe802, fontFamily: _kFontFam);
  static const reply = IconData(0xe803, fontFamily: _kFontFam);
  static const reach = IconData(0xe805, fontFamily: _kFontFam);
  static const search = IconData(0xe806, fontFamily: _kFontFam);
  static const share = IconData(0xe807, fontFamily: _kFontFam);
  static const upload = IconData(0xe808, fontFamily: _kFontFam);
  static const verified = IconData(0xe809, fontFamily: _kFontFam);
  static const wallet = IconData(0xe80a, fontFamily: _kFontFam);
  static const bell = IconData(0xe80b, fontFamily: _kFontFam);
  static const comment = IconData(0xe80c, fontFamily: _kFontFam);
  static const fav = IconData(0xe80d, fontFamily: _kFontFam);
  static const home = IconData(0xe80e, fontFamily: _kFontFam);
  static const logo = IconData(0xe80f, fontFamily: _kFontFam);
  static const send = IconData(0xe94e, fontFamily: _fontFamily);
  static const edit = IconData(0xe92d, fontFamily: _fontFamily);

  static const dream = IconData(0xe800, fontFamily: _fontMofaser);
  static const home2 = IconData(0xe801, fontFamily: _fontMofaser);
  static const notification = IconData(0xe802, fontFamily: _fontMofaser);
  static const report = IconData(0xe803, fontFamily: _fontMofaser);
  static const IconData chat = IconData(0xe804, fontFamily: _chatMofaser);
}
