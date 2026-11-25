import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/utils/styles_link.dart';
import '../../../../shared/screens/mobile/language/language_screen.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../auth/presentation/login/view/login.dart';
import '../../../notifications/presentation/provider/provider_count.dart';
import '../../../notifications/presentation/view/notification_screen.dart';
import '../../../setting/presentation/view/setting_view.dart';
import '../../../user/domain/entities/user_details.dart';
import 'profile_view.dart';

class StudentProfileScreenTabletView extends StatelessWidget {
  const StudentProfileScreenTabletView({
    super.key,
    required this.user,
    required this.isLoggingOut,
    required this.packageInfo,
    required this.onLogoutStart,
    required this.onLogoutEnd,
    required this.onRefresh,
  });

  final UserDetails? user;
  final bool isLoggingOut;
  final PackageInfo packageInfo;
  final VoidCallback onLogoutStart;
  final VoidCallback onLogoutEnd;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ModalProgressHUD(
        inAsyncCall: isLoggingOut,
        child: Scaffold(
          body: Row(
            children: [
              // Left Panel: Dashboard Profile Box
              Expanded(
                flex: AppResponsive.getFontSize(
                  context,
                  mobile: 0,
                  smallTablet: 42,
                  largeTablet: 36,
                ).toInt(),
                child: _DashboardProfilePanel(
                  user: user,
                  packageInfo: packageInfo,
                ),
              ),
              // Right Panel: Grid Menu Options
              Expanded(
                flex: AppResponsive.getFontSize(
                  context,
                  mobile: 100,
                  smallTablet: 58,
                  largeTablet: 65,
                ).toInt(),
                child: SafeArea(
                  child: _GridMenuPanel(
                    user: user,
                    onLogoutStart: onLogoutStart,
                    onLogoutEnd: onLogoutEnd,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardProfilePanel extends StatelessWidget {
  const _DashboardProfilePanel({required this.user, required this.packageInfo});

  final UserDetails? user;
  final PackageInfo packageInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MyColors.darkGreen,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MyColors.primaryColor, MyColors.darkGreen],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.goldAccent.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
      
          // Top Buttons (Notification)
          if (user?.role.id != UserRole.parent.id)
            Positioned(
              top: 24,
              left: context.isArabic ? 24 : null,
              right: context.isArabic ? null : 24,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamed(NotificationsScreen.routeName);
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: MyColors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: MyColors.white,
                        size: AppResponsive.getIconSize(context, base: 24),
                      ),
                    ),
                    Positioned(
                      right: -12,
                      top: -12,
                      child: StreamBuilder<int>(
                        stream:
                            NotificationsProvider.instance.notificationsCount,
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          final data = count > 99 ? '+99' : count.toString();
                          if (count == 0) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: const BoxDecoration(
                              color: MyColors.islamicGold,
                              shape: BoxShape.circle,
                            ),
                            child: MainText(
                              data,
                              fontSize: AppResponsive.getFontSize(
                                context,
                                mobile: 14,
                                smallTablet: 14,
                                largeTablet: 16,
                              ),
                              fontWeight: FontWeight.w700,
                              color: MyColors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      
          // Main Details Centered
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppResponsive.getFontSize(
                    context,
                    mobile: 100,
                    smallTablet: 110,
                    largeTablet: 140,
                  ),
                  height: AppResponsive.getFontSize(
                    context,
                    mobile: 100,
                    smallTablet: 110,
                    largeTablet: 140,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.goldAccent.withValues(alpha: 0.4),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.black900,
                    ),
                    child: ClipOval(
                      child: user?.image != null
                          ? EnhancedNetworkImageWidget(
                              imageUrl: user?.image,
                              fallbackAssetImage: ImagesAssets.logo,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: MainText(
                                user?.fullName.isNotEmpty == true
                                    ? user!.fullName
                                          .substring(0, 1)
                                          .toUpperCase()
                                    : "S",
                                color: MyColors.goldAccent,
                                fontSize: AppResponsive.getFontSize(
                                  context,
                                  mobile: 32,
                                  smallTablet: 40,
                                  largeTablet: 48,
                                ),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                MainText(
                  user?.fullName ?? "",
                  fontSize: AppResponsive.getFontSize(
                    context,
                    mobile: 24,
                    smallTablet: 26,
                    largeTablet: 32,
                  ),
                  fontWeight: FontWeight.w800,
                  color: MyColors.white,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Row(
                  spacing: 12,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: MainText(
                        user?.email ?? '',
                        fontSize: AppResponsive.getFontSize(
                          context,
                          mobile: 16,
                          smallTablet: 18,
                          largeTablet: 22,
                        ),
                        color: MyColors.neutral300,
                        fontWeight: FontWeight.w500,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ProfileView.routeName,
                      arguments: user,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: MyColors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      spacing: 8,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          color: MyColors.white,
                          size: 20,
                        ),
                        MainText(
                          context.l10n.personal_information,
                          color: MyColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      
          // Footer / App Version
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  MainText(
                    'Tiba Education App',
                    fontSize: AppResponsive.getFontSize(
                      context,
                      mobile: 12,
                      smallTablet: 13,
                      largeTablet: 14,
                    ),
                    color: MyColors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                  MainText(
                    context.l10n.version(packageInfo.version),
                    fontSize: AppResponsive.getFontSize(
                      context,
                      mobile: 10,
                      smallTablet: 11,
                      largeTablet: 12,
                    ),
                    color: MyColors.white.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridMenuPanel extends StatelessWidget {
  const _GridMenuPanel({
    required this.user,
    required this.onLogoutStart,
    required this.onLogoutEnd,
  });

  final UserDetails? user;
  final VoidCallback onLogoutStart;
  final VoidCallback onLogoutEnd;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainText(
            context.l10n.list,
            fontSize: AppResponsive.getFontSize(
              context,
              mobile: 24,
              smallTablet: 26,
              largeTablet: 28,
            ),
            fontWeight: FontWeight.w800,
            color: isDark ? MyColors.white : MyColors.black900,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount:
                  AppResponsive.getCategory(context) ==
                      DeviceCategory.largeTablet
                  ? 2
                  : 1,
              childAspectRatio:
                  AppResponsive.getCategory(context) ==
                      DeviceCategory.largeTablet
                  ? 2.2
                  : 3.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildGridItem(
                  context: context,
                  title: context.l10n.order_history,
                  iconData: Icons.receipt_long_outlined,
                  iconBackgroundColor: MyColors.primaryColor,
                  isIcon: true,
                  onTap: () {
                    
                  },
                ),
                _buildGridItem(
                  context: context,
                  title: context.l10n.my_assessment,
                  iconData: Icons.assignment_outlined,
                  iconBackgroundColor: MyColors.primaryColor,
                  isIcon: true,
                  onTap: () {
                    
                  },
                ),
                _buildGridItem(
                  context: context,
                  title: context.l10n.settings,
                  icon: SvgAssets.setting,
                  iconBackgroundColor: MyColors.primaryColor,
                  onTap: () {
                    Navigator.pushNamed(context, SettingView.routeName);
                  },
                ),
                _buildGridItem(
                  context: context,
                  title: context.l10n.language,
                  icon: SvgAssets.language,
                  iconBackgroundColor: MyColors.warning500,
                  trailing: MainText(
                    context.l10n.localeName != 'ar' ? 'English' : 'العربية',
                    color: isDark ? MyColors.grey300 : MyColors.black900,
                    fontSize: AppResponsive.getFontSize(
                      context,
                      mobile: 12,
                      smallTablet: 13,
                      largeTablet: 14,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, LanguageScreen.routeName);
                  },
                ),
                _buildGridItem(
                  context: context,
                  title: context.l10n.logout,
                  icon: SvgAssets.logout,
                  iconBackgroundColor: MyColors.darkGreen,
                  onTap: () async {
                    final confirmed = await LogoutBottomSheet.show(context);
                    if (confirmed == true && context.mounted) {
                      onLogoutStart();
                      try {
                        await AuthenticationProvider.instance.logout();
                        if (context.mounted) {
                          await Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginView.routeName,
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      } finally {
                        if (context.mounted) {
                          onLogoutEnd();
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
    String? icon,
    IconData? iconData,
    Color? iconBackgroundColor,
    bool isIcon = false,
    Widget? trailing,
  }) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    final isDark = context.isDark;

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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: AppResponsive.getFontSize(
                    context,
                    mobile: 48,
                    smallTablet: 52,
                    largeTablet: 56,
                  ),
                  height: AppResponsive.getFontSize(
                    context,
                    mobile: 48,
                    smallTablet: 52,
                    largeTablet: 56,
                  ),
                  decoration: BoxDecoration(
                    color: (iconBackgroundColor ?? MyColors.primaryColor)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: isIcon
                        ? Icon(
                            iconData,
                            size: AppResponsive.getIconSize(context, base: 18),
                            color: iconBackgroundColor ?? MyColors.primaryColor,
                          )
                        : SvgPicture.asset(
                            icon ?? '',
                            width: AppResponsive.getIconSize(context, base: 18),
                            height: AppResponsive.getIconSize(
                              context,
                              base: 18,
                            ),
                            colorFilter: ColorFilter.mode(
                              iconBackgroundColor ?? MyColors.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: MainText(
                    title,
                    fontSize: AppResponsive.getFontSize(
                      context,
                      mobile: 16,
                      smallTablet: 17,
                      largeTablet: 18,
                    ),
                    fontWeight: FontWeight.w600,
                    color: isDark ? MyColors.white : MyColors.black900,
                  ),
                ),
                if (trailing != null)
                  trailing
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? MyColors.darkItemBG3
                          : MyColors.neutral100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RotationTransition(
                      turns: context.isArabic
                          ? const AlwaysStoppedAnimation(180 / 360)
                          : const AlwaysStoppedAnimation(0),
                      child: Icon(
                        Icons
                            .arrow_forward_ios, // Arrow forward works natively with the rotation
                        size: AppResponsive.getIconSize(context, base: 10),
                        color: MyColors.neutral600,
                      ),
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
