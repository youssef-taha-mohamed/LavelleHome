import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/cubits/theme/theme_cubit.dart';
import '../../../../shared/widgets/main_text.dart';
import '../../../auth/presentation/change_password/view/change_password.dart';
import '../../../user/domain/entities/parameters/update_preference.dart';
import '../cubit/setting_cubit.dart';

class SettingDesktopScreen extends StatefulWidget {
  final SettingState state;
  final SettingCubit settingCubit;

  const SettingDesktopScreen({
    super.key,
    required this.state,
    required this.settingCubit,
  });

  @override
  State<SettingDesktopScreen> createState() => _SettingDesktopScreenState();
}

class _SettingDesktopScreenState extends State<SettingDesktopScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      if (mounted) setState(() => _packageInfo = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? MyColors.darkThemeBg : const Color(0xFFF7F9FC),
      body: Column(
        children: [
          // Premium Header
          _buildProfessionalHeader(context, isDark),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        child: Column(
                          children: [
                            _buildAccountSection(isDark),
                            const SizedBox(height: 32),
                            _buildSecuritySection(isDark),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Right Column
                      Expanded(
                        child: Column(
                          children: [
                            _buildAppearanceSection(isDark),
                            const SizedBox(height: 32),
                            _buildNotificationsSection(isDark),
                            const SizedBox(height: 32),
                            _buildAboutSection(isDark),
                          ],
                        ),
                      ),
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

  Widget _buildProfessionalHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? MyColors.darkItemBG2 : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : MyColors.neutral200,
          ),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                // context.read<BottomNavProvider>().changeIndex(0);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.white10 : MyColors.neutral300,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 14,
                    color: isDark ? Colors.white70 : MyColors.neutral700,
                  ),
                  const SizedBox(width: 8),
                  MainText(
                    context.l10n.back_button,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : MyColors.neutral700,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MyColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.settings_outlined,
              color: MyColors.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainText(
                context.l10n.settings,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : MyColors.neutral900,
              ),
              MainText(
                context.l10n.app_theme, // Example subtitle concept
                fontSize: 14,
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- UI SECTION COMPOSERS ---

  Widget _buildAccountSection(bool isDark) {
    final user = AuthenticationProvider.instance.currentUser;
    return _buildSectionCard(
      title: context.l10n.account,
      subtitle: context.l10n.personal_information,
      icon: Icons.person_outline_rounded,
      isDark: isDark,
      children: [
        _buildInfoTile(
          context.l10n.full_name,
          user?.details.fullName ?? 'N/A',
          Icons.person_outline,
        ),
        _buildInfoTile(
          context.l10n.email,
          user?.details.email ?? 'N/A',
          Icons.email_outlined,
        ),
        _buildInfoTile(
          context.l10n.phone_number,
          user?.details.phone ?? 'N/A',
          Icons.phone_android_outlined,
        ),
        _buildInfoTile(
          context.l10n.birth_date,
          user?.details.birthday?.toString().substring(0, 10) ?? 'N/A',
          Icons.calendar_today_outlined,
          withDivider: false,
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(bool isDark) {
    return _buildSectionCard(
      title: context.l10n.app_theme,
      subtitle: context.l10n.customization,
      icon: Icons.palette_outlined,
      isDark: isDark,
      children: [
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final isDarkMode = state.isDark;
            return _buildSettingRow(
              title: context.l10n.theme_mode,
              subtitle: isDarkMode
                  ? context.l10n.dark_theme
                  : context.l10n.light_theme,
              icon: isDarkMode
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              isDark: isDark,
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) async {
                  final themeCubit = DependencyInjector.themeCubit;
                  themeCubit.setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                  await themeCubit.updatePreference(
                    UpdatePreference(
                      themeId: value ? 2 : 1,
                      languageId: AuthenticationProvider.instance.currentUser
                              ?.details.preference.languageId ??
                          0,
                    ),
                  );
                },
                activeTrackColor: MyColors.primaryColor.withValues(alpha: 0.5),
                activeThumbColor: MyColors.primaryColor,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(bool isDark) {
    final isNotificationsEnabled = AuthenticationProvider
            .instance.currentUser?.details.notificationEnabled ??
        false;
    return _buildSectionCard(
      title: context.l10n.notification,
      subtitle: context.l10n.manage_notifications,
      icon: Icons.notifications_none_rounded,
      isDark: isDark,
      children: [
        _buildSettingRow(
          title: context.l10n.push_notifications,
          subtitle: isNotificationsEnabled
              ? context.l10n.activated
              : context.l10n.disabled,
          icon: isNotificationsEnabled
              ? Icons.notifications_active_rounded
              : Icons.notifications_off_rounded,
          isDark: isDark,
          trailing: Switch(
            value: isNotificationsEnabled,
            onChanged: (value) {
              widget.settingCubit.toggleNotification();
            },
            activeTrackColor: MyColors.primaryColor.withValues(alpha: 0.5),
            activeThumbColor: MyColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(bool isDark) {
    return _buildSectionCard(
      title: context.l10n.security_privacy,
      subtitle: context.l10n.protect_your_account,
      icon: Icons.security_outlined,
      isDark: isDark,
      children: [
        _buildActionTile(
          context.l10n.change_password,
          context.l10n.change_your_password,
          Icons.lock_reset_rounded,
          () => Navigator.pushNamed(context, ChangePasswordScreen.routeName),
          isDark,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Divider(color: isDark ? Colors.white10 : Colors.black12),
        ),
        _buildActionTile(
          context.l10n.delete_account,
          context.l10n.permanent_deletion_warning,
          Icons.delete_forever_rounded,
          () => _showDeleteDialog(context),
          isDark,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildAboutSection(bool isDark) {
    return _buildSectionCard(
      title: context.l10n.application_info,
      subtitle: context.l10n.system_details,
      icon: Icons.info_outline_rounded,
      isDark: isDark,
      children: [
        _buildInfoTile(
          context.l10n.app_version,
          _packageInfo?.version ?? 'N/A',
          Icons.verified_outlined,
        ),
        _buildInfoTile(
          context.l10n.build_number,
          _packageInfo?.buildNumber ?? 'N/A',
          Icons.code_rounded,
        ),
        _buildInfoTile(
          context.l10n.platform,
          context
              .l10n.web_dashboard, // Make sure you have this translatable key
          Icons.layers_outlined,
          withDivider: false,
        ),
      ],
    );
  }

  // --- BASE WIDGET BUILDERS ---

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? MyColors.darkItemBG3 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: MyColors.primaryColor, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainText(
                      title,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : MyColors.neutral900,
                    ),
                    const SizedBox(height: 2),
                    MainText(
                      subtitle,
                      fontSize: 13,
                      color: isDark ? Colors.white70 : const Color(0xFF64748B),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    String label,
    String value,
    IconData icon, {
    bool withDivider = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: MyColors.primaryColor.withValues(alpha: 0.05),
                child: Icon(icon, color: MyColors.primaryColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainText(
                      label,
                      fontSize: 12,
                      color: context.isDark ? Colors.white54 : MyColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    MainText(
                      value,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color:
                          context.isDark ? Colors.white : MyColors.neutral900,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (withDivider)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                color: context.isDark ? Colors.white10 : Colors.black12,
                height: 1,
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
    required Widget trailing,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: MyColors.primaryColor.withValues(alpha: 0.05),
          child: Icon(icon, color: MyColors.primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainText(
                title,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.isDark ? Colors.white : MyColors.neutral900,
              ),
              const SizedBox(height: 4),
              MainText(
                subtitle,
                fontSize: 12,
                color: context.isDark ? Colors.white54 : MyColors.grey,
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    bool isDark, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDestructive
              ? MyColors.red.withValues(alpha: 0.02)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor:
                  (isDestructive ? MyColors.red : MyColors.primaryColor)
                      .withValues(alpha: 0.08),
              child: Icon(
                icon,
                color: isDestructive ? MyColors.red : MyColors.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainText(
                    title,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDestructive
                        ? MyColors.red
                        : (isDark ? Colors.white : MyColors.neutral900),
                  ),
                  const SizedBox(height: 4),
                  MainText(
                    subtitle,
                    fontSize: 12,
                    color: context.isDark ? Colors.white54 : MyColors.grey,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDestructive
                  ? MyColors.red
                  : (isDark ? Colors.white54 : MyColors.grey),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.isDark ? MyColors.darkItemBG3 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: MainText(
          context.l10n.delete_account_warning,
          color: MyColors.red,
          fontWeight: FontWeight.w900,
        ),
        content: MainText(
          context.l10n.delete_account_message,
          color: context.isDark ? Colors.white70 : MyColors.neutral900,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: MainText(context.l10n.cancel, color: MyColors.grey),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              widget.settingCubit.deleteAccount();
            },
            child: MainText(
              context.l10n.delete_account,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
