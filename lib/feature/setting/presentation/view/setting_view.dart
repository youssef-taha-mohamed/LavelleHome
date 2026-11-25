import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../core/extension/extension_helper.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/cubits/theme/theme_cubit.dart';
import '../../../../shared/widgets/custom_header.dart';
import '../../../../shared/widgets/custom_toast.dart';
import '../../../../shared/widgets/main_text.dart';
import '../../../auth/presentation/change_password/view/change_password.dart';
import '../../../auth/presentation/login/view/login.dart';
import '../../../user/domain/entities/parameters/update_preference.dart';
import '../cubit/setting_cubit.dart';
import 'setting_view_tablet.dart';
import 'widgets/setting_item.dart';
import '../desctop/setting_desctoop_screen.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  static const routeName = '/setting';

  @override
  Widget build(BuildContext context) {
    return _SettingViewContent();
  }
}

class _SettingViewContent extends StatefulWidget {
  @override
  State<_SettingViewContent> createState() => _SettingViewContentState();
}

class _SettingViewContentState extends State<_SettingViewContent> {
  late SettingCubit _settingCubit;
  late bool _isNotificationEnabled;
  bool _isUpdateAvailable = false;
  bool _isCheckingVersion = true;
  String? _storeVersion;
  String? _appStoreLink;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _checkVersion() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _checkVersionAndroid();
      } else {
        await _checkVersionIOS();
      }
    } catch (e) {
      debugPrint('Version check error: $e');
      if (mounted) {
        setState(() {
          _isUpdateAvailable = false;
          _isCheckingVersion = false;
        });
      }
    }
  }

  /// Android: Uses Play Core API which compares versionCode (build number)
  /// This correctly detects build-number-only updates (e.g. 1.0.0+9 → 1.0.0+10)
  Future<void> _checkVersionAndroid() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      // Also get store link from new_version_plus for the launch URL
      final newVersion = NewVersionPlus();
      final status = await newVersion.getVersionStatus();

      if (mounted) {
        setState(() {
          _storeVersion = status?.storeVersion ?? _packageInfo.version;
          _appStoreLink = status?.appStoreLink;
          _isUpdateAvailable = updateInfo.updateAvailability ==
              UpdateAvailability.updateAvailable;
          _isCheckingVersion = false;
        });
      }
    } catch (e) {
      // Fallback to new_version_plus if Play Core fails
      // (e.g. app not installed from Play Store, or during development)
      debugPrint('Play Core check failed, falling back: $e');
      await _checkVersionIOS();
    }
  }

  /// iOS: Uses iTunes Lookup API via new_version_plus
  /// Compares version names (e.g. 1.0.0 vs 1.0.1)
  Future<void> _checkVersionIOS() async {
    final newVersion = NewVersionPlus();
    final status = await newVersion.getVersionStatus();

    if (status != null && mounted) {
      setState(() {
        _storeVersion = status.storeVersion;
        _isUpdateAvailable = status.canUpdate;
        _appStoreLink = status.appStoreLink;
        _isCheckingVersion = false;
      });
    } else if (mounted) {
      setState(() => _isCheckingVersion = false);
    }
  }

  Future<void> _launchStore() async {
    if (_appStoreLink != null) {
      final uri = Uri.parse(_appStoreLink!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ToastService.showSuccess(context, "تعذر فتح المتجر");
        }
      }
    }
  }

  @override
  void initState() {
    _isNotificationEnabled = AuthenticationProvider
            .instance.currentUser?.details.notificationEnabled ??
        false;
    _settingCubit = context.read<SettingCubit>();
    _initPackageInfo();
    _checkVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1100) {
            return BlocBuilder<SettingCubit, SettingState>(
              builder: (context, state) {
                return SettingDesktopScreen(
                  state: state,
                  settingCubit: _settingCubit,
                );
              },
            );
          }
          final bool isTablet = constraints.maxWidth >= 600;
          if (isTablet) {
            return SettingViewTablet(
              settingCubit: _settingCubit,
              isNotificationEnabled: _isNotificationEnabled,
              isUpdateAvailable: _isUpdateAvailable,
              isCheckingVersion: _isCheckingVersion,
              storeVersion: _storeVersion,
              appStoreLink: _appStoreLink,
              packageInfo: _packageInfo,
              onToggleNotification: () {
                _settingCubit.toggleNotification();
                BlocProvider.of<SettingCubit>(context)
                    .stream
                    .firstWhere(
                      (state) => state.isSuccessToggle || state.isErrorToggle,
                    )
                    .then((state) {
                  if (state.isSuccessToggle && mounted) {
                    AuthenticationProvider.instance.refreshUser();
                    setState(() {
                      _isNotificationEnabled = !_isNotificationEnabled;
                    });
                  }
                });
              },
              onLaunchStore: _launchStore,
            );
          }
          return SafeArea(
            child: Column(
              children: [
                CustomStudentHeader(
                  title: context.l10n.settings,
                  showNotification: true,
                  icon: Icons.settings,
                  showLeading: true,
                ),
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
                      return ModalProgressHUD(
                        inAsyncCall:
                            state.isLoadingToggle || state.isLoadingDelete,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.all(
                                AppResponsive.getPadding(context)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                    context,
                                    context.l10n.customization,
                                    Icons.palette_outlined,
                                    true),
                                SizedBox(height: 12),
                                BlocBuilder<ThemeCubit, ThemeState>(
                                  builder: (context, state) {
                                    final isDark = state.isDark;
                                    return SettingsTile(
                                      title: context.l10n.app_theme,
                                      subtitle: isDark
                                          ? context.l10n.dark_theme
                                          : context.l10n.light_theme,
                                      icon: isDark
                                          ? CupertinoIcons.moon_fill
                                          : CupertinoIcons.sun_max_fill,
                                      iconBackgroundColor: isDark
                                          ? MyColors.warning500
                                          : MyColors.primaryColor,
                                      trailingWidget: Transform.scale(
                                        scale: 0.85,
                                        child: Switch(
                                          value: isDark,
                                          onChanged: (bool value) async {
                                            final themeCubit =
                                                DependencyInjector.themeCubit;
                                            themeCubit.setThemeMode(
                                              value
                                                  ? ThemeMode.dark
                                                  : ThemeMode.light,
                                            );
                                            final themeIdToSend = value ? 2 : 1;
                                            await themeCubit.updatePreference(
                                              UpdatePreference(
                                                themeId: themeIdToSend,
                                                languageId:
                                                    AuthenticationProvider
                                                            .instance
                                                            .currentUser
                                                            ?.details
                                                            .preference
                                                            .languageId ??
                                                        0,
                                              ),
                                            );
                                          },
                                          activeThumbColor: MyColors.darkGreen,
                                          activeTrackColor:
                                              MyColors.darkGreen.withValues(
                                            alpha: 0.3,
                                          ),
                                          inactiveThumbColor:
                                              MyColors.goldAccent,
                                          inactiveTrackColor: MyColors
                                              .goldAccent
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                BlocListener<SettingCubit, SettingState>(
                                  listener: (context, state) {
                                    if (state.isErrorToggle) {
                                      ToastService.showError(
                                        context,
                                        state.errorMessage.toString(),
                                      );
                                    }
                                    if (state.isSuccessToggle) {
                                      AuthenticationProvider.instance
                                          .refreshUser();
                                      setState(() {
                                        _isNotificationEnabled =
                                            !_isNotificationEnabled;
                                      });
                                    }
                                  },
                                  child: SettingsTile(
                                    title: context.l10n.notification,
                                    subtitle: _isNotificationEnabled
                                        ? context.l10n.activated
                                        : context.l10n.disabled,
                                    icon: _isNotificationEnabled
                                        ? Icons.notifications_active
                                        : Icons.notifications_off_outlined,
                                    iconBackgroundColor: MyColors.success500,
                                    trailingWidget: Transform.scale(
                                      scale: 0.85,
                                      child: Switch(
                                        value: _isNotificationEnabled,
                                        onChanged: (value) {
                                          _settingCubit.toggleNotification();
                                        },
                                        activeThumbColor: MyColors.success500,
                                        activeTrackColor: MyColors.success500
                                            .withValues(alpha: 0.3),
                                        inactiveThumbColor: MyColors.neutral400,
                                        inactiveTrackColor: MyColors.neutral200,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24),
                                _buildSectionHeader(
                                  context,
                                  context.l10n.security_privacy,
                                  Icons.security_outlined,
                                  false,
                                ),
                                SizedBox(height: 12),
                                SettingsTile(
                                  title: context.l10n.change_password,
                                  subtitle: context.l10n.change_your_password,
                                  icon: Icons.lock_outline,
                                  iconBackgroundColor: MyColors.warning500,
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        ChangePasswordScreen.routeName);
                                  },
                                ),
                                SettingsTile(
                                  title: context.l10n.delete_account,
                                  subtitle: context.l10n.delete_account_warning,
                                  icon: Icons.delete_outline,
                                  iconBackgroundColor: MyColors.error500,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(context
                                              .l10n.delete_account_warning),
                                          content: Text(context
                                              .l10n.delete_account_message),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(context.l10n.cancel),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _settingCubit.deleteAccount();
                                              },
                                              child: Text(
                                                  context.l10n.delete_account),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                // SettingsTile(
                                //   title: context.l10n.privacy_policy,
                                //   subtitle: context.l10n.privacy_policy_and_terms,
                                //   icon: Icons.privacy_tip_outlined,
                                //   iconBackgroundColor: MyColors.primaryColor,
                                //   onTap: () {
                                //     Navigator.pushNamed(
                                //         context, PrivacyPolicyScreen.routeName);
                                //   },
                                // ),
                                // SizedBox(height: 24),
                                // _buildSectionHeader(
                                //     context,
                                //     context.l10n.help_and_support,
                                //     Icons.help_outline,
                                //     false),
                                // SizedBox(height: 12),
                                // SettingsTile(
                                //   title: context.l10n.faqs,
                                //   subtitle: context.l10n.frequently,
                                //   icon: Icons.question_answer_outlined,
                                //   iconBackgroundColor: MyColors.error500,
                                //   onTap: () {
                                //     Navigator.pushNamed(context, FAQsScreen.routeName);
                                //   },
                                // ),
                                // SettingsTile(
                                //   title: context.l10n.contact_us,
                                //   subtitle: context.l10n.get_help_support,
                                //   icon: Icons.headset_mic_outlined,
                                //   iconBackgroundColor: MyColors.lightTeal,
                                //   onTap: () {
                                //     Navigator.pushNamed(
                                //         context, ContactUsScreen.routeName);
                                //   },
                                // ),
                                SizedBox(height: 24),
                                _buildSectionHeader(
                                  context,
                                  context.l10n.application_info,
                                  Icons.info_outline,
                                  false,
                                ),
                                SizedBox(height: 12),
                                SettingsTile(
                                  title: context.l10n
                                      .version(_packageInfo.buildNumber),
                                  subtitle: _isUpdateAvailable &&
                                          _storeVersion != null
                                      ? context.l10n.current_and_store_version(
                                          _packageInfo.version,
                                          _storeVersion!,
                                        )
                                      : context.l10n.current_version(
                                          _packageInfo.version,
                                        ),
                                  icon: Icons.info_outlined,
                                  onTap: _isUpdateAvailable &&
                                          _appStoreLink != null
                                      ? _launchStore
                                      : null,
                                  iconBackgroundColor: MyColors.neutral400,
                                  trailingWidget: _isCheckingVersion
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: MyColors.neutral400,
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: _isUpdateAvailable
                                                ? MyColors.warning100
                                                : MyColors.success100,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (_isUpdateAvailable) ...[
                                                Icon(
                                                  Icons.download_outlined,
                                                  color: MyColors.warning700,
                                                ),
                                                SizedBox(width: 4),
                                              ],
                                              MainText(
                                                _isUpdateAvailable
                                                    ? context.l10n.update_now
                                                    : context.l10n.up_to_date,
                                                fontSize:
                                                    AppResponsive.getFontSize(
                                                        context,
                                                        mobile: 11,
                                                        smallTablet: 13,
                                                        largeTablet: 14),
                                                fontWeight: FontWeight.w600,
                                                color: _isUpdateAvailable
                                                    ? MyColors.warning700
                                                    : MyColors.success700,
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    bool showBack,
  ) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: MyColors.darkGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: AppResponsive.getIconSize(context, base: 10),
              color: MyColors.darkGreen,
            ),
          ),
          SizedBox(width: 10),
          MainText(
            title,
            fontSize: AppResponsive.getFontSize(context,
                mobile: 14, smallTablet: 16, largeTablet: 18),
            fontWeight: FontWeight.w700,
            color: context.isDark ? MyColors.white : MyColors.neutral700,
          ),
          // Spacer(),
          // if (showBack == true) RedoBack(),
        ],
      ),
    );
  }
}
