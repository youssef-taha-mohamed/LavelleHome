import 'package:flutter/material.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/constant/endpoint.dart';
import '../../../../core/db/kv_db/hive.dart';
import '../../../../core/network/client/dio/client.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../feature/auth/presentation/login/view/login.dart';
import '../../../widgets/main_text.dart';
import '../../../widgets/main_button.dart';
import '../../desktop/switch_mode/developer_desktop_screen.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  String _selectedEnvironment = 'Production';

  @override
  void initState() {
    super.initState();
    // Initialize based on current setting
    if (ApiConfig.baseUrl.contains('azurewebsites')) {
      _selectedEnvironment = 'Developer';
    } else {
      _selectedEnvironment = 'Production';
    }
  }

  Future<void> _confirmSettings() async {
    if (_selectedEnvironment == 'Production') {
      ApiConfig.baseUrl = 'https://api.tiba-academy.com/api';
      inspectorEnabled = false;
    } else {
      ApiConfig.baseUrl = 'https://devapi.tiba-academy.com/api';
      inspectorEnabled = true;
    }

    // Persist to Hive so settings survive app restart
    await HiveDatabase.setDeveloperMode(inspectorEnabled);
    await HiveDatabase.setDeveloperEnvironment(ApiConfig.baseUrl);

    // Update DioClient settings dynamically
    DioClient().updateSettings();

    if (!mounted) return;

    // Navigate back to Login
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginView.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (AppResponsive.isDesktop(context) || constraints.maxWidth >= 768) {
          return const DeveloperDesktopScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Developer Settings'),
            backgroundColor: MyColors.primaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MainText(
                  'Select Environment',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 24),
                ListTile(
                  title: const Text('Production Mode'),
                  subtitle: const Text('Connect to live production servers'),
                  leading: const Icon(Icons.cloud_done, color: Colors.green),
                  trailing: _selectedEnvironment == 'Production'
                      ? const Icon(
                          Icons.check_circle,
                          color: MyColors.primaryColor,
                        )
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _selectedEnvironment == 'Production'
                          ? MyColors.primaryColor
                          : Colors.grey.shade300,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedEnvironment = 'Production';
                    });
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Developer Mode'),
                  subtitle: const Text('Connect to staging/developer servers'),
                  leading: const Icon(
                    Icons.developer_board,
                    color: Colors.orange,
                  ),
                  trailing: _selectedEnvironment == 'Developer'
                      ? const Icon(
                          Icons.check_circle,
                          color: MyColors.primaryColor,
                        )
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _selectedEnvironment == 'Developer'
                          ? MyColors.primaryColor
                          : Colors.grey.shade300,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedEnvironment = 'Developer';
                    });
                  },
                ),
                const Spacer(),
                MainButton(
                  onPressed: _confirmSettings,
                  title: 'Confirm & Restart',
                  backgroundColor: MyColors.primaryColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
