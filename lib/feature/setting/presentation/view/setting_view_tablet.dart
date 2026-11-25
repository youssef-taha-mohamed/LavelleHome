import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/resources/images.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/cubits/theme/theme_cubit.dart';
import '../../../../shared/widgets/custom_toast.dart';
import '../../../../shared/widgets/main_text.dart';
import '../../../auth/presentation/change_password/view/change_password.dart';
import '../../../auth/presentation/login/view/login.dart';
import '../../../user/domain/entities/parameters/update_preference.dart';
import '../cubit/setting_cubit.dart';

class SettingViewTablet extends StatelessWidget {
  const SettingViewTablet({
    super.key,
    required this.settingCubit,
    required this.isNotificationEnabled,
    required this.isUpdateAvailable,
    required this.isCheckingVersion,
    required this.storeVersion,
    required this.packageInfo,
    required this.onToggleNotification,
    required this.onLaunchStore,
    required this.appStoreLink,
  });

  final SettingCubit settingCubit;
  final bool isNotificationEnabled;
  final bool isUpdateAvailable;
  final bool isCheckingVersion;
  final String? storeVersion;
  final String? appStoreLink;
  final PackageInfo packageInfo;
  final VoidCallback onToggleNotification;
  final VoidCallback onLaunchStore;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Row(
      children: [
        // ─── Left Branding Panel ────────────────────────────────────
        Expanded(
          flex: AppResponsive.getFontSize(context,
                  mobile: 0, smallTablet: 42, largeTablet: 30)
              .toInt(),
          child: _BrandingPanel(
            packageInfo: packageInfo,
            isUpdateAvailable: isUpdateAvailable,
            storeVersion: storeVersion,
            isCheckingVersion: isCheckingVersion,
          ),
        ),
        // ─── Right Settings Panel ───────────────────────────────────
        Expanded(
          flex: AppResponsive.getFontSize(context,
                  mobile: 100, smallTablet: 65, largeTablet: 70)
              .toInt(),
          child: Container(
            color: colors.background,
            child: SafeArea(
              child: Column(
                children: [
                  _TabletHeader(colors: colors),
                  Expanded(
                    child: BlocConsumer<SettingCubit, SettingState>(
                      listener: (context, state) {
                        if (state.isErrorDelete) {
                          ToastService.showError(context, state.errorMessage!);
                        }
                        if (state.isSuccessDelete) {
                          ToastService.showSuccess(
                              context, state.successMessage!);
                          AuthenticationProvider.instance.logout().then((_) {
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                LoginView.routeName,
                                (route) => false,
                              );
                            }
                          });
                        }
                        if (state.isSuccessToggle) {
                          ToastService.showSuccess(
                              context, state.successMessage!);
                        }
                      },
                      builder: (context, state) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: AppResponsive.getPadding(context),
                              vertical:
                                  AppResponsive.getPadding(context) * 1.5),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 700),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Customization Section ───────
                                _SectionHeader(
                                  title: context.l10n.customization,
                                  icon: Icons.palette_outlined,
                                ),
                                const SizedBox(height: 16),
                                _buildCustomizationCards(context, colors),
                                const SizedBox(height: 32),

                                // ── Security Section ────────────
                                _SectionHeader(
                                  title: context.l10n.security_privacy,
                                  icon: Icons.security_outlined,
                                ),
                                const SizedBox(height: 16),
                                _buildSecurityCards(context, colors),
                                const SizedBox(height: 32),

                                // ── App Info Section ────────────
                                _SectionHeader(
                                  title: context.l10n.application_info,
                                  icon: Icons.info_outline,
                                ),
                                const SizedBox(height: 16),
                                _buildVersionCard(context, colors),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Customization cards (theme + notifications) in a row
  // ─────────────────────────────────────────────────────────────────────
  Widget _buildCustomizationCards(
      BuildContext context, AppColorsExtension colors) {
    final bool isLargeTablet =
        AppResponsive.getCategory(context) == DeviceCategory.largeTablet;

    if (!isLargeTablet) {
      return Column(
        children: [
          _themeCard(context),
          const SizedBox(height: 16),
          _notificationCard(context),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _themeCard(context)),
        const SizedBox(width: 16),
        Expanded(child: _notificationCard(context)),
      ],
    );
  }

  Widget _themeCard(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.isDark;
        return _TabletSettingCard(
          icon: isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
          iconColor: isDark ? MyColors.warning500 : MyColors.primaryColor,
          title: context.l10n.app_theme,
          subtitle: isDark ? context.l10n.dark_theme : context.l10n.light_theme,
          trailing: Transform.scale(
            scale: 0.85,
            child: Switch(
              value: isDark,
              onChanged: (bool value) async {
                final themeCubit = DependencyInjector.themeCubit;
                themeCubit.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
                final themeIdToSend = value ? 2 : 1;
                await themeCubit.updatePreference(
                  UpdatePreference(
                    themeId: themeIdToSend,
                    languageId: AuthenticationProvider.instance.currentUser
                            ?.details.preference.languageId ??
                        0,
                  ),
                );
              },
              activeThumbColor: MyColors.darkGreen,
              activeTrackColor: MyColors.darkGreen.withValues(alpha: 0.3),
              inactiveThumbColor: MyColors.goldAccent,
              inactiveTrackColor: MyColors.goldAccent.withValues(alpha: 0.3),
            ),
          ),
        );
      },
    );
  }

  Widget _notificationCard(BuildContext context) {
    return BlocListener<SettingCubit, SettingState>(
      listener: (context, state) {
        if (state.isErrorToggle) {
          ToastService.showError(context, state.errorMessage.toString());
        }
        if (state.isSuccessToggle) {
          AuthenticationProvider.instance.refreshUser();
        }
      },
      child: _TabletSettingCard(
        icon: isNotificationEnabled
            ? Icons.notifications_active
            : Icons.notifications_off_outlined,
        iconColor: MyColors.success500,
        title: context.l10n.notification,
        subtitle: isNotificationEnabled
            ? context.l10n.activated
            : context.l10n.disabled,
        trailing: Transform.scale(
          scale: 0.85,
          child: Switch(
            value: isNotificationEnabled,
            onChanged: (_) => onToggleNotification(),
            activeThumbColor: MyColors.success500,
            activeTrackColor: MyColors.success500.withValues(alpha: 0.3),
            inactiveThumbColor: MyColors.neutral400,
            inactiveTrackColor: MyColors.neutral200,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Security cards (change password + delete account) in a row
  // ─────────────────────────────────────────────────────────────────────
  Widget _buildSecurityCards(BuildContext context, AppColorsExtension colors) {
    final bool isLargeTablet =
        AppResponsive.getCategory(context) == DeviceCategory.largeTablet;

    if (!isLargeTablet) {
      return Column(
        children: [
          _changePasswordCard(context),
          const SizedBox(height: 16),
          _deleteAccountCard(context),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: _changePasswordCard(context)),
        const SizedBox(width: 16),
        Expanded(child: _deleteAccountCard(context)),
      ],
    );
  }

  Widget _changePasswordCard(BuildContext context) {
    return _TabletSettingCard(
      icon: Icons.lock_outline,
      iconColor: MyColors.warning500,
      title: context.l10n.change_password,
      subtitle: context.l10n.change_your_password,
      onTap: () {
        Navigator.pushNamed(context, ChangePasswordScreen.routeName);
      },
    );
  }

  Widget _deleteAccountCard(BuildContext context) {
    return _TabletSettingCard(
      icon: Icons.delete_outline,
      iconColor: MyColors.error500,
      title: context.l10n.delete_account,
      subtitle: context.l10n.delete_account_warning,
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(context.l10n.delete_account_warning),
              content: Text(context.l10n.delete_account_message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(context.l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    settingCubit.deleteAccount();
                  },
                  child: Text(context.l10n.delete_account),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Version info card (full-width)
  // ─────────────────────────────────────────────────────────────────────
  Widget _buildVersionCard(BuildContext context, AppColorsExtension colors) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;

    return GestureDetector(
      onTap: isUpdateAvailable && appStoreLink != null ? onLaunchStore : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: theme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: theme.mediumShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: MyColors.neutral400.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  Icons.info_outline,
                  size: AppResponsive.getIconSize(context, base: 18),
                  color: MyColors.neutral400,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainText(
                    context.l10n.version(""),
                    fontSize: AppResponsive.getFontSize(context,
                        mobile: 16, smallTablet: 18, largeTablet: 20),
                    fontWeight: FontWeight.w600,
                    color: context.isDark ? MyColors.white : MyColors.black900,
                  ),
                  const SizedBox(height: 6),
                  MainText(
                    isUpdateAvailable && storeVersion != null
                        ? context.l10n.current_and_store_version(
                            packageInfo.version, storeVersion!)
                        : context.l10n.current_version(packageInfo.version),
                    fontSize: AppResponsive.getFontSize(context,
                        mobile: 14, smallTablet: 16, largeTablet: 18),
                    color: MyColors.neutral500,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            _buildVersionBadge(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionBadge(BuildContext context) {
    if (isCheckingVersion) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: MyColors.neutral400,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isUpdateAvailable ? MyColors.warning100 : MyColors.success100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUpdateAvailable) ...[
            const Icon(
              Icons.download_outlined,
              size: 24,
              color: MyColors.warning700,
            ),
            const SizedBox(width: 6),
          ],
          MainText(
            isUpdateAvailable
                ? context.l10n.update_now
                : context.l10n.up_to_date,
            fontSize: AppResponsive.getFontSize(context,
                mobile: 14, smallTablet: 16, largeTablet: 18),
            fontWeight: FontWeight.w600,
            color:
                isUpdateAvailable ? MyColors.warning700 : MyColors.success700,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Left Branding Panel
// ═══════════════════════════════════════════════════════════════════════════
class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel({
    required this.packageInfo,
    required this.isUpdateAvailable,
    required this.storeVersion,
    required this.isCheckingVersion,
  });

  final PackageInfo packageInfo;
  final bool isUpdateAvailable;
  final String? storeVersion;
  final bool isCheckingVersion;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MyColors.primaryColor,
            MyColors.darkGreen,
          ],
        ),
      ),
      child: Stack(
        children: [
          _DecorativeCircles(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Settings icon
                  Container(
                    width: AppResponsive.getFontSize(context,
                        mobile: 80, smallTablet: 110, largeTablet: 140),
                    height: AppResponsive.getFontSize(context,
                        mobile: 80, smallTablet: 110, largeTablet: 140),
                    decoration: BoxDecoration(
                      color: MyColors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: MyColors.white.withValues(alpha: 0.25),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.darkGreen.withValues(alpha: 0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        ImagesAssets.logo,
                        fit: BoxFit.cover,
                        color: MyColors.grey100,
                        colorBlendMode: BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  MainText(
                    context.l10n.settings,
                    color: MyColors.white,
                    fontSize: AppResponsive.getFontSize(context,
                        mobile: 22, smallTablet: 26, largeTablet: 32),
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  MainText(
                    context.l10n.customization,
                    color: MyColors.white.withValues(alpha: 0.7),
                    fontSize: AppResponsive.getFontSize(context,
                        mobile: 14, smallTablet: 18, largeTablet: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Gold divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                MyColors.islamicGold.withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Feature items
                  ..._featureItems(context).map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textDirection: context.isArabic
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(top: 5),
                            decoration: const BoxDecoration(
                              color: MyColors.islamicGold,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MainText(
                              item,
                              color: MyColors.white.withValues(alpha: 0.85),
                              fontSize: AppResponsive.getFontSize(context,
                                  mobile: 14, smallTablet: 18, largeTablet: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Version at bottom
                  MainText(
                    'v${packageInfo.version}',
                    color: MyColors.white.withValues(alpha: 0.4),
                    fontSize: 18,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _featureItems(BuildContext context) {
    if (context.isArabic) {
      return [
        'تخصيص مظهر التطبيق حسب رغبتك',
        'إدارة الإشعارات والخصوصية',
        'تأمين حسابك وتغيير كلمة المرور',
      ];
    }
    return [
      'Customize the app appearance',
      'Manage notifications & privacy',
      'Secure your account & change password',
    ];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Decorative circles
// ═══════════════════════════════════════════════════════════════════════════
class _DecorativeCircles extends StatelessWidget {
  const _DecorativeCircles();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: _circle(200, MyColors.white.withValues(alpha: 0.05)),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: _circle(240, MyColors.islamicGold.withValues(alpha: 0.07)),
          ),
          Positioned(
            top: 180,
            left: -30,
            child: _circle(120, MyColors.white.withValues(alpha: 0.04)),
          ),
          Positioned(
            bottom: 160,
            right: -15,
            child: _circle(90, MyColors.islamicGold.withValues(alpha: 0.06)),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

// ═══════════════════════════════════════════════════════════════════════════
// Tablet Header
// ═══════════════════════════════════════════════════════════════════════════
class _TabletHeader extends StatelessWidget {
  const _TabletHeader({required this.colors});

  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.getPadding(context),
          vertical: AppResponsive.getPadding(context) / 2),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(
          bottom: BorderSide(
            color: context.isDark ? MyColors.darkItemBG3 : MyColors.neutral200,
          ),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    context.isDark ? MyColors.darkItemBG3 : MyColors.neutral100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: AppResponsive.getIconSize(context, base: 14),
                color: colors.textColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          MainText(
            context.l10n.settings,
            fontSize: AppResponsive.getFontSize(context,
                mobile: 22, smallTablet: 24, largeTablet: 28),
            fontWeight: FontWeight.bold,
            color: colors.textColor,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.settings,
              size: AppResponsive.getIconSize(context, base: 22),
              color: MyColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Section Header
// ═══════════════════════════════════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: MyColors.darkGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: AppResponsive.getIconSize(context, base: 14),
            color: MyColors.darkGreen,
          ),
        ),
        const SizedBox(width: 12),
        MainText(
          title,
          fontSize: AppResponsive.getFontSize(context,
              mobile: 14, smallTablet: 18, largeTablet: 20),
          fontWeight: FontWeight.w700,
          color: context.isDark ? MyColors.white : MyColors.neutral700,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Tablet Setting Card (larger, more spacious version of SettingsTile)
// ═══════════════════════════════════════════════════════════════════════════
class _TabletSettingCard extends StatelessWidget {
  const _TabletSettingCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.mediumShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: AppResponsive.getIconSize(context, base: 16),
                      color: iconColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainText(
                        title,
                        fontSize: AppResponsive.getFontSize(context,
                            mobile: 16, smallTablet: 18, largeTablet: 20),
                        fontWeight: FontWeight.w600,
                        color:
                            context.isDark ? MyColors.white : MyColors.black900,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        MainText(
                          subtitle!,
                          fontSize: AppResponsive.getFontSize(context,
                              mobile: 12, smallTablet: 14, largeTablet: 16),
                          color: MyColors.neutral500,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ],
                  ),
                ),
                // Trailing
                if (trailing != null)
                  trailing!
                else if (onTap != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.isDark
                          ? MyColors.darkItemBG3
                          : MyColors.neutral100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 24,
                      color: MyColors.neutral600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
