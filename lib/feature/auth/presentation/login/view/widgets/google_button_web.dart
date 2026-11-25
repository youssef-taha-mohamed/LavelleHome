import 'package:flutter/material.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;

Widget buildWebGoogleButton() {
  return SizedBox(
    height: 56, // Match the height of the standard button
    child: (GoogleSignInPlatform.instance as web.GoogleSignInPlugin)
        .renderButton(
      configuration: web.GSIButtonConfiguration(
        type: web.GSIButtonType.standard,
        size: web.GSIButtonSize.large,
      ),
    ),
  );
}
