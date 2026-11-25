import '../../../../../core/utils/styles_link.dart';
import '../../../../../shared/screens/mobile/language/language_screen.dart';
import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../../auth/presentation/login/view/login.dart';
import '../../../../setting/presentation/view/setting_view.dart';
import '../../../../user/domain/entities/user_details.dart';

class StudentMenuList extends StatelessWidget {
  const StudentMenuList({
    super.key,
    required this.user,
    this.onLogoutStart,
    this.onLogoutEnd,
  });

  final UserDetails? user;
  final VoidCallback? onLogoutStart; 
  final VoidCallback? onLogoutEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8, bottom: 12),
            child: MainText(
              context.l10n.list,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: context.isDark ? MyColors.white : MyColors.black900,
            ),
          ),
          MenuItemWidget(
            isIcon: true,
            iconData: Icons.receipt_long_outlined,
            title: context.l10n.order_history,
            iconBackgroundColor: MyColors.primaryColor,
            onTap: () {
             
            },
          ),
          MenuItemWidget(
            isIcon: true,
            iconData: Icons.assignment_outlined,
            title: context.l10n.my_assessment,
            iconBackgroundColor: MyColors.primaryColor,
            onTap: () {
              
            },
          ),
          MenuItemWidget(
            icon: SvgAssets.setting,
            title: context.l10n.settings,
            iconBackgroundColor: MyColors.primaryColor,
            onTap: () {
              Navigator.pushNamed(
                context,
                SettingView.routeName,
              );
            },
          ),
          MenuItemWidget(
            icon: SvgAssets.language,
            title: context.l10n.language,
            iconBackgroundColor: MyColors.warning500,
            trailing: MainText(
              context.l10n.localeName != 'ar' ? 'English' : 'العربية',
              color: context.isDark ? MyColors.grey300 : MyColors.black900,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                LanguageScreen.routeName,
              );
            },
          ),
          // MenuItemWidget(
          //   icon: SvgAssets.delete,
          //   title: context.l10n.delete_account,
          //   iconBackgroundColor: MyColors.error500,
          //   onTap: () async {
          //     final result = await DeleteAccountBottomSheet.show(
          //       context,
          //       onDeleteAccount: () async {
          //         // final authCubit = context.read<AuthCubit>();
          //         // await authCubit.deleteAccount();
          //       },
          //     );
          //     if (result == true) {
          //       Navigator.pushNamedAndRemoveUntil(
          //         context,
          //         LoginView.routeName,
          //         (route) => false,
          //       );
          //     }
          //   },
          // ),
          MenuItemWidget(
            icon: SvgAssets.logout,
            title: context.l10n.logout,
            iconBackgroundColor: MyColors.darkGreen,
            onTap: () async {
              final confirmed = await LogoutBottomSheet.show(
                context,
              );
              if (confirmed == true && context.mounted) {
                onLogoutStart?.call();

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                } finally {
                  if (context.mounted) {
                    onLogoutEnd?.call();
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({
    super.key,
    this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
    this.isWallet = false,
    this.iconBackgroundColor,
    this.isIcon = false,
    this.iconData,
  });

  final String? icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isWallet;
  final Color? iconBackgroundColor;
  final bool isIcon;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(8),
        //border: theme.primaryBorder,
        boxShadow: theme.mediumShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon with colored background
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: (iconBackgroundColor ?? MyColors.primaryColor)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: isIcon
                        ? Icon(
                            iconData,
                            color: iconBackgroundColor ?? MyColors.primaryColor,
                          )
                        : SvgPicture.asset(
                            icon ?? '',
                            width: 22,
                            height: 22,
                            colorFilter: ColorFilter.mode(
                              iconBackgroundColor ?? MyColors.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 16),
                // Title
                Expanded(
                  child: MainText(
                    title,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.isDark ? MyColors.white : MyColors.black900,
                  ),
                ),
                // Trailing
                if (trailing != null)
                  trailing!
                else
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.isDark
                          ? MyColors.darkItemBG3
                          : MyColors.neutral100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RotationTransition(
                      turns: context.isArabic
                          ? AlwaysStoppedAnimation(180 / 360)
                          : AlwaysStoppedAnimation(0),
                      child: Icon(
                        context.isArabic
                            ? Icons.arrow_back_ios
                            : Icons.arrow_forward_ios,
                        size: 14,
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
