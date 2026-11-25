import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import '../../core/authentication/provider.dart';
import '../../core/extension/extension_helper.dart';
import '../../core/resources/images.dart';
import '../../core/style/app_colors.dart';
import '../../core/style/theme/extensions/app_theme_extension.dart';
import '../../feature/notifications/presentation/provider/provider_count.dart';
import '../../feature/notifications/presentation/view/notification_screen.dart';
import '../cubits/theme/theme_cubit.dart';
import '../enum/user_role.dart';
import 'custom_network_image.dart';
import 'main_text.dart';

class CustomStudentHeader extends StatelessWidget {
  const CustomStudentHeader({
    super.key,
    required this.title,
    this.subTitle,
    this.icon,
    this.image,
    this.leadingIcon,
    this.onLeadingTap,
    this.onDeleteTap,
    this.showLeading = false,
    this.showNotification = false,
    this.showBack = false,
    this.showDelete = false,
    this.showRequired = false,
    this.showParent = true,
    this.iconRequired,
    this.onTapRequired,
  });

  final String title;
  final String? subTitle;
  final String? image;
  final IconData? icon;
  final IconData? iconRequired;
  final VoidCallback? onTapRequired;
  final bool? showRequired;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingTap;
  final VoidCallback? onDeleteTap;
  final bool? showLeading;
  final bool? showNotification;
  final bool? showBack;
  final bool? showDelete;
  final bool? showParent;

  @override
  Widget build(BuildContext context) {
    var userDetail = AuthenticationProvider.instance.currentUser?.details;
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            gradient: theme.primaryGradient,
            boxShadow: theme.mediumShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  if (showLeading == true &&
                      showParent == true &&
                      defaultTargetPlatform == TargetPlatform.iOS)
                    GestureDetector(
                      onTap: onLeadingTap ?? () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: MyColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: MyColors.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1200),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: value * 2 * math.pi,
                        child: icon != null
                            ? Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      MyColors.primaryColor,
                                      MyColors.lightTeal,
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  icon,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              )
                            : EnhancedNetworkImageWidget(
                                imageUrl: image,
                                fallbackAssetImage: ImagesAssets.logo,
                                fit: BoxFit.contain,
                                width: 60,
                                height: 60,
                                shape: BoxShape.circle,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                useShimmerEffect: true,
                                shimmerBaseColor: const Color(0xFFDCEDC8),
                                shimmerHighlightColor: const Color(0xFFF1F8E9),
                              ),
                      );
                    },
                  ),
                  16.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText.bigText(
                          title.length > 20
                              ? '${title.substring(0, 20)}...'
                              : title,
                          fontSize: 16,
                          color: context.isDark
                              ? MyColors.white
                              : MyColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                        if (subTitle != null && subTitle != "")
                          MainText(
                            subTitle!,
                            fontSize: 12,
                            color: context.isDark
                                ? MyColors.grey300
                                : MyColors.grey4,
                            fontWeight: FontWeight.w400,
                          ),
                      ],
                    ),
                  ),
                  if (showDelete == true)
                    GestureDetector(
                      onTap: onDeleteTap,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: MyColors.customRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: MyColors.customRed.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.delete_sweep_rounded,
                          color: MyColors.customRed,
                          size: 22,
                        ),
                      ),
                    ),
                  if (AuthenticationProvider.instance.isAuthenticated &&
                      showNotification == true &&
                      userDetail?.role.id != UserRole.parent.id)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          NotificationsScreen.routeName,
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // أيقونة الإشعارات بحجم ثابت
                          Icon(
                            Icons.notifications_outlined,
                            color: MyColors.primaryColor,
                            size: 40,
                          ),
                          // Badge محسّن
                          Positioned(
                            right: -2,
                            top: -4,
                            child: StreamBuilder<int>(
                              stream: NotificationsProvider
                                  .instance.notificationsCount,
                              builder: (context, snapshot) {
                                final count = snapshot.data ?? 0;
                                if (count == 0) {
                                  return const SizedBox.shrink();
                                }

                                // تحديد النص المعروض
                                final displayText =
                                    count > 99 ? '+99' : count.toString();

                                // تحديد حجم البadge بناءً على عدد الأرقام
                                final isLargeNumber = count > 99;
                                final badgeSize = isLargeNumber ? 32.0 : 26.0;
                                final fontSize = isLargeNumber ? 9.0 : 11.0;

                                return Container(
                                  constraints: BoxConstraints(
                                    minWidth: badgeSize,
                                    minHeight: badgeSize,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isLargeNumber ? 6.0 : 4.0,
                                    vertical: isLargeNumber ? 3.0 : 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.islamicGold,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: MainText(
                                      displayText,
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w700,
                                      color: MyColors.white,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (showRequired == true &&
                      userDetail?.role.id != UserRole.parent.id)
                    GestureDetector(
                      onTap: onTapRequired,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: MyColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          iconRequired,
                          color: MyColors.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
