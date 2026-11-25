import 'package:flutter/material.dart';
import '../../../../../core/resources/images.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../shared/widgets/custom_network_image.dart';
import '../../../../../shared/widgets/main_text.dart';
import '../../../../user/domain/entities/user_details.dart';
import '../profile_view.dart';


class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key, required this.user});

  final UserDetails? user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProfileView.routeName, arguments: user);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [MyColors.darkGreen, MyColors.deepGreen],
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: MyColors.darkGreen.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles in background
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.goldAccent.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -40,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      user?.image != null
                          ? EnhancedNetworkImageWidget(
                              imageUrl: user?.image,
                              fallbackAssetImage: ImagesAssets.logo,
                              fit: BoxFit.contain,
                              width: 100,
                              height: 100,
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
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: MyColors.goldAccent.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyColors.black900,
                                ),
                                child: Center(
                                  child: MainText(
                                    user?.fullName
                                            .substring(0, 1)
                                            .toUpperCase() ??
                                        "",
                                    color: MyColors.goldAccent,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(width: 16),
                      // User info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 3,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: MainText(
                                    user?.fullName ?? "",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: MyColors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 6,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: MyColors.neutral300,
                                  size: 14,
                                ),
                                Flexible(
                                  child: MainText(
                                    user?.email ?? '',
                                    fontSize: 12,
                                    color: MyColors.neutral300,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Edit icon
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MyColors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: MyColors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
