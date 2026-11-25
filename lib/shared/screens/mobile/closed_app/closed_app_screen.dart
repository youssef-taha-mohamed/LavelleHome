import 'package:flutter/material.dart';

import '../../../../core/resources/images.dart';

class ClosedAppScreen extends StatefulWidget {
  const ClosedAppScreen({super.key});

  static const routeName = '/closed_app_screen';

  @override
  State<ClosedAppScreen> createState() => _ClosedAppScreenState();
}

class _ClosedAppScreenState extends State<ClosedAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          ImagesAssets.lockScreen,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
