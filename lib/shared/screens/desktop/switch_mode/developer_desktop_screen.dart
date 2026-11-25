import 'package:flutter/material.dart';
import '../../../../core/constant/endpoint.dart';
import '../../../../core/db/kv_db/hive.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/network/client/dio/client.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../feature/auth/presentation/login/view/login.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/main_text.dart';

class DeveloperDesktopScreen extends StatefulWidget {
  const DeveloperDesktopScreen({super.key});

  @override
  State<DeveloperDesktopScreen> createState() => _DeveloperDesktopScreenState();
}

class _DeveloperDesktopScreenState extends State<DeveloperDesktopScreen> {
  late String _selectedEnvironment;
  late final String _initialEnvironment;
  bool _isSaving = false;

  static const String _prodUrl = 'https://devapi.tiba-academy.com/api';
  //'https://api.tiba-academy.com/api';
  static const String _devUrl = 'https://devapi.tiba-academy.com/api';

  @override
  void initState() {
    super.initState();
    if (ApiConfig.baseUrl.contains('devapi')) {
      _selectedEnvironment = 'Developer';
    } else {
      _selectedEnvironment = 'Production';
    }
    _initialEnvironment = _selectedEnvironment;
  }

  Future<void> _confirmSettings() async {
    setState(() {
      _isSaving = true;
    });

    try {
      if (_selectedEnvironment == 'Production') {
        ApiConfig.baseUrl = _prodUrl;
        inspectorEnabled = false;
      } else {
        ApiConfig.baseUrl = _devUrl;
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
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update environment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final isModified = _selectedEnvironment != _initialEnvironment;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // ── Top Navigation Bar ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.maybePop(context),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_rounded,
                          size: 16,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        MainText(
                          'Back',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const MainText(
                  'Developer Settings',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                // Current Active Indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (_initialEnvironment == 'Production'
                                ? Colors.green
                                : Colors.orange)
                            .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          (_initialEnvironment == 'Production'
                                  ? Colors.green
                                  : Colors.orange)
                              .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _initialEnvironment == 'Production'
                              ? Colors.green
                              : Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      MainText(
                        'Active: $_initialEnvironment',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _initialEnvironment == 'Production'
                            ? (isDark
                                  ? Colors.greenAccent
                                  : Colors.green.shade800)
                            : (isDark
                                  ? Colors.orangeAccent
                                  : Colors.orange.shade800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable Content Area ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 880),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      const MainText(
                        'Select Environment',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Choose the backend infrastructure and debugging configuration for your app session.',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Environment Cards Grid / Row
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 640;
                          final cards = [
                            _buildEnvironmentCard(
                              title: 'Production Mode',
                              badge: 'Live Stable',
                              badgeColor: Colors.green,
                              subtitle:
                                  'Connect to live production servers for official data and courses.',
                              url: _prodUrl,
                              inspectorLabel: 'Disabled (Fast)',
                              inspectorActive: false,
                              icon: Icons.cloud_done_rounded,
                              iconColor: Colors.green,
                              isSelected: _selectedEnvironment == 'Production',
                              onTap: () {
                                setState(() {
                                  _selectedEnvironment = 'Production';
                                });
                              },
                              isDark: isDark,
                              cardColor: cardColor,
                              borderColor: borderColor,
                            ),
                            _buildEnvironmentCard(
                              title: 'Developer Mode',
                              badge: 'Azure Staging',
                              badgeColor: Colors.orange,
                              subtitle:
                                  'Connect to Azure staging servers with Network Inspector enabled.',
                              url: _devUrl,
                              inspectorLabel: 'Enabled (Debug)',
                              inspectorActive: true,
                              icon: Icons.developer_board_rounded,
                              iconColor: Colors.orange,
                              isSelected: _selectedEnvironment == 'Developer',
                              onTap: () {
                                setState(() {
                                  _selectedEnvironment = 'Developer';
                                });
                              },
                              isDark: isDark,
                              cardColor: cardColor,
                              borderColor: borderColor,
                            ),
                          ];

                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: cards[0]),
                                const SizedBox(width: 20),
                                Expanded(child: cards[1]),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                cards[0],
                                const SizedBox(height: 16),
                                cards[1],
                              ],
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 28),

                      // Configuration Details / Preview Card
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.tune_rounded,
                                  size: 18,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                                const SizedBox(width: 8),
                                const MainText(
                                  'Active Configuration Preview',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                const Spacer(),
                                if (isModified)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColors.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Pending Changes',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.primaryColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                            const SizedBox(height: 16),

                            _buildConfigRow(
                              label: 'Selected Environment',
                              value: _selectedEnvironment,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            _buildConfigRow(
                              label: 'API Base URL',
                              value: _selectedEnvironment == 'Production'
                                  ? _prodUrl
                                  : _devUrl,
                              isMonospace: true,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            _buildConfigRow(
                              label: 'Network Inspector Interceptor',
                              value: _selectedEnvironment == 'Production'
                                  ? 'Disabled'
                                  : 'Enabled (Alice Inspector)',
                              valueColor: _selectedEnvironment == 'Production'
                                  ? (isDark
                                        ? Colors.white60
                                        : Colors.grey.shade700)
                                  : (isDark
                                        ? Colors.orangeAccent
                                        : Colors.orange.shade800),
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                            _buildConfigRow(
                              label: 'Storage Persistence',
                              value:
                                  'Hive (DeveloperMode & DeveloperEnvironment)',
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Notice Banner
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF0284C7,
                          ).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFF0284C7,
                            ).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: Color(0xFF0284C7),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Clicking "Confirm & Restart" will persist settings locally and navigate back to the Login screen with the chosen environment active.',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: isDark
                                      ? Colors.white70
                                      : const Color(0xFF0369A1),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: borderColor),
                            ),
                            onPressed: () => Navigator.maybePop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          MainButton(
                            width: 220,
                            height: 48,
                            borderRadius: 12,
                            backgroundColor: MyColors.primaryColor,
                            isLoading: _isSaving,
                            onPressed: _confirmSettings,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.restart_alt_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Confirm & Restart',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentCard({
    required String title,
    required String badge,
    required Color badgeColor,
    required String subtitle,
    required String url,
    required String inspectorLabel,
    required bool inspectorActive,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required Color cardColor,
    required Color borderColor,
  }) {
    final activeBorderColor = MyColors.primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeBorderColor : borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: MyColors.primaryColor.withValues(
                      alpha: isDark ? 0.25 : 0.12,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon + Badge + Selection Check
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: badgeColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? MyColors.primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? MyColors.primaryColor
                          : (isDark ? Colors.white30 : Colors.black26),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Title
            MainText(title, fontSize: 17, fontWeight: FontWeight.bold),
            const SizedBox(height: 6),

            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 14),

            // URL badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.link_rounded,
                    size: 14,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontFamily: 'monospace',
                        color: isDark ? Colors.white70 : Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Inspector chip
            Row(
              children: [
                Icon(
                  Icons.bug_report_outlined,
                  size: 14,
                  color: inspectorActive
                      ? Colors.orange
                      : (isDark ? Colors.white38 : Colors.grey.shade500),
                ),
                const SizedBox(width: 6),
                Text(
                  'Inspector: $inspectorLabel',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: inspectorActive
                        ? (isDark
                              ? Colors.orangeAccent
                              : Colors.orange.shade800)
                        : (isDark ? Colors.white54 : Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow({
    required String label,
    required String value,
    Color? valueColor,
    bool isMonospace = false,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 220,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: isMonospace ? 'monospace' : null,
              color: valueColor ?? (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
