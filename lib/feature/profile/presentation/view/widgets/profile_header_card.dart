import 'package:flutter/material.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/theme/extensions/app_colors_extension.dart';
import '../../../../../core/style/theme/extensions/app_theme_extension.dart';
import '../../../../../l10n/l10n.dart';
import '../../../../../shared/widgets/custom_network_image.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../../user/domain/entities/user_details.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key, required this.user});

  final UserDetails? user;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<AppColorsExtension>()!;
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        gradient: theme.primaryGradient,
        borderRadius: BorderRadius.circular(8),
        border: theme.primaryBorder,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            spacing: 8,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: user?.image != null
                        ? ClipOval(
                            child: EnhancedNetworkImageWidget(
                              imageUrl: user?.image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeHolderWidget: _buildDefaultAvatar(),
                              //fallbackAssetImage: 'assets/images/avatar.png',
                            ),
                          )
                        : _buildDefaultAvatar(),
                  ),
                ),
              ),
              // User Name
              MainText.bigText(
                user?.fullName ?? 'الاسم كامل',
                fontSize: 24,
                color: color.textColor,
                textAlign: TextAlign.center,
              ),
              MainText(
                "${context.l10n.user_name} : ${user?.username}",
                fontSize: 16,
                color: color.subTextColor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // Positioned(
          //   right: context.isArabic ? null : -5,
          //   left: context.isArabic ? -5 : null,
          //   child: RedoBack(),
          // ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.primaryColor..withValues(alpha: 0.8),
            MyColors.primaryColor,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_rounded,
        size: 50,
        color: Colors.white,
      ),
    );
  }
}
